
#include <gep/globalManager.h>

#include <gep/container/DynamicArray.h>
#include <gep/interfaces/logging.h>

#include <assimp/Logger.hpp>
#include <assimp/DefaultLogger.hpp>
#include <assimp/LogStream.hpp>

#include <assimp/Importer.hpp>
#include <assimp/scene.h>
#include <assimp/postprocess.h>

namespace
{
    class AssimpLogger : public Assimp::Logger
    {
        static const char* const s_messagePrefix;

        struct RegisteredLogStream
        {
            Assimp::LogStream* pStream;
            unsigned int severity;

            RegisteredLogStream(Assimp::LogStream* pStream, unsigned int severity)
                : pStream(pStream)
                , severity(severity)
            {
            }

            inline bool isValid() const { return pStream != nullptr; }
            inline void setInvalid() { pStream = nullptr; }

            inline bool accepts(Assimp::Logger::ErrorSeverity severity) const
            {
                return (this->severity & severity) != 0;
            }

            inline bool operator==(const RegisteredLogStream& rhs)
            {
                return pStream == rhs.pStream
                       && severity == rhs.severity;
            }
        };

        gep::DynamicArray<RegisteredLogStream, gep::MallocAllocatorPolicy> m_logStreams;

    public:
        virtual bool attachStream(Assimp::LogStream* pStream, unsigned int severity = Debugging | Err | Warn | Info) override
        {
            GEP_ASSERT(pStream != nullptr, "Invalid stream.");
            RegisteredLogStream request(pStream, severity);
            for (auto& log : m_logStreams)
            {
                if (log == request)
                {
                    // Already attached.
                    return false;
                }
            }

            m_logStreams.append(request);
            return true;
        }

        virtual bool detatchStream(Assimp::LogStream* pStream, unsigned int severity = Debugging | Err | Warn | Info) override
        {
            GEP_ASSERT(pStream != nullptr, "Invalid stream.");
            RegisteredLogStream request(pStream, severity);
            for (auto& log : m_logStreams)
            {
                if (log == request)
                {
                    log.setInvalid();
                    return true;
                }
            }

            return false;
        }

        virtual void OnDebug(const char* message) override
        {
            g_globalManager.getLogging()->logMessage("%s Debug: %s", s_messagePrefix, message);
            Write(message, Debugging);
        }

        virtual void OnInfo(const char* message) override
        {
            g_globalManager.getLogging()->logMessage("%s %s", s_messagePrefix, message);
            Write(message, Info);
        }

        virtual void OnWarn(const char* message) override
        {
            g_globalManager.getLogging()->logWarning("%s %s", s_messagePrefix, message);
            Write(message, Warn);
        }

        virtual void OnError(const char* message) override
        {
            g_globalManager.getLogging()->logError("%s %s", s_messagePrefix, message);
            Write(message, Err);
        }

        void Write(const char* message, ErrorSeverity severity)
        {
            for (auto& log : m_logStreams)
            {
                if (log.isValid() && log.accepts(severity))
                {
                    log.pStream->write(message);
                }
            }
        }
    };
}

const char* const AssimpLogger::s_messagePrefix = "[Assimp]";

/// \note The lambda expression is immediately executed.
static AssimpLogger* g_pAssimpLogger = []
{
    static AssimpLogger l;
    l.setLogSeverity(Assimp::Logger::VERBOSE);
    Assimp::DefaultLogger::set(&l);
    return &l;
}();

void gep::ModelLoader::loadAssimpCompatibleModel(const char* pFilename, uint32 loadWhat)
{
    // Note: All resources allocated by the importer
    //       are destroyed when this scope is left.
    Assimp::Importer importer;

    // clang-format off
    unsigned int importFlags = 0
        | aiProcess_CalcTangentSpace
        | aiProcess_ValidateDataStructure
        | aiProcess_ImproveCacheLocality
        | aiProcess_RemoveRedundantMaterials
        | aiProcess_FindDegenerates
        | aiProcess_FindInvalidData
        | aiProcess_GenUVCoords
        | aiProcess_TransformUVCoords
        | aiProcess_FindInstances
        | aiProcess_GenSmoothNormals
        | aiProcess_Triangulate
    ; // End of `importFlags` definition.
    // clang-format on

    GEP_ASSERT(importer.ValidateFlags(importFlags), "Invalid assimp import flags");

    const auto* pScene = importer.ReadFile(pFilename, importFlags);
    if (pScene == nullptr)
    {
        g_globalManager.getLogging()->logError("Error loading model from file '%s'", pFilename);
        throw LoadingError(importer.GetErrorString());
    }
}
