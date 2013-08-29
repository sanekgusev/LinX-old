object FormMain: TFormMain
  Left = 0
  Top = 0
  ActiveControl = ListViewTable
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'LinX - Simply Linpack'
  ClientHeight = 275
  ClientWidth = 520
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu
  OldCreateOrder = False
  Position = poDesigned
  Scaled = False
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  DesignSize = (
    520
    275)
  PixelsPerInch = 96
  TextHeight = 13
  object LabelMem: TLabel
    Left = 170
    Top = 8
    Width = 69
    Height = 13
    Hint = 'Amount of memory to be used'
    Anchors = [akTop]
    Caption = 'Memory (MiB):'
    Transparent = True
  end
  object LabelRuns: TLabel
    Left = 380
    Top = 8
    Width = 23
    Height = 13
    Hint = 
      'Testing will stop either after the specified number of times or ' +
      'after a specified time interval '
    Anchors = [akTop, akRight]
    Caption = 'Run:'
    Transparent = True
  end
  object LabelPS: TLabel
    Left = 5
    Top = 8
    Width = 63
    Height = 13
    Hint = 
      'Affects calculations'#39' complexity and duration (set higher values' +
      ' for more stress)'
    Caption = 'Problem size:'
    Transparent = True
  end
  object SpeedButtonAllMem: TSpeedButton
    Left = 300
    Top = 4
    Width = 30
    Height = 23
    Hint = 'Click to always use all available memory (maximum stress)'
    AllowAllUp = True
    Anchors = [akTop]
    GroupIndex = 1
    Caption = 'All'
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Layout = blGlyphTop
    Margin = 3
    ParentFont = False
    OnClick = SpeedButtonAllMemClick
  end
  object SpeedButtonStart: TSpeedButton
    Left = 5
    Top = 30
    Width = 75
    Height = 25
    Hint = 'Starts the testing process (Enter)'
    Caption = 'Start'
    OnClick = SpeedButtonStartClick
  end
  object SpeedButtonStop: TSpeedButton
    Left = 440
    Top = 30
    Width = 75
    Height = 25
    Hint = 'Stops the testing immediately (Esc)'
    Anchors = [akTop, akRight]
    Caption = 'Stop'
    Enabled = False
    OnClick = SpeedButtonStopClick
    ExplicitLeft = 435
  end
  object ShapeBase: TShape
    Left = 85
    Top = 31
    Width = 350
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    Brush.Color = 15527662
    Pen.Color = clBtnShadow
    Shape = stRoundRect
    ExplicitWidth = 345
  end
  object ShapeBar: TShape
    Left = 87
    Top = 33
    Width = 346
    Height = 19
    Anchors = [akLeft, akTop, akRight]
    Brush.Color = 13621203
    Pen.Color = 11976122
    ExplicitWidth = 341
  end
  object LabelStatus: TLabel
    Left = 85
    Top = 36
    Width = 350
    Height = 18
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    PopupMenu = PopupMenuSettings
    Transparent = True
    OnClick = Panel1Click
    OnDblClick = Panel1DblClick
    ExplicitWidth = 345
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 255
    Width = 520
    Height = 20
    DoubleBuffered = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Panels = <
      item
        Alignment = taCenter
        Width = 55
      end
      item
        Alignment = taCenter
        Width = 45
      end
      item
        Alignment = taCenter
        Width = 60
      end
      item
        Alignment = taCenter
        Width = 110
      end
      item
        Alignment = taCenter
        Width = 210
      end
      item
        Alignment = taCenter
        Width = 35
      end>
    ParentDoubleBuffered = False
    SizeGrip = False
    UseSystemFont = False
    OnClick = StatusBarClick
  end
  object ComboBoxPS: TComboBox
    Left = 74
    Top = 5
    Width = 60
    Height = 21
    Hint = 'Select a value from drop-down list or key in directly'
    AutoComplete = False
    BevelEdges = []
    BevelInner = bvNone
    BevelOuter = bvNone
    DoubleBuffered = False
    ItemHeight = 13
    MaxLength = 5
    ParentDoubleBuffered = False
    TabOrder = 0
    Text = '10000'
    OnChange = ComboBoxPSChange
    OnCloseUp = ComboBoxPSCloseUp
  end
  object MemoLog: TMemo
    Left = 5
    Top = 60
    Width = 510
    Height = 190
    Cursor = crArrow
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Anchors = [akLeft, akTop, akRight, akBottom]
    DoubleBuffered = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentDoubleBuffered = False
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 4
    Visible = False
    WordWrap = False
  end
  object ComboBoxMem: TComboBox
    Left = 245
    Top = 5
    Width = 55
    Height = 21
    Hint = 'Select a value from drop-down list or key in directly '
    AutoComplete = False
    BevelEdges = []
    BevelInner = bvNone
    BevelOuter = bvNone
    Anchors = [akTop]
    DoubleBuffered = False
    ItemHeight = 13
    MaxLength = 5
    ParentDoubleBuffered = False
    TabOrder = 1
    Text = '1024'
    OnChange = ComboBoxMemChange
    OnCloseUp = ComboBoxMemCloseUp
  end
  object ComboBoxRuns: TComboBox
    Left = 405
    Top = 5
    Width = 50
    Height = 21
    Hint = 'Select a value from drop-down list or key in directly'
    AutoComplete = False
    BevelEdges = []
    BevelInner = bvNone
    BevelOuter = bvNone
    Anchors = [akTop, akRight]
    DoubleBuffered = False
    ItemHeight = 13
    ItemIndex = 2
    MaxLength = 5
    ParentDoubleBuffered = False
    TabOrder = 2
    Text = '10'
    OnChange = ComboBoxRunsChange
    OnCloseUp = ComboBoxRunsChange
    Items.Strings = (
      '3'
      '5'
      '10'
      '15'
      '20'
      '25'
      '50'
      '75'
      '100'
      '150'
      '200'
      '250'
      '300'
      '500')
  end
  object ListViewTable: TListView
    Left = 0
    Top = 61
    Width = 520
    Height = 194
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvNone
    BorderStyle = bsNone
    Columns = <
      item
        Caption = '#'
        MaxWidth = 30
        MinWidth = 30
        Width = 30
      end
      item
        Alignment = taCenter
        Caption = 'Size'
        MaxWidth = 50
        MinWidth = 50
      end
      item
        Alignment = taCenter
        Caption = 'LDA'
        MaxWidth = 50
        MinWidth = 50
      end
      item
        Alignment = taCenter
        Caption = 'Align'
        MaxWidth = 40
        MinWidth = 40
        Width = 40
      end
      item
        Alignment = taCenter
        Caption = 'Time'
        MaxWidth = 65
        MinWidth = 65
        Width = 65
      end
      item
        Alignment = taCenter
        Caption = 'GFlops'
        MaxWidth = 70
        MinWidth = 70
        Width = 70
      end
      item
        Alignment = taCenter
        Caption = 'Residual'
        MaxWidth = 95
        MinWidth = 95
        Width = 95
      end
      item
        Alignment = taCenter
        Caption = 'Residual (norm.)'
        MaxWidth = 98
        MinWidth = 98
        Width = 98
      end>
    DoubleBuffered = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    GridLines = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    ParentDoubleBuffered = False
    ParentFont = False
    TabOrder = 3
    TabStop = False
    ViewStyle = vsReport
  end
  object ComboBoxTimesMinutes: TComboBox
    Left = 460
    Top = 5
    Width = 55
    Height = 21
    BevelEdges = []
    BevelInner = bvNone
    BevelOuter = bvNone
    Style = csDropDownList
    Anchors = [akTop, akRight]
    DoubleBuffered = False
    ItemHeight = 13
    ItemIndex = 0
    ParentDoubleBuffered = False
    TabOrder = 6
    Text = 'times'
    OnChange = ComboBoxRunsChange
    OnKeyPress = ComboBoxTimesMinutesKeyPress
    Items.Strings = (
      'times'
      'minutes')
  end
  object TimerMain: TTimer
    Enabled = False
    Interval = 985
    OnTimer = TimerMainTimer
    Left = 12
    Top = 209
  end
  object MainMenu: TMainMenu
    Left = 403
    Top = 27
    object MIFile: TMenuItem
      Caption = '&File'
      object MIScreenshot: TMenuItem
        Caption = 'Save Screenshot'
        ShortCut = 116
        OnClick = MIScreenshotClick
      end
      object MILog: TMenuItem
        Caption = 'Save Text Log'
        Enabled = False
        ShortCut = 117
        OnClick = MILogClick
      end
      object MISep1: TMenuItem
        Caption = '-'
      end
      object MIExit: TMenuItem
        Caption = 'Exit'
        OnClick = MIExitClick
      end
    end
    object MISettings: TMenuItem
      Caption = '&Settings'
      ImageIndex = 1
      ShortCut = 113
      OnClick = MISettingsClick
    end
    object MIGraphs: TMenuItem
      Caption = '&Graphs'
      Enabled = False
      OnClick = MIDisplayClick
    end
    object MIAbout: TMenuItem
      Caption = '?'#160
      ShortCut = 112
      OnClick = MIAboutClick
    end
  end
  object TrayIcon: TTrayIcon
    AnimateInterval = 0
    PopupMenu = PopupMenuTray
    OnDblClick = TMMinimizeClick
    Left = 475
    Top = 209
  end
  object PopupMenuTray: TPopupMenu
    OnPopup = PopupMenuTrayPopup
    Left = 408
    Top = 209
    object TMMinimize: TMenuItem
      Caption = 'Minimize'
      Default = True
      OnClick = TMMinimizeClick
    end
    object TMSep1: TMenuItem
      Caption = '-'
    end
    object TMStart: TMenuItem
      Caption = 'Start'
      OnClick = TMStartClick
    end
    object TMStop: TMenuItem
      Caption = 'Stop'
      Enabled = False
      OnClick = TMStopClick
    end
    object TMSep2: TMenuItem
      Caption = '-'
    end
    object TMExit: TMenuItem
      Caption = 'Exit'
      OnClick = MIExitClick
    end
  end
  object PopupMenuSettings: TPopupMenu
    OnPopup = PopupMenuSettingsPopup
    Left = 320
    Top = 30
    object SMFullSettings: TMenuItem
      Caption = 'All Settings'#8230
      OnClick = MISettingsClick
    end
    object SMSep4: TMenuItem
      Caption = '-'
    end
    object SM32: TMenuItem
      AutoCheck = True
      Caption = '32-bit'
      RadioItem = True
      OnClick = SM32Click
    end
    object SM64: TMenuItem
      AutoCheck = True
      Caption = '64-bit'
      RadioItem = True
      OnClick = SM32Click
    end
    object SMSep1: TMenuItem
      Caption = '-'
    end
    object SMThreads: TMenuItem
      Caption = 'Threads'
      OnClick = SMThreadsClick
    end
    object SMSep2: TMenuItem
      Caption = '-'
    end
    object SMStopOnError: TMenuItem
      AutoCheck = True
      Caption = 'Stop On Error'
      OnClick = SMStopOnErrorClick
    end
    object SMSavelog: TMenuItem
      AutoCheck = True
      Caption = 'Auto-save Log'
      OnClick = SMSavelogClick
    end
    object SMSounds: TMenuItem
      AutoCheck = True
      Caption = 'Sounds'
      OnClick = SMSoundsClick
    end
    object SMTrayIcon: TMenuItem
      AutoCheck = True
      Caption = 'Tray Icon'
      OnClick = SMTrayIconClick
    end
  end
end
