#!/bin/bash
cd "$(dirname -- "$(readlink -fn -- "${0}")")"

# ./update_external_sources.sh
# cmake -H. -Bbuild -DCMAKE_BUILD_TYPE=Debug -DBUILD_LOADER=ON -DBUILD_TESTS=OFF -DBUILD_LAYERS=OFF -DBUILD_DEMOS=OFF -DBUILD_VKJSON=OFF -DBUILD_ICD=OFF
# cd build
# make VERBOSE=1

mkdir -p "$HOME"/Vulkan-LoaderAndValidationLayers/build/loader

cd "$HOME"/Vulkan-LoaderAndValidationLayers/build/loader

echo "#define HAVE_SECURE_GETENV" > loader_cmake_config.h

python3 "$HOME"/Vulkan-LoaderAndValidationLayers/scripts/lvl_genvk.py -registry "$HOME"/Vulkan-LoaderAndValidationLayers/scripts/vk.xml vk_loader_extensions.h
python3 "$HOME"/Vulkan-LoaderAndValidationLayers/scripts/lvl_genvk.py -registry "$HOME"/Vulkan-LoaderAndValidationLayers/scripts/vk.xml vk_loader_extensions.c

cd "$HOME"/Vulkan-LoaderAndValidationLayers/build

echo '#pragma once' > spirv_tools_commit_id.h
echo '#define SPIRV_TOOLS_COMMIT_ID "5834719fc17d4735fce0102738b87b70255cfd5f"' >> spirv_tools_commit_id.h

python3 "$HOME"/Vulkan-LoaderAndValidationLayers/scripts/lvl_genvk.py -registry "$HOME"/Vulkan-LoaderAndValidationLayers/scripts/vk.xml vk_enum_string_helper.h
python3 "$HOME"/Vulkan-LoaderAndValidationLayers/scripts/lvl_genvk.py -registry "$HOME"/Vulkan-LoaderAndValidationLayers/scripts/vk.xml vk_struct_size_helper.h
python3 "$HOME"/Vulkan-LoaderAndValidationLayers/scripts/lvl_genvk.py -registry "$HOME"/Vulkan-LoaderAndValidationLayers/scripts/vk.xml vk_struct_size_helper.c
python3 "$HOME"/Vulkan-LoaderAndValidationLayers/scripts/lvl_genvk.py -registry "$HOME"/Vulkan-LoaderAndValidationLayers/scripts/vk.xml vk_safe_struct.h
python3 "$HOME"/Vulkan-LoaderAndValidationLayers/scripts/lvl_genvk.py -registry "$HOME"/Vulkan-LoaderAndValidationLayers/scripts/vk.xml vk_safe_struct.cpp
python3 "$HOME"/Vulkan-LoaderAndValidationLayers/scripts/lvl_genvk.py -registry "$HOME"/Vulkan-LoaderAndValidationLayers/scripts/vk.xml vk_object_types.h
python3 "$HOME"/Vulkan-LoaderAndValidationLayers/scripts/lvl_genvk.py -registry "$HOME"/Vulkan-LoaderAndValidationLayers/scripts/vk.xml vk_layer_dispatch_table.h
python3 "$HOME"/Vulkan-LoaderAndValidationLayers/scripts/lvl_genvk.py -registry "$HOME"/Vulkan-LoaderAndValidationLayers/scripts/vk.xml vk_dispatch_table_helper.h
python3 "$HOME"/Vulkan-LoaderAndValidationLayers/scripts/lvl_genvk.py -registry "$HOME"/Vulkan-LoaderAndValidationLayers/scripts/vk.xml vk_extension_helper.h
python3 "$HOME"/Vulkan-LoaderAndValidationLayers/scripts/lvl_genvk.py -registry "$HOME"/Vulkan-LoaderAndValidationLayers/scripts/vk.xml vk_typemap_helper.h

cd "$HOME"/Vulkan-LoaderAndValidationLayers/build/loader

