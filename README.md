# Prop Tool

This is an addon for https://github.com/Relintai/voxelman, to help with creating/editing props.

Props are 3d obects in the world, they can contain lights (VoxelmanLight), meshes (MehDataResorce), and other Props, and scenes.

VoxelmanLights are precalculated lights inside the cunks.
MeshDataResources exists, because you cannot access mesh data in gles2 from normal meshes. Voxelman merges all meshes that you add like this automatically.

Looks like this:

![prop_tool screenshot](screenshots/prop_tool.png)