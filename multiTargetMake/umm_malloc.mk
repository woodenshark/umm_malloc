# -----------------------------------------------------------------------------
# Local makefile for umm_malloc
# -----------------------------------------------------------------------------
# $Id$
# -----------------------------------------------------------------------------
# See Copyright Notice in ../make/LICENSE
# -----------------------------------------------------------------------------
# Revision History
# ----------+-----------------+------------------------------------------------
# 2017.01.29 rhempel           Original
# -----------------------------------------------------------------------------

#! [ModuleVariables]
# ----------------------------------------------------------------------------
# Module Level Variables
#
mod_name := umm_malloc

$(mod_name)_lib_name  := $(mod_name)
$(mod_name)_dlib_name := lib$(mod_name)
$(mod_name)_exe_name  := test_$(mod_name)

# --------------------------------------------------------------------------------------
# Where to install module libraries and shared source
#
UMM_MALLOC_FILEDIR    := umm_malloc
#! [ModuleVariables]

#! [ModuleDirectories]
# ----------------------------------------------------------------------------
# Module Level Directories
#
$(mod_name)_srcdir    := src/$(UMM_MALLOC_VERSION)
$(mod_name)_objdir    := obj/$(PLATFORM)/$(PROJECT)/$(UMM_MALLOC_VERSION)

$(mod_name)_incdirs   := $($(mod_name)_srcdir)/src
$(mod_name)_incdirs   += $($(mod_name)_srcdir)/includes/c-helper-macros
$(mod_name)_incdirs   += $(Unity_incdirs)
$(mod_name)_incdirs   += $(Unity_fixture_incdirs)

# Platform specific include files
ifeq "$(strip $(embedded_platform))" "TRUE"
  $(mod_name)_incdirs   += src/$(UMLIBC_VERSION)/include/
endif

# Top level object file directory
$(mod_name)_objdirs   := $($(mod_name)_objdir)
#! [ModuleDirectories]

#! [ModuleCFLAGS]
# ----------------------------------------------------------------------------
# Module Level CFLAGS
#
$(mod_name)_cflags  :=

# Platform specific CFLAGS
ifeq "$(strip $(windows_platform))" "TRUE"
  $(mod_name)_cflags  +=
else ifeq "$(strip $(nxt_platform))" "TRUE"
  $(mod_name)_cflags  += 
else ifeq "$(strip $(embedded_platform))" "TRUE"
  $(mod_name)_cflags  += 
else
  $(mod_name)_cflags  += 
endif
#! [ModuleCFLAGS]

#! [ModuleSYSLIBS]
# --------------------------------------------------------------------------------------
# SYSLIBS is set in the platform specific makefile, this is where additional libs
# required by this module go

$(mod_name)_syslibs := $(SYSLIBS)

# Platform specific SYSLIBS
ifeq "$(strip $(windows_platform))" "TRUE"
  $(mod_name)_syslibs +=
else ifeq "$(strip $(embedded_platform))" "TRUE"
  $(mod_name)_syslibs +=
else
  $(mod_name)_syslibs += -lreadline -lm
endif
#! [ModuleSYSLIBS]

#! [ModuleLIBSembedded
# --------------------------------------------------------------------------------------
# Add any module specific libraries (not SYSLIBS, see above) should be included here.

$(mod_name)_libs :=
$(mod_name)_libs += $(Unity_objdir)/$(Unity_lib_name)$(LIB_EXT)
$(mod_name)_libs += $($(mod_name)_objdir)/$($(mod_name)_lib_name)$(LIB_EXT)


ifeq "$(strip $(windows_platform))" "TRUE"
  $(mod_name)_libs += 
else
  $(mod_name)_libs +=
endif
#! [ModuleLIBS]

#! [ModuleINSTALL]
# --------------------------------------------------------------------------------------
# Module specific install locations
# 
# Note, the module dynamic library has to go in the same directory as the executable
#       on the Windows platform

INSTALL_UMM_MALLOC_BIN   := $(INSTALL_BIN)
INSTALL_UMM_MALLOC_MAN   := $(INSTALL_MAN)
INSTALL_UMM_MALLOC_INC   := $(INSTALL_INC)
INSTALL_UMM_MALLOC_SHARE := $(INSTALL_SHARE)
INSTALL_UMM_MALLOC_LIB   := $(INSTALL_LIB)

ifeq "$(strip $(windows_platform))" "TRUE"
  INSTALL_UMM_MALLOC_LIB   := $(INSTALL_BIN)
endif
#! [ModuleINSTALL]

# --------------------------------------------------------------------------------------
# Object file sub-module groups
# --------------------------------------------------------------------------------------

# umm_malloc core sub-module -----------------------------------------------------------

PREFIX_O := ./src

MODSRC_O :=     umm_malloc.o

ifeq "$(strip $(embedded_platform))" "TRUE"
  MODSRC_O := $(addsuffix thumb,$(MODSRC_O) )
else
endif

$(mod_name)_core_prefix  := $(PREFIX_O)
$(mod_name)_core_objects := $(addprefix $($(mod_name)_objdir)/,\
                                $(addprefix $(PREFIX_O)/,$(MODSRC_O)))

$(mod_name)_core_incdirs := 
$(mod_name)_core_objdirs := $($(mod_name)_objdir)/$(PREFIX_O)

# umm_malloc executables sub-module ---------------------------------------------------

PREFIX_O := test

MODSRC_O :=     

$(mod_name)_exe_prefix  := $(PREFIX_O)
$(mod_name)_exe_objects := $(addprefix $($(mod_name)_objdir)/,\
                                $(addprefix $(PREFIX_O)/,$(MODSRC_O)))

