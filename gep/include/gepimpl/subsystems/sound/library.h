#pragma once

#include "gep/interfaces/sound.h"
#include <fmod.hpp>
#include <fmod_studio.hpp>

namespace gep
{
    // forward declarations
    class FmodSoundLibrary;

    /// \brief interface for loading a a fmod sound library
    class IFmodSoundLibraryLoader : public IResourceLoader
    {
    public:
		IFmodSoundLibraryLoader(const char* resourceId);
        virtual FmodSoundLibrary* loadResource(FmodSoundLibrary* pInPlace) = 0;
        virtual IResource* loadResource(IResource* pInPlace) override;
        virtual void deleteResource(IResource* pResource) override;
        virtual void postLoad(ResourcePtr<IResource> resource) override;
    };

    /// \brief a sound library dummy loader
    class FmodDummySoundLibraryLoader : public IFmodSoundLibraryLoader
    {
    public:
		FmodDummySoundLibraryLoader();
        virtual FmodSoundLibrary* loadResource(FmodSoundLibrary* pInPlace) override;
        virtual IResource* loadResource(IResource* pInPlace) override;
        virtual void deleteResource(IResource* pResource) override;
    
		GEP_RESOURCELOADER_DEFAULT_FUNCTIONS(FmodDummySoundLibraryLoader, "FmodSoundLibrary");
	};

    /// \brief loads a fmod sound library from a file
    class FmodSoundLibraryFileLoader : public IFmodSoundLibraryLoader
    {
    public:
        FmodSoundLibraryFileLoader(const char* filename);
        virtual FmodSoundLibrary* loadResource(FmodSoundLibrary* pInPlace) override;

		GEP_RESOURCELOADER_DEFAULT_FUNCTIONS(FmodSoundLibraryFileLoader, "FmodSoundLibrary");
    };

    /// \brief holds a fmod sound library
    class FmodSoundLibrary : public ISoundLibrary
    {
    private:
        FMOD::Studio::Bank m_bank;
        IFmodSoundLibraryLoader* m_pLoader;
        bool m_isLoaded;

    public:
        FmodSoundLibrary();
        void load(const char* filename);

        //IResource interface
        virtual IResourceLoader* getLoader() override;
        virtual void setLoader(IResourceLoader* loader) override;
        virtual void unload() override;
        virtual void finalize() override;
        virtual uint32 getFinalizeOptions() override;
        virtual bool isLoaded() override;
        virtual IResource* getSuperResource() override;
    };

    /// \brief a dummy sound library
    class FmodDummySoundLibrary : public ISoundLibrary
    {
    private:
        FmodDummySoundLibraryLoader* m_pLoader;
    public:
        FmodDummySoundLibrary();

        //IResource interface
        virtual FmodDummySoundLibraryLoader* getLoader() override;
        virtual void setLoader(IResourceLoader* loader) override;
        virtual void unload() override;
        virtual void finalize() override;
        virtual uint32 getFinalizeOptions() override;
        virtual bool isLoaded() override;
        virtual IResource* getSuperResource() override;
    };
};
