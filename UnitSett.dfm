object FormSett: TFormSett
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Settings'
  ClientHeight = 275
  ClientWidth = 395
  Color = clBtnFace
  ParentFont = True
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  ShowHint = True
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object ButtonOK: TSpeedButton
    Left = 120
    Top = 245
    Width = 75
    Height = 25
    Hint = 'Enter'
    Caption = 'OK'
    OnClick = ButtonOKClick
  end
  object ButtonCancel: TSpeedButton
    Left = 200
    Top = 245
    Width = 75
    Height = 25
    Hint = 'Esc'
    Caption = 'Cancel'
    OnClick = ButtonCancelClick
  end
  object PanelLinpack: TPanel
    Left = 5
    Top = 5
    Width = 190
    Height = 165
    BevelKind = bkFlat
    BevelOuter = bvNone
    Caption = 'Linpack'
    FullRepaint = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGrayText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    VerticalAlignment = taAlignTop
    object Label1: TLabel
      Left = 5
      Top = 43
      Width = 94
      Height = 13
      Hint = 
        'Here you can change the number of threads Linpack creates. This ' +
        'is also the number of cores that will be used'
      Caption = 'Number of threads:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 5
      Top = 93
      Width = 102
      Height = 13
      Hint = 
        'Arrays of data during execution of Linpack will be aligned to th' +
        'is value. 4 is optimal, 0 means no alignment'
      Caption = 'Data Alignment (KiB):'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 5
      Top = 21
      Width = 30
      Height = 13
      Hint = 
        '64-bit Linpack is more stressful than 32-bit one and has no memo' +
        'ry limitations. Consider using it when on a 64-bit OS'
      Caption = 'Mode:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 5
      Top = 68
      Width = 64
      Height = 13
      Hint = 
        'Linpack'#39's priority level. Lowering this value will make the syst' +
        'em more '#8222'responsive'#8220' during testing. Values higher than Normal a' +
        're not recommended'
      Caption = 'Priority class:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 5
      Top = 118
      Width = 137
      Height = 13
      Hint = 
        'This is the maximum Problem Size suitable for 32-bit Linpack (fo' +
        'und empirically). Change it only if you have problems starting L' +
        'inpack'
      Caption = 'Linpack32 max Problem Size:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 5
      Top = 143
      Width = 103
      Height = 13
      Hint = 
        'This is how much physical memory will be left for OS'#39' needs when' +
        ' using all available memory. Don'#39't set this too low'
      Caption = 'Memory for OS (MiB):'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object CBPriority: TComboBox
      Left = 70
      Top = 65
      Width = 115
      Height = 21
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ItemHeight = 13
      ItemIndex = 2
      ParentFont = False
      TabOrder = 4
      Text = 'Normal'
      Items.Strings = (
        'Idle'
        'Below normal'
        'Normal'
        'Above normal'
        'High'
        'Real-time')
    end
    object EditThreads: TEdit
      Left = 150
      Top = 40
      Width = 19
      Height = 21
      Alignment = taCenter
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxLength = 3
      NumbersOnly = True
      ParentFont = False
      TabOrder = 2
      Text = '1'
    end
    object EditDA: TEdit
      Left = 150
      Top = 90
      Width = 19
      Height = 21
      Alignment = taCenter
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxLength = 2
      NumbersOnly = True
      ParentFont = False
      TabOrder = 5
      Text = '4'
    end
    object RB32: TRadioButton
      Left = 70
      Top = 20
      Width = 50
      Height = 15
      Caption = '32-bit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGrayText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object RB64: TRadioButton
      Left = 135
      Top = 20
      Width = 50
      Height = 15
      Caption = '64-bit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGrayText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object UpDownThreads: TUpDown
      Left = 169
      Top = 40
      Width = 16
      Height = 21
      Associate = EditThreads
      Min = 1
      Max = 255
      Position = 1
      TabOrder = 3
    end
    object UpDownDA: TUpDown
      Left = 169
      Top = 90
      Width = 16
      Height = 21
      Associate = EditDA
      Max = 64
      Position = 4
      TabOrder = 6
    end
    object EditLin32Max: TEdit
      Left = 145
      Top = 115
      Width = 40
      Height = 21
      Alignment = taCenter
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxLength = 5
      NumbersOnly = True
      ParentFont = False
      TabOrder = 7
    end
    object EditMemForOS: TEdit
      Left = 145
      Top = 140
      Width = 40
      Height = 21
      Alignment = taCenter
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxLength = 3
      NumbersOnly = True
      ParentFont = False
      TabOrder = 8
    end
  end
  object PanelLinX: TPanel
    Left = 200
    Top = 5
    Width = 190
    Height = 165
    BevelKind = bkFlat
    BevelOuter = bvNone
    Caption = 'LinX'
    FullRepaint = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGrayText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    VerticalAlignment = taAlignTop
    object CheckBoxGlass: TCheckBox
      Left = 5
      Top = 120
      Width = 180
      Height = 15
      Hint = 
        'When checked, Aero glass will be extended to windows'#39' client are' +
        'a'
      Caption = 'Extend glass (Aero only)'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 5
    end
    object CheckBoxIcon: TCheckBox
      Left = 5
      Top = 80
      Width = 180
      Height = 15
      Hint = 
        'When checked, tray icon will be displayed and LinX will be minim' +
        'ized to tray'
      Caption = 'Tray icon'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object CheckBoxSounds: TCheckBox
      Left = 5
      Top = 60
      Width = 180
      Height = 15
      Hint = 
        'When checked, LinX will play corresponding sounds upon error/suc' +
        'cessful pass'
      Caption = 'Sounds'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object CheckBoxStop: TCheckBox
      Left = 5
      Top = 20
      Width = 180
      Height = 15
      Hint = 
        'When checked, testing will stop once an error is detected (recom' +
        'mended)'
      Caption = 'Stop on error'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 0
    end
    object CheckBoxLog: TCheckBox
      Left = 5
      Top = 40
      Width = 180
      Height = 15
      Hint = 
        'When checked, LinX will automatically save output log after ever' +
        'y single test'
      Caption = 'Auto-save log'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object CheckBoxFilenames: TCheckBox
      Left = 5
      Top = 100
      Width = 180
      Height = 15
      Hint = 
        'When checked, all screenshots and logs will have date and time a' +
        'ppended to their filenames'
      Caption = 'Date/time in filenames'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 4
    end
    object CheckBoxShowHints: TCheckBox
      Left = 5
      Top = 140
      Width = 180
      Height = 15
      Hint = 'When checked, show pop-up hints, just like this one'
      Caption = 'Show hints'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
    end
  end
  object PanelExtApps: TPanel
    Left = 5
    Top = 175
    Width = 385
    Height = 65
    BevelKind = bkFlat
    BevelOuter = bvNone
    Caption = 'External Applications And Graphs'
    FullRepaint = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGrayText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    VerticalAlignment = taAlignTop
    object LabelGraphs: TLabel
      Left = 5
      Top = 45
      Width = 38
      Height = 13
      Hint = 'Select, what graphs to create during testing'
      Caption = 'Graphs:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object CheckBoxTemp: TCheckBox
      Left = 200
      Top = 20
      Width = 140
      Height = 15
      Hint = 
        'When checked, testing will stop if CPU temp exceeds the specifie' +
        'd one'
      Caption = 'Maximum allowed T ('#176'C):'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object EditTemp: TEdit
      Left = 340
      Top = 18
      Width = 24
      Height = 21
      Alignment = taCenter
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxLength = 3
      NumbersOnly = True
      ParentFont = False
      TabOrder = 4
      Text = '75'
    end
    object RBEverest: TRadioButton
      Left = 60
      Top = 20
      Width = 65
      Height = 15
      Caption = 'Everest'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = RBEverestClick
    end
    object RBNone: TRadioButton
      Left = 5
      Top = 20
      Width = 55
      Height = 15
      Caption = 'None'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TabStop = True
      OnClick = RBNoneClick
    end
    object RBSpeedfan: TRadioButton
      Left = 125
      Top = 20
      Width = 65
      Height = 15
      Caption = 'Speedfan'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = RBEverestClick
    end
    object UpDownTemp: TUpDown
      Left = 364
      Top = 18
      Width = 16
      Height = 21
      Associate = EditTemp
      Enabled = False
      Max = 125
      Position = 75
      TabOrder = 5
    end
    object CheckBoxCPUTemp: TCheckBox
      Left = 60
      Top = 45
      Width = 85
      Height = 15
      Caption = 'CPU Temp'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
    end
    object CheckBoxCPUFan: TCheckBox
      Left = 150
      Top = 45
      Width = 85
      Height = 15
      Caption = 'CPU Fan'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
    end
    object CheckBoxCPUVcore: TCheckBox
      Left = 240
      Top = 45
      Width = 85
      Height = 15
      Caption = 'CPU Vcore'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
    end
    object CheckBox12V: TCheckBox
      Left = 330
      Top = 45
      Width = 50
      Height = 15
      Caption = '+12 V'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
    end
  end
end