$(mod_name)_exe_incdirs := 
$(mod_name)_exe_objdirs := $($(mod_name)_objdir)/$(PREFIX_O)

#! [ModulePHONYTargets]
# --------------------------------------------------------------------------------------
# PHONY Targets and dependencies
# 
.PHONY: LIBUMM_MALLOC EXEUMM_MALLOC

EXEUMM_MALLOC  : $($(mod_name)_objdir)/$($(mod_name)_exe_name)$(EXE_EXT)

# DLIBUMM_MALLOC : $($(mod_name)_objdir)/$($(mod_name)_dlib_name)$(DLIB_EXT)

LIBUMM_MALLOC  : $($(mod_name)_objdir)/$($(mod_name)_lib_name)$(LIB_EXT)

#INSTALLLUA : $(INSTALL_LUA_BIN)/$($(mod_name)_exe_name)$(EXE_EXT)    \
#             $(INSTALL_LUA_LIB)/$($(mod_name)_dlib_name)$(DLIB_EXT)  \
#             $(INSTALL_LUA_MAN)/lua.1                                \
#             $(INSTALL_LUA_MAN)/luac.1                               \
#             $(INSTALL_LUA_INC)/lua.h                                \
#             $(INSTALL_LUA_INC)/luaconf.h                            \
#             $(INSTALL_LUA_INC)/lualib.h                             \
#             $(INSTALL_LUA_INC)/lauxlib.h                            \
#             $(INSTALL_LUA_INC)/lua.hpp
#! [ModulePHONYTargets]
#! [ModuleINSTALLdependencies]
# --------------------------------------------------------------------------------------
# Install file dependencies
#

#$(INSTALL_LUA_BIN)/$($(mod_name)_exe_name)$(EXE_EXT)   : $($(mod_name)_objdir)/$($(mod_name)_exe_name)$(EXE_EXT)
#
#$(INSTALL_LUA_LIB)/$($(mod_name)_dlib_name)$(DLIB_EXT) : $($(mod_name)_objdir)/$($(mod_name)_dlib_name)$(DLIB_EXT)

#$(INSTALL_LUA_LIB)/$($(mod_name)_lib_name)$(LIB_EXT)   : $($(mod_name)_objdir)/$($(mod_name)_lib_name)$(LIB_EXT)

#! [ModuleINSTALLdependencies]
#! [ModuleBuild]
# --------------------------------------------------------------------------------------
# From here on down, we're just setting up the build variables and running the build
# for:
#
# Installation
# Executables
# Dynamic Libraries
# Static Libraries
# Objects
#
# --------------------------------------------------------------------------------------
# Build the installation

local_libdir   := $($(mod_name)_objdir)
local_mandir   := $($(mod_name)_srcdir)/doc
local_incdir   := $($(mod_name)_srcdir)/src
local_etcdir   := $($(mod_name)_srcdir)/etc
local_sharedir := $($(mod_name)_srcdir)/src

dest_libdir    := $(INSTALL_UMM_MALLOC_LIB)
dest_sharedir  := $(INSTALL_UMM_MALLOC_SHARE)/$(UMM_MALLOC_FILEDIR)

include ./make/build/build_install.mk

# --------------------------------------------------------------------------------------
# Build the executables

local_objdir   := $($(mod_name)_objdir)
local_exename  := $($(mod_name)_exe_name)
local_libs     := $($(mod_name)_libs)
local_syslibs  := $($(mod_name)_syslibs)
local_object   := $(local_objdir)/$($(mod_name)_exe_prefix)/test_umm_malloc$(OBJ_EXT)
local_ldlib    := 

ifeq "$(strip $(embedded_platform))" "TRUE"
  local_ldlib    += 
else
  local_ldlib    += 
endif

include ./make/build/build_exe.mk

OBJDIRS               += $($(mod_name)_objdirs)

# --------------------------------------------------------------------------------------
# Build the dynamic library

local_objdir   := $($(mod_name)_objdir)
local_dlibname := $($(mod_name)_dlib_name)
local_libs     := $($(mod_name)_libs)
local_syslibs  := $($(mod_name)_syslibs)
local_objects  := $($(mod_name)_core_objects)

ifeq "$(strip $(embedded_platform))" "TRUE"
else
  include ./make/build/build_dlib.mk
endif

# --------------------------------------------------------------------------------------
# Build the static library

local_objdir   := $($(mod_name)_objdir)
local_libname  := $($(mod_name)_lib_name)
local_arflags  := 
local_objects  := $($(mod_name)_core_objects)

include ./make/build/build_lib.mk

# --------------------------------------------------------------------------------------
# Build the core sub-module objects

OBJDIRS        += $($(mod_name)_core_objdirs)

local_prefix   := $($(mod_name)_core_prefix)
local_objdir   := $($(mod_name)_objdir)
local_srcdir   := $($(mod_name)_srcdir)
local_incdirs  := $($(mod_name)_incdirs) $($(mod_name)_core_incdirs)
local_cflags   := $($(mod_name)_cflags) 

include ./make/build/build_objects.mk 

sinclude $(subst .o,.d,$($(mod_name)_core_objects))

# --------------------------------------------------------------------------------------
# Build the exe sub-module objects

OBJDIRS        += $($(mod_name)_exe_objdirs)

local_prefix   := $($(mod_name)_exe_prefix)
local_objdir   := $($(mod_name)_objdir)
local_srcdir   := $($(mod_name)_srcdir)
local_incdirs  := $($(mod_name)_incdirs) $($(mod_name)_exe_incdirs)
local_cflags   := $($(mod_name)_cflags)

include ./make/build/build_objects.mk 

sinclude $(subst .o,.d,$($(mod_name)_exe_objects))

# --------------------------------------------------------------------------------------
#! [ModuleBuild]
