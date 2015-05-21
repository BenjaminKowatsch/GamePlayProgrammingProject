#include "stdafx.h"
#include "gep/exception.h"
#include "gep/utils.h"
#include "gep/modelloader.h"

#include "thModelloader.inl"
#include "AssimpModelloader.inl"

// Common implementation
//////////////////////////////////////////////////////////////////////////

gep::ModelLoader::ModelLoader(IAllocator* pAllocator) :
    m_pModelDataAllocator(nullptr),
    m_pStartMarker(nullptr)
{
    if(pAllocator == nullptr)
        pAllocator = &g_stdAllocator;
    m_pAllocator = pAllocator;
}

gep::ModelLoader::~ModelLoader()
{
    if(m_pModelDataAllocator != nullptr)
    {
        m_pModelDataAllocator->freeToMarker(m_pStartMarker);
        GEP_DELETE(m_pAllocator, m_pModelDataAllocator);
    }
}

void gep::ModelLoader::loadFile(const char* pFilename, uint32 loadWhat)
{
    GEP_ASSERT(!m_modelData.hasData,"LoadFile can only be called once");
    m_filename = pFilename;

    // Check if the file actually exists.
    if(!fileExists(pFilename))
    {
        std::ostringstream msg;
        msg << "File '" << pFilename << "' does not exist";
        throw LoadingError(msg.str());
    }

    auto szFileExtension = gep::findLast(
        pFilename,                     // `begin`
        pFilename + strlen(pFilename), // `end`
        '.');                          // What to look for.

    if (strcmp(szFileExtension, ".thModel") == 0)
    {
        // If the file extension is .thModel, we try to load a thModel...
        loadThModel(pFilename, loadWhat);
    }
    else
    {
        // ... else, we try to load the file using assimp.
        loadAssimpCompatibleModel(pFilename, loadWhat);
    }
}

void gep::ModelLoader::loadFromData(SmartPtr<ReferenceCounted> pDataHolder, ArrayPtr<vec4> vertices, ArrayPtr<uint32> indices)
{
    m_filename = "<from data>";

    auto numIndices = uint32(indices.length());
    auto numVertices = uint32(vertices.length());
    uint32 meshDataSize = 0;
    meshDataSize += allocationSize<MaterialData>(1);
    meshDataSize += allocationSize<MeshData>(1);
    meshDataSize += allocationSize<FaceData>(numIndices / 3);
    meshDataSize += allocationSize<float>(numVertices * 3);
    meshDataSize += allocationSize<NodeData>(1);
    meshDataSize += allocationSize<NodeDrawData>(1);
    meshDataSize += allocationSize<uint32>(1);
    meshDataSize += allocationSize<MeshData*>(1);

    m_pModelDataAllocator = GEP_NEW(m_pAllocator, StackAllocator)(true, meshDataSize, m_pAllocator);
    m_pStartMarker = m_pModelDataAllocator->getMarker();

    m_modelData.rootNode = GEP_NEW(m_pModelDataAllocator, NodeDrawData)();
    m_modelData.rootNode->meshes = GEP_NEW_ARRAY(m_pModelDataAllocator, uint32, 1);
    m_modelData.rootNode->meshes[0] = 0;
    m_modelData.rootNode->transform = mat4::identity().right2Left();
    m_modelData.rootNode->data = GEP_NEW(m_pModelDataAllocator, NodeData);
    m_modelData.rootNode->data->name = "root node";
    m_modelData.rootNode->parent = nullptr;
    auto mesh = GEP_NEW(m_pModelDataAllocator, MeshData)();
    m_modelData.meshes = ArrayPtr<MeshData>(mesh, 1);
    m_modelData.rootNode->data->meshData = GEP_NEW_ARRAY(m_pModelDataAllocator, MeshData*, 1);
    m_modelData.rootNode->data->meshData[0] = mesh;

    vec3 vmin(std::numeric_limits<float>::max());
    vec3 vmax(std::numeric_limits<float>::lowest());
    for(auto& v : vertices)
    {
        if(v.x < vmin.x) vmin.x = v.x;
        if(v.y < vmin.y) vmin.y = v.y;
        if(v.z < vmin.z) vmin.z = v.z;
        if(v.x > vmax.x) vmax.x = v.x;
        if(v.y > vmax.y) vmax.y = v.y;
        if(v.z > vmax.z) vmax.z = v.z;
    }
    mesh->bbox = AABB(vmin, vmax);
    mesh->faces = GEP_NEW_ARRAY(m_pModelDataAllocator, FaceData, indices.length() / 3);

    size_t i=0;
    for(auto& face : mesh->faces)
    {
        face.indices[0] = indices[i];
        face.indices[1] = indices[i + 1];
        face.indices[2] = indices[i + 2];
        i += 3;
    }

    mesh->materialIndex = 0;
    mesh->numFaces = numIndices / 3;
    mesh->vertices = GEP_NEW_ARRAY(m_pModelDataAllocator, vec3, vertices.length());

    i=0;
    for(auto& v : mesh->vertices)
    {
        v = vec3(vertices[i].x, vertices[i].y, vertices[i].z);
        i++;
    }

    m_modelData.materials = GEP_NEW_ARRAY(m_pModelDataAllocator, MaterialData, 1);
    m_modelData.materials[0].name = "dummy material";
    m_modelData.hasData = true;

}
