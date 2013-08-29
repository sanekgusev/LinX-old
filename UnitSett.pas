{$STRINGCHECKS OFF}
unit UnitSett;

interface

uses
  Windows, {Messages,} SysUtils, {Variants,} Classes, {Graphics,} Controls, Forms,
  {Dialogs,} StdCtrls, Spin, ComCtrls, IniFiles, Buttons, ExtCtrls;

type
  TFormSett = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EditLin32Max: TEdit;
    Label4: TLabel;
    EditMemForOS: TEdit;
    CheckBoxGlass: TCheckBox;
    CheckBoxIcon: TCheckBox;
    CheckBoxSounds: TCheckBox;
    Label5: TLabel;
    RB32: TRadioButton;
    RB64: TRadioButton;
    CheckBoxStop: TCheckBox;
    CheckBoxTemp: TCheckBox;
    EditThreads: TEdit;
    UpDownThreads: TUpDown;
    UpDownDA: TUpDown;
    EditDA: TEdit;
    EditTemp: TEdit;
    UpDownTemp: TUpDown;
    CheckBoxLog: TCheckBox;
    RBNone: TRadioButton;
    RBEverest: TRadioButton;
    RBSpeedfan: TRadioButton;
    CBPriority: TComboBox;
    Label6: TLabel;
    CheckBoxFilenames: TCheckBox;
    ButtonOK: TSpeedButton;
    ButtonCancel: TSpeedButton;
    PanelLinpack: TPanel;
    PanelLinX: TPanel;
    CheckBoxShowHints: TCheckBox;
    PanelExtApps: TPanel;
    LabelGraphs: TLabel;
    CheckBoxCPUTemp: TCheckBox;
    CheckBoxCPUFan: TCheckBox;
    CheckBoxCPUVcore: TCheckBox;
    CheckBox12V: TCheckBox;
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RBNoneClick(Sender: TObject);
    procedure RBEverestClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSett: TFormSett;

implementation

uses UnitMain, LinX_routines;

{$R *.dfm}

procedure TFormSett.ButtonOKClick(Sender: TObject);
begin
  NumberOfThreads := UpdownThreads.Position;

  maxsize_lin32 := strtointdef(EditLin32Max.Text, maxsize_lin32);
  maxmem_offset := strtointdef(EditMemForOS.Text, maxmem_offset);

  lin_priority := CBPriority.ItemIndex;
  dataalign := UpdownDA.Position;
  x64mode := RB64.Checked;
  stoponerror := checkboxStop.Checked;
  autosavelog := checkboxLog.Checked;
  sounds := checkboxSounds.Checked;
  datetimeinnames := CheckboxFilenames.Checked;
  FormMain.TrayIcon.Visible := checkboxIcon.Checked;
  glass := checkboxGlass.Checked;
  FormMain.ShowHint := CheckBoxShowHints.Checked;

  stoponoverheat := checkboxTemp.Checked;
  if not stoponoverheat then stop_temp := 0;

  stop_temp := UpdownTemp.Position;

  speedfan_imp := RBSpeedfan.Checked;
  everest_imp := RBEverest.Checked;

  buildtemps := CheckBoxCPUTemp.Checked;
  buildfans := CheckBoxCPUFan.Checked;
  buildvcores := CheckBoxCPUVcore.Checked;
  buildp12vs := CheckBox12V.Checked;

  Close;
end;