cc -DAPI_NAME=\"Vulkan\" -DEXTRASYSCONFDIR=\"/etc\" -DFALLBACK_CONFIG_DIRS=\"/etc/xdg\" -DFALLBACK_DATA_DIRS=\"/usr/local/share:/usr/share\" -DSYSCONFDIR=\"/usr/local/etc\" -DVK_USE_PLATFORM_WAYLAND_KHR -DVK_USE_PLATFORM_XCB_KHR -DVK_USE_PLATFORM_XLIB_KHR -DVK_USE_PLATFORM_XLIB_XRANDR_EXT -I "$HOME"/Vulkan-LoaderAndValidationLayers/include -I "$HOME"/Vulkan-LoaderAndValidationLayers/loader -I "$HOME"/Vulkan-LoaderAndValidationLayers/build/loader -I "$HOME"/Vulkan-LoaderAndValidationLayers/build -std=c99 -Wall -Wextra -Wno-unused-parameter -Wno-missing-field-initializers -fno-strict-aliasing -fno-builtin-memcmp -Wimplicit-fallthrough=0 -fvisibility=hidden -Wpointer-arith -g -DDEBUG -o asm_offset.c.o -c "$HOME"/Vulkan-LoaderAndValidationLayers/loader/asm_offset.c
cc -std=c99 -Wall -Wextra -Wno-unused-parameter -Wno-missing-field-initializers -fno-strict-aliasing -fno-builtin-memcmp -Wimplicit-fallthrough=0 -fvisibility=hidden -Wpointer-arith -g -DDEBUG -rdynamic asm_offset.c.o -o asm_offset

./asm_offset GAS

