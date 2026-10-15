#include "PCH.h"
#include "ServiceState.h"
#include "Scheduler.h"
#include "EventPump.h"

#include <spdlog/sinks/basic_file_sink.h>
#include <RE/B/BSInputDeviceManager.h>
#include <RE/I/InputEvent.h>

namespace DeD
{
	bool RegisterPapyrusFunctions(RE::BSScript::IVirtualMachine* a_vm);
}

// ---------------------------------------------------------------------------
// Scheduler drive: input-event sink as the main-thread frame callback (the
// dll-source-gs proven pattern). The device manager pumps this sink per
// frame (quiet frames arrive with an empty event list), which gives the
// scheduler a zero-thread, zero-hook frame drive; Drive() self-throttles to
// one evaluation pass per second. Input is untouched (always kContinue).
// ---------------------------------------------------------------------------
class ServiceDriveSink : public RE::BSTEventSink<RE::InputEvent*> {
public:
    static ServiceDriveSink* GetSingleton() {
        static ServiceDriveSink instance;
        return &instance;
    }

    RE::BSEventNotifyControl ProcessEvent(RE::InputEvent* const*,
                                          RE::BSTEventSource<RE::InputEvent*>*) override {
        DeD::Scheduler::GetSingleton().Drive();
        return RE::BSEventNotifyControl::kContinue;
    }
};

static void SetupLog() {
    auto logsFolder = SKSE::log::log_directory();
    if (!logsFolder) return;
    auto logPath = *logsFolder / "DeDService.log";
    auto sink = std::make_shared<spdlog::sinks::basic_file_sink_mt>(logPath.string(), true);
    auto logger = std::make_shared<spdlog::logger>("DeDService", std::move(sink));
    logger->set_level(spdlog::level::trace);
    logger->flush_on(spdlog::level::trace);
    spdlog::set_default_logger(std::move(logger));
}

// ---------------------------------------------------------------------------
// Cosave handler (spec section 2.1/2.2 binding constraints; section 0.3
// adoptions: tag + version per record, receipt logging on Save/Load/Revert).
// ---------------------------------------------------------------------------
static void OnSaveCallback(SKSE::SerializationInterface* a_intfc)
{
    auto& state = DeD::ServiceState::GetSingleton();
    auto& sched = DeD::Scheduler::GetSingleton();
    {
        std::lock_guard lock(state.m_mutex);
        const auto buf = state.Save();
        if (!a_intfc->WriteRecord(DeD::ServiceState::kRecordType,
                                  DeD::ServiceState::kSchemaVersion,
                                  buf.data(), static_cast<std::uint32_t>(buf.size()))) {
            SKSE::log::error("[DeDService] STTE save failed.");
        }
    }
    {
        std::lock_guard lock(sched.m_mutex);
        const auto buf = sched.Save();
        if (!a_intfc->WriteRecord(DeD::Scheduler::kRecordType,
                                  DeD::Scheduler::kSchemaVersion,
                                  buf.data(), static_cast<std::uint32_t>(buf.size()))) {
            SKSE::log::error("[DeDService] TMRS save failed.");
        }
    }
}

static void OnLoadCallback(SKSE::SerializationInterface* a_intfc)
{
    std::uint32_t type, version, length;
    while (a_intfc->GetNextRecordInfo(type, version, length)) {
        std::vector<std::uint8_t> data(length);
        if (length > 0 && a_intfc->ReadRecordData(data.data(), length) != length) {
            SKSE::log::warn("[DeDService] record {:08x} short read -- skipped.", type);
            continue;
        }
        if (type == DeD::ServiceState::kRecordType) {
            if (version != DeD::ServiceState::kSchemaVersion) {
                SKSE::log::warn("[DeDService] STTE version {} unsupported -- rejected.", version);
                continue;
            }
            if (!DeD::ServiceState::GetSingleton().Load(a_intfc, length, data.data()))
                SKSE::log::warn("[DeDService] STTE malformed -- state reset.");
        } else if (type == DeD::Scheduler::kRecordType) {
            if (version != DeD::Scheduler::kSchemaVersion) {
                SKSE::log::warn("[DeDService] TMRS version {} unsupported -- rejected.", version);
                continue;
            }
            if (!DeD::Scheduler::GetSingleton().Load(length, data.data()))
                SKSE::log::warn("[DeDService] TMRS malformed -- rules reset.");
        }
        // Unknown tags: skipped silently (standard SKSE shape; spec 0.1.3).
    }
}

static void OnRevertCallback(SKSE::SerializationInterface*)
{
    DeD::ServiceState::GetSingleton().Revert();
    DeD::Scheduler::GetSingleton().Revert();
    SKSE::log::info("[DeDService] reverted (new game / cosave discard).");
}

SKSEPluginLoad(const SKSE::LoadInterface* skse) {
    SKSE::Init(skse);
    SetupLog();
    SKSE::log::info("[DeDService] Plugin loaded.");

    auto* serialization = SKSE::GetSerializationInterface();
    serialization->SetSaveCallback(OnSaveCallback);
    serialization->SetLoadCallback(OnLoadCallback);
    serialization->SetRevertCallback(OnRevertCallback);

    SKSE::GetMessagingInterface()->RegisterListener([](SKSE::MessagingInterface::Message* msg) {
        switch (msg->type) {
        case SKSE::MessagingInterface::kDataLoaded:
            RE::BSInputDeviceManager::GetSingleton()->AddEventSink(ServiceDriveSink::GetSingleton());
            SKSE::log::info("[DeDService] scheduler drive registered (input sink).");
            break;
        }
    });

    SKSE::GetPapyrusInterface()->Register(
        [](RE::BSScript::IVirtualMachine* vm) { return DeD::RegisterPapyrusFunctions(vm); });
    SKSE::log::info("[DeDService] boot complete.");
    return true;
}