procedure TFormSett.ButtonCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFormSett.FormCreate(Sender: TObject);

  procedure localize;
  var localizationfile : tinifile;
  begin
    With localizationfile do begin
      localizationfile := tinifile.Create(ExtractFilePath(Application.EXEName) +
                          localizationfile_name);

      Caption := readstring('SettingsWindow','Caption',Caption);
      Label5.Caption := readstring('SettingsWindow','Mode',
                                   Label5.Caption);
      Label5.Hint := readstring('SettingsWindow','ModeHint',
                                Label5.Hint);
      RB32.Caption := readstring('MeasUnits','32',RB32.Caption);
      RB64.Caption := readstring('MeasUnits','64',RB64.Caption);
      Label1.Caption := readstring('SettingsWindow','NumberOfThreads',
                                   Label1.Caption);
      Label1.Hint := readstring('SettingsWindow','NumberOfThreadsHint',
                                   Label1.Hint);
      Label6.Caption := readstring('SettingsWindow','PriorityClass',
                                   Label6.Caption);
      Label6.Hint := readstring('SettingsWindow','PriorityClassHint',
                                Label6.Hint);
      CBPriority.Items[0] := readstring('SettingsWindow','Idle',
                                        CBPriority.Items[0]);
      CBPriority.Items[1] := readstring('SettingsWindow','BelowNormal',
                                        CBPriority.Items[1]);
      CBPriority.Items[2] := readstring('SettingsWindow','Normal',
                                        CBPriority.Items[2]);
      CBPriority.Items[3] := readstring('SettingsWindow','AboveNormal',
                                        CBPriority.Items[3]);
      CBPriority.Items[4] := readstring('SettingsWindow','High',
                                        CBPriority.Items[4]);
      CBPriority.Items[5] := readstring('SettingsWindow','Realtime',
                                        CBPriority.Items[5]);
      Label2.Caption := readstring('SettingsWindow','DataAlignment',
                                   Label2.Caption);
      Label2.Hint := readstring('SettingsWindow','DataAlignmentHint',
                                   Label2.Hint);
      Label3.Caption := readstring('SettingsWindow','Lin32MaxProblemSize',
                                   Label3.Caption);
      Label3.Hint := readstring('SettingsWindow','Lin32MaxProblemSizeHint',
                                   Label3.Hint);
      Label4.Caption := readstring('SettingsWindow','MemoryToLeave',
                                   Label4.Caption);
      Label4.Hint := readstring('SettingsWindow','MemoryToLeaveHint',
                                   Label4.Hint);
      CheckboxGlass.Caption := readstring('SettingsWindow','ExtendGlass',
                                   CheckboxGlass.Caption);
      CheckboxGlass.Hint := readstring('SettingsWindow','ExtendGlassHint',
                                   CheckboxGlass.Hint);
      CheckboxStop.Caption := readstring('SettingsWindow','StopOnError',
                                   CheckboxStop.Caption);
      CheckboxStop.Hint := readstring('SettingsWindow','StopOnErrorHint',
                                   CheckboxStop.Hint);
      CheckboxLog.Caption := readstring('SettingsWindow','AutoSaveLog',
                                   CheckboxLog.Caption);
      CheckboxLog.Hint := readstring('SettingsWindow','AutoSaveLogHint',
                                   CheckboxLog.Hint);
      CheckboxSounds.Caption := readstring('SettingsWindow','Sounds',
                                   CheckboxSounds.Caption);
      CheckboxSounds.Hint := readstring('SettingsWindow','SoundsHint',
                                   CheckboxSounds.Hint);
      CheckboxIcon.Caption := readstring('SettingsWindow','TrayIcon',
                                   CheckboxIcon.Caption);
      CheckboxIcon.Hint := readstring('SettingsWindow','TrayIconHint',
                                   CheckboxIcon.Hint);
      CheckBoxShowHints.Caption := readstring('SettingsWindow','ShowHints',
                                   CheckBoxShowHints.Caption);
      CheckBoxShowHints.Hint := readstring('SettingsWindow','ShowHintsHint',
                                   CheckBoxShowHints.Hint);
      CheckboxFilenames.Caption := readstring('SettingsWindow','Filenames',
                                   CheckboxFilenames.Caption);
      CheckboxFilenames.Hint := readstring('SettingsWindow','FilenamesHint',
                                   CheckboxFilenames.Hint);

      PanelExtApps.Caption := readstring('SettingsWindow','ExtAppsBox',
                                      PanelExtApps.Caption);
      CheckboxTemp.Caption := readstring('SettingsWindow','MaxTemp',
                                   CheckboxTemp.Caption);
      CheckboxTemp.Hint := readstring('SettingsWindow','MaxTempHint',
                                   CheckboxTemp.Hint);
      RBNone.Caption := readstring('SettingsWindow','None',
                                   RBNone.Caption);
      LabelGraphs.Caption := readstring('SettingsWindow','Graphs',
                                   LabelGraphs.Caption);
      LabelGraphs.Hint := readstring('SettingsWindow','GraphsHint',
                                   LabelGraphs.Hint);
      CheckBoxCPUTemp.Caption := readstring('SettingsWindow','CPUTemp',
                                   CheckBoxCPUTemp.Caption);
      CheckBoxCPUFan.Caption := readstring('SettingsWindow','CPUFan',
                                   CheckBoxCPUFan.Caption);
      CheckBoxCPUVcore.Caption := readstring('SettingsWindow','CPUVcore',
                                   CheckBoxCPUVcore.Caption);

      ButtonOK.Caption := readstring('SettingsWindow','ButtonOK',
                                     ButtonOK.Caption);
      ButtonCancel.Caption := readstring('SettingsWindow','ButtonCancel',
                                         ButtonCancel.Caption);
      free;
    end;
  end;