cc -DAPI_NAME=\"Vulkan\" -DEXTRASYSCONFDIR=\"/etc\" -DFALLBACK_CONFIG_DIRS=\"/etc/xdg\" -DFALLBACK_DATA_DIRS=\"/usr/local/share:/usr/share\" -DSYSCONFDIR=\"/usr/local/etc\" -DVK_USE_PLATFORM_WAYLAND_KHR -DVK_USE_PLATFORM_XCB_KHR -DVK_USE_PLATFORM_XLIB_KHR -DVK_USE_PLATFORM_XLIB_XRANDR_EXT -Dvulkan_EXPORTS -I "$HOME"/Vulkan-LoaderAndValidationLayers/include -I "$HOME"/Vulkan-LoaderAndValidationLayers/loader -I "$HOME"/Vulkan-LoaderAndValidationLayers/build/loader -I "$HOME"/Vulkan-LoaderAndValidationLayers/build -std=c99 -Wall -Wextra -Wno-unused-parameter -Wno-missing-field-initializers -fno-strict-aliasing -fno-builtin-memcmp -Wimplicit-fallthrough=0 -fvisibility=hidden -Wpointer-arith -g -DDEBUG -fPIC -o extension_manual.c.o -c "$HOME"/Vulkan-LoaderAndValidationLayers/loader/extension_manual.c
cc -DAPI_NAME=\"Vulkan\" -DEXTRASYSCONFDIR=\"/etc\" -DFALLBACK_CONFIG_DIRS=\"/etc/xdg\" -DFALLBACK_DATA_DIRS=\"/usr/local/share:/usr/share\" -DSYSCONFDIR=\"/usr/local/etc\" -DVK_USE_PLATFORM_WAYLAND_KHR -DVK_USE_PLATFORM_XCB_KHR -DVK_USE_PLATFORM_XLIB_KHR -DVK_USE_PLATFORM_XLIB_XRANDR_EXT -Dvulkan_EXPORTS -I "$HOME"/Vulkan-LoaderAndValidationLayers/include -I "$HOME"/Vulkan-LoaderAndValidationLayers/loader -I "$HOME"/Vulkan-LoaderAndValidationLayers/build/loader -I "$HOME"/Vulkan-LoaderAndValidationLayers/build -std=c99 -Wall -Wextra -Wno-unused-parameter -Wno-missing-field-initializers -fno-strict-aliasing -fno-builtin-memcmp -Wimplicit-fallthrough=0 -fvisibility=hidden -Wpointer-arith -g -DDEBUG -fPIC -o loader.c.o -c "$HOME"/Vulkan-LoaderAndValidationLayers/loader/loader.c
cc -DAPI_NAME=\"Vulkan\" -DEXTRASYSCONFDIR=\"/etc\" -DFALLBACK_CONFIG_DIRS=\"/etc/xdg\" -DFALLBACK_DATA_DIRS=\"/usr/local/share:/usr/share\" -DSYSCONFDIR=\"/usr/local/etc\" -DVK_USE_PLATFORM_WAYLAND_KHR -DVK_USE_PLATFORM_XCB_KHR -DVK_USE_PLATFORM_XLIB_KHR -DVK_USE_PLATFORM_XLIB_XRANDR_EXT -Dvulkan_EXPORTS -I "$HOME"/Vulkan-LoaderAndValidationLayers/include -I "$HOME"/Vulkan-LoaderAndValidationLayers/loader -I "$HOME"/Vulkan-LoaderAndValidationLayers/build/loader -I "$HOME"/Vulkan-LoaderAndValidationLayers/build -std=c99 -Wall -Wextra -Wno-unused-parameter -Wno-missing-field-initializers -fno-strict-aliasing -fno-builtin-memcmp -Wimplicit-fallthrough=0 -fvisibility=hidden -Wpointer-arith -g -DDEBUG -fPIC -o trampoline.c.o -c "$HOME"/Vulkan-LoaderAndValidationLayers/loader/trampoline.c
cc -DAPI_NAME=\"Vulkan\" -DEXTRASYSCONFDIR=\"/etc\" -DFALLBACK_CONFIG_DIRS=\"/etc/xdg\" -DFALLBACK_DATA_DIRS=\"/usr/local/share:/usr/share\" -DSYSCONFDIR=\"/usr/local/etc\" -DVK_USE_PLATFORM_WAYLAND_KHR -DVK_USE_PLATFORM_XCB_KHR -DVK_USE_PLATFORM_XLIB_KHR -DVK_USE_PLATFORM_XLIB_XRANDR_EXT -Dvulkan_EXPORTS -I "$HOME"/Vulkan-LoaderAndValidationLayers/include -I "$HOME"/Vulkan-LoaderAndValidationLayers/loader -I "$HOME"/Vulkan-LoaderAndValidationLayers/build/loader -I "$HOME"/Vulkan-LoaderAndValidationLayers/build -std=c99 -Wall -Wextra -Wno-unused-parameter -Wno-missing-field-initializers -fno-strict-aliasing -fno-builtin-memcmp -Wimplicit-fallthrough=0 -fvisibility=hidden -Wpointer-arith -g -DDEBUG -fPIC -o wsi.c.o -c "$HOME"/Vulkan-LoaderAndValidationLayers/loader/wsi.c
cc -DAPI_NAME=\"Vulkan\" -DEXTRASYSCONFDIR=\"/etc\" -DFALLBACK_CONFIG_DIRS=\"/etc/xdg\" -DFALLBACK_DATA_DIRS=\"/usr/local/share:/usr/share\" -DSYSCONFDIR=\"/usr/local/etc\" -DVK_USE_PLATFORM_WAYLAND_KHR -DVK_USE_PLATFORM_XCB_KHR -DVK_USE_PLATFORM_XLIB_KHR -DVK_USE_PLATFORM_XLIB_XRANDR_EXT -Dvulkan_EXPORTS -I "$HOME"/Vulkan-LoaderAndValidationLayers/include -I "$HOME"/Vulkan-LoaderAndValidationLayers/loader -I "$HOME"/Vulkan-LoaderAndValidationLayers/build/loader -I "$HOME"/Vulkan-LoaderAndValidationLayers/build -std=c99 -Wall -Wextra -Wno-unused-parameter -Wno-missing-field-initializers -fno-strict-aliasing -fno-builtin-memcmp -Wimplicit-fallthrough=0 -fvisibility=hidden -Wpointer-arith -g -DDEBUG -fPIC -o debug_report.c.o -c "$HOME"/Vulkan-LoaderAndValidationLayers/loader/debug_report.c
cc -DAPI_NAME=\"Vulkan\" -DEXTRASYSCONFDIR=\"/etc\" -DFALLBACK_CONFIG_DIRS=\"/etc/xdg\" -DFALLBACK_DATA_DIRS=\"/usr/local/share:/usr/share\" -DSYSCONFDIR=\"/usr/local/etc\" -DVK_USE_PLATFORM_WAYLAND_KHR -DVK_USE_PLATFORM_XCB_KHR -DVK_USE_PLATFORM_XLIB_KHR -DVK_USE_PLATFORM_XLIB_XRANDR_EXT -Dvulkan_EXPORTS -I "$HOME"/Vulkan-LoaderAndValidationLayers/include -I "$HOME"/Vulkan-LoaderAndValidationLayers/loader -I "$HOME"/Vulkan-LoaderAndValidationLayers/build/loader -I "$HOME"/Vulkan-LoaderAndValidationLayers/build -std=c99 -Wall -Wextra -Wno-unused-parameter -Wno-missing-field-initializers -fno-strict-aliasing -fno-builtin-memcmp -Wimplicit-fallthrough=0 -fvisibility=hidden -Wpointer-arith -g -DDEBUG -fPIC -o cJSON.c.o -c "$HOME"/Vulkan-LoaderAndValidationLayers/loader/cJSON.c
cc -DAPI_NAME=\"Vulkan\" -DEXTRASYSCONFDIR=\"/etc\" -DFALLBACK_CONFIG_DIRS=\"/etc/xdg\" -DFALLBACK_DATA_DIRS=\"/usr/local/share:/usr/share\" -DSYSCONFDIR=\"/usr/local/etc\" -DVK_USE_PLATFORM_WAYLAND_KHR -DVK_USE_PLATFORM_XCB_KHR -DVK_USE_PLATFORM_XLIB_KHR -DVK_USE_PLATFORM_XLIB_XRANDR_EXT -Dvulkan_EXPORTS -I "$HOME"/Vulkan-LoaderAndValidationLayers/include -I "$HOME"/Vulkan-LoaderAndValidationLayers/loader -I "$HOME"/Vulkan-LoaderAndValidationLayers/build/loader -I "$HOME"/Vulkan-LoaderAndValidationLayers/build -std=c99 -Wall -Wextra -Wno-unused-parameter -Wno-missing-field-initializers -fno-strict-aliasing -fno-builtin-memcmp -Wimplicit-fallthrough=0 -fvisibility=hidden -Wpointer-arith -g -DDEBUG -fPIC -o murmurhash.c.o -c "$HOME"/Vulkan-LoaderAndValidationLayers/loader/murmurhash.c
cc -DAPI_NAME=\"Vulkan\" -DEXTRASYSCONFDIR=\"/etc\" -DFALLBACK_CONFIG_DIRS=\"/etc/xdg\" -DFALLBACK_DATA_DIRS=\"/usr/local/share:/usr/share\" -DSYSCONFDIR=\"/usr/local/etc\" -DVK_USE_PLATFORM_WAYLAND_KHR -DVK_USE_PLATFORM_XCB_KHR -DVK_USE_PLATFORM_XLIB_KHR -DVK_USE_PLATFORM_XLIB_XRANDR_EXT -Dvulkan_EXPORTS -I "$HOME"/Vulkan-LoaderAndValidationLayers/include -I "$HOME"/Vulkan-LoaderAndValidationLayers/loader -I "$HOME"/Vulkan-LoaderAndValidationLayers/build/loader -I "$HOME"/Vulkan-LoaderAndValidationLayers/build -std=c99 -Wall -Wextra -Wno-unused-parameter -Wno-missing-field-initializers -fno-strict-aliasing -fno-builtin-memcmp -Wimplicit-fallthrough=0 -fvisibility=hidden -Wpointer-arith -g -DDEBUG -fPIC -o dev_ext_trampoline.c.o -c "$HOME"/Vulkan-LoaderAndValidationLayers/loader/dev_ext_trampoline.c
cc -DAPI_NAME=\"Vulkan\" -DEXTRASYSCONFDIR=\"/etc\" -DFALLBACK_CONFIG_DIRS=\"/etc/xdg\" -DFALLBACK_DATA_DIRS=\"/usr/local/share:/usr/share\" -DSYSCONFDIR=\"/usr/local/etc\" -DVK_USE_PLATFORM_WAYLAND_KHR -DVK_USE_PLATFORM_XCB_KHR -DVK_USE_PLATFORM_XLIB_KHR -DVK_USE_PLATFORM_XLIB_XRANDR_EXT -Dvulkan_EXPORTS -I "$HOME"/Vulkan-LoaderAndValidationLayers/include -I "$HOME"/Vulkan-LoaderAndValidationLayers/loader -I "$HOME"/Vulkan-LoaderAndValidationLayers/build/loader -I "$HOME"/Vulkan-LoaderAndValidationLayers/build -std=c99 -Wall -Wextra -Wno-unused-parameter -Wno-missing-field-initializers -fno-strict-aliasing -fno-builtin-memcmp -Wimplicit-fallthrough=0 -fvisibility=hidden -Wpointer-arith -g -DDEBUG -fPIC -o phys_dev_ext.c.o -c "$HOME"/Vulkan-LoaderAndValidationLayers/loader/phys_dev_ext.c
as -I/usr/include -I "$HOME"/Vulkan-LoaderAndValidationLayers/include -I "$HOME"/Vulkan-LoaderAndValidationLayers/loader -I "$HOME"/Vulkan-LoaderAndValidationLayers/build/loader -I "$HOME"/Vulkan-LoaderAndValidationLayers/build -I" "$HOME"/Vulkan-LoaderAndValidationLayers/build/loader" -o unknown_ext_chain_gas.asm.o "$HOME"/Vulkan-LoaderAndValidationLayers/loader/unknown_ext_chain_gas.asm
cc -fPIC -std=c99 -Wall -Wextra -Wno-unused-parameter -Wno-missing-field-initializers -fno-strict-aliasing -fno-builtin-memcmp -Wimplicit-fallthrough=0 -fvisibility=hidden -Wpointer-arith -g -DDEBUG -shared -Wl,-soname,libvulkan.so.1 -o libvulkan.so.1.0.66 extension_manual.c.o loader.c.o trampoline.c.o wsi.c.o debug_report.c.o cJSON.c.o murmurhash.c.o dev_ext_trampoline.c.o phys_dev_ext.c.o unknown_ext_chain_gas.asm.o -ldl -lpthread -lm

cmake -E cmake_symlink_library libvulkan.so.1.0.66 libvulkan.so.1 libvulkan.so