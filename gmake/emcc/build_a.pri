#Sort to remove duplicates
BUILD_DIRS = $(sort $(addprefix $(ROOT)$(BUILD_DIR)$(TARGET)/,$(dir $(SOURCES))))

CCOBJECTS = $(addprefix $(ROOT)$(BUILD_DIR)$(TARGET)/,$(filter %.bc,$(SOURCES:.c=.c.bc)))
CXXOBJECTS = $(addprefix $(ROOT)$(BUILD_DIR)$(TARGET)/,$(filter %.bc,$(SOURCES:.cpp=.cpp.bc)))
QRCSOURCES = $(addprefix $(ROOT)$(BUILD_DIR)$(TARGET)/,$(filter %.cpp,$(TP_RC:.qrc=.qrc.cpp)))
QRCOBJECTS = $(filter %.bc,$(QRCSOURCES:.cpp=.cpp.bc))

DEFINES  := $(foreach DEFINE,$(DEFINES),-D$(DEFINE))
INCLUDES += $(foreach INCLUDE,$(INCLUDEPATHS),-I../$(INCLUDE))

TP_RC_CMD = $(ROOT)$(BUILD_DIR)tp_rc
TP_RC_SRC = $(ROOT)tp_build/tp_rc/tp_rc.cpp

all_a: $(BUILD_DIRS) $(ROOT)$(BUILD_DIR)$(TARGET).bc

$(ROOT)$(BUILD_DIR)$(TARGET).bc: $(CCOBJECTS) $(CXXOBJECTS) $(QRCOBJECTS)
	"$(AR)" -r $^ -o $@

$(ROOT)$(BUILD_DIR)$(TARGET)/%.c.bc: %.c
	"$(CC)" -c $(CFLAGS) $(CCFLAGS) $(INCLUDES) $(DEFINES) $< -o $@

$(ROOT)$(BUILD_DIR)$(TARGET)/%.cpp.bc: %.cpp
	"$(CXX)" -c $(CFLAGS) $(CXXFLAGS) $(INCLUDES) $(DEFINES) $< -o $@

$(ROOT)$(BUILD_DIR)$(TARGET)/%.qrc.cpp.bc: %.qrc $(TP_RC_CMD)
	"$(TP_RC_CMD)" "$<" "$(basename $@)" $(basename $(basename $(notdir $<)))
	"$(CXX)" -c $(CFLAGS) $(CXXFLAGS) $(INCLUDES) $(DEFINES) "$(basename $@)" -o $@

$(BUILD_DIRS):
	$(MKDIR) $@

$(TP_RC_CMD): $(TP_RC_SRC)
	$(HOST_CXX) -std=gnu++1z -O2 $(TP_RC_SRC) -o $(TP_RC_CMD)
