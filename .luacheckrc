stds.wow = {
  globals = {
    SlashCmdList = {
      other_fields = true
    }
  },
  read_globals = {
    "BackdropTemplateMixin",
    "C_Timer",
    "CreateFrame",
    "DEFAULT_CHAT_FRAME",
    "GetAddOnMetadata",
    "GetCVar",
    "GetLocale",
    "GetSpellInfo",
    "HybridScrollFrame_CreateButtons",
    "HybridScrollFrame_GetButtons",
    "HybridScrollFrame_GetOffset",
    "HybridScrollFrame_SetDoNotHideScrollBar",
    "HybridScrollFrame_Update",
    "InterfaceOptions_AddCategory",
    "InterfaceOptionsFrame_OpenToCategory",
    "IsMounted",
    "PanelTemplates_GetSelectedTab",
    "PanelTemplates_SetNumTabs",
    "PanelTemplates_SetTab",
    "PlayMusic",
    "SetCVar",
    "StopMusic",
    "sort",
    "UnitBuff",
    "wipe"
  }
}

stds.externs = {
  read_globals = {
    "LibStub"
  }
}

std = "lua51+wow+externs"
max_line_length = 120
codes = true

ignore = {
  "212/self"
}

files = {
  ["locales/*.lua"] = {
    ignore = {
      "211/L", -- Unused variable "L"
      "631" -- Line too long
    }
  }
}

exclude_files = {
  "libs/CallbackHandler-1.0",
  "libs/LibDataBroker-1-1",
  "libs/LibStub",
  ".luacheckrc",
  ".release"
}

globals = {
  "Chocobo",
  "ChocoboLib"
}