begin
  if fileexists(localizationfile_name) then localize;
  CBPriority.Left := Label6.Left + Label6.Width + 5;
  CBPriority.Width := PanelLinpack.Width - CBPriority.Left - 5;

  if glass and (Win32MajorVersion >= 6) and CompositingEnabled then begin
    DoubleBuffered := true;
    PanelLinpack.BevelKind := bkNone;
    PanelLinpack.BevelOuter := bvRaised;
    PanelLinX.BevelKind := bkNone;
    PanelLinX.BevelOuter := bvRaised;
    PanelExtApps.BevelKind := bkNone;
    PanelExtApps.BevelOuter := bvRaised;
    PanelLinpack.Left := PanelLinpack.Left - 5;
    PanelLinpack.Top := PanelLinpack.Top - 5;
    PanelLinX.Left := PanelLinX.Left - 5;
    PanelLinX.Top := PanelLinX.Top - 5;
    PanelExtApps.Top := PanelExtApps.Top - 5;
    PanelExtApps.Left := PanelExtApps.Left - 5;
    ButtonOK.Top := ButtonOK.Top - 5;
    ButtonOK.Left := ButtonOK.Left - 5;
    ButtonCancel.Top := ButtonCancel.Top - 5;
    ButtonCancel.Left := ButtonCancel.Left - 5;
    ClientWidth := ClientWidth - 10;
    ClientHeight := ClientHeight - 10;
    GlassFrame.Enabled := true;
    GlassFrame.SheetOfGlass := true;
  end;

  UpDownThreads.Position := NumberOfThreads;
  UpDownDA.Position := dataalign;

  if x64mode then begin
    RB64.Checked := true;
    RB32.Enabled := x64;
  end
  else begin
    RB32.Checked := true;
    RB64.Enabled := x64;
  end;

  CBPriority.ItemIndex := lin_priority;

  EditLin32Max.Text := inttostr(maxsize_lin32);
  EditMemForOS.Text := inttostr(maxmem_offset);

  checkboxStop.Checked := stoponerror;
  checkboxLog.Checked := autosavelog;
  checkboxSounds.Checked := sounds;
  CheckboxIcon.Checked := FormMain.TrayIcon.Visible;
  CheckboxFilenames.Checked := datetimeinnames;
  CheckboxGlass.Enabled := (Win32MajorVersion >= 6) and CompositingEnabled;
  CheckboxGlass.Checked := glass;
  ShowHint := FormMain.ShowHint;
  CheckBoxShowHints.Checked := ShowHint;

  RBEverest.Checked := everest_imp;
  RBSpeedfan.Checked := speedfan_imp;
  checkboxTemp.Checked := stoponoverheat;

  UpDownTemp.Position := stop_temp;

  CheckBoxCPUTemp.Checked := buildtemps;
  CheckBoxCPUFan.Checked := buildfans;
  CheckBoxCPUVcore.Checked := buildvcores;
  CheckBox12V.Checked := buildp12vs;
end;

procedure TFormSett.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var filename : string;
begin
  if Key = VK_F5 then begin
    if datetimeinnames then filename := AddDateTimeToFilename(progname, 'png', Now)
    else filename := progname + '.png';
    WindowScreenshot(FormMain.Handle, filename);
  end;
end;

procedure TFormSett.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    '0'..'9', #8 : begin end;
    #27 : begin
      ButtonCancel.Click;
      Key := #0;
    end;
    #13 : begin
      ButtonOK.Click;
      Key := #0;
    end
  else Key := #0;
  end;
end;

procedure TFormSett.RBEverestClick(Sender: TObject);
begin
  CheckBoxTemp.Enabled := true;
  EditTemp.Enabled := true;
  UpDownTemp.Enabled := true;

  CheckBoxCPUTemp.Enabled := true;
  CheckBoxCPUFan.Enabled := true;
  CheckBoxCPUVcore.Enabled := true;
  CheckBox12V.Enabled := true;

  PanelExtApps.Refresh;
end;

procedure TFormSett.RBNoneClick(Sender: TObject);
begin
  CheckBoxTemp.Enabled := false;
  EditTemp.Enabled := false;
  UpDownTemp.Enabled := false;

  CheckBoxCPUTemp.Enabled := false;
  CheckBoxCPUFan.Enabled := false;
  CheckBoxCPUVcore.Enabled := false;
  CheckBox12V.Enabled := false;

  PanelExtApps.Refresh;
end;

end.
