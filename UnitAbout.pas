{$STRINGCHECKS OFF}
unit UnitAbout;

interface

uses
  Windows, SysUtils, Classes, {Graphics,} Controls, Forms, StdCtrls, ShellAPI,
  PNGImage, IniFiles, Buttons;

type
  TFormAbout = class(TForm)
    LabelXSLink: TLabel;
    LabelOversLink: TLabel;
    LabelEMail: TLabel;
    LabelMe: TLabel;
    LabelIntel1: TLabel;
    LabelLinpackLink: TLabel;
    LabelIntel2: TLabel;
    LabelPNG: TLabel;
    LabelThanks2: TLabel;
    LabelDiscl: TLabel;
    LabelThanks1: TLabel;
    LabelInfo: TLabel;
    LabelLin: TLabel;
    LabelX: TLabel;
    LabelFacts: TLabel;
    SpeedButtonInfo: TSpeedButton;
    SpeedButtonAbout: TSpeedButton;
    SpeedButtonReadMe: TSpeedButton;
    LabelVersion: TLabel;
    EditEMailLink: TEdit;
    procedure LabelsMouseEnter(Sender: TObject);
    procedure LabelsMouseLeave(Sender: TObject);
    procedure LabelOversLinkClick(Sender: TObject);
    procedure LabelXSLinkClick(Sender: TObject);
    procedure LabelLinpackLinkClick(Sender: TObject);
    procedure LabelUPXLinkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SpeedButtonInfoClick(Sender: TObject);
    procedure SpeedButtonAboutClick(Sender: TObject);
    procedure SpeedButtonReadMeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAbout: TFormAbout;

implementation

uses UnitMain, LinX_routines;

{$R *.dfm}

procedure TFormAbout.FormCreate(Sender: TObject);
  procedure localize;
  var localizationfile : tinifile; str_about : string;
  begin
    With localizationfile do begin
      localizationfile := tinifile.Create(ExtractFilePath(Application.EXEName) +
                          localizationfile_name);
      str_about := readstring('AboutWindow','About', SpeedButtonAbout.Caption);
      SpeedButtonAbout.Caption := str_about;
      Caption := str_about + ' ' + progname;
      SpeedButtonInfo.Caption := readstring('AboutWindow','Info', SpeedButtonInfo.Caption);
      LabelVersion.Caption := ' v' + GetVersion(true);

      if readstring('Info','1','') <> ''
        then LabelInfo.Caption :=readstring('Info','1','') + #13#10 + readstring('Info','2','') +
                   #13#10 + readstring('Info','3','') + #13#10 +
                   readstring('Info','4','')
      else LabelInfo.Caption :=
      'LinX is a simple interface for Intel® Linpack benchmark.' + #13#10 +
      'It checks stability of the system and can detect hardware errors.' + #13#10 +
      'It is recommended to use with temperature monitoring software to avoid possible CPU overheat.' + #13#10 +
      'For high-TDP CPUs (quad-cores) it is advisable to monitor VRM temperature as well.';

      if readstring('Facts','1','') <> ''
        then LabelFacts.Caption:=readstring('Facts','1','') + #13#10 + readstring('Facts','2','') +
                   #13#10 + readstring('Facts','3','') + #13#10 +
                   readstring('Facts','4','') + #13#10 + readstring('Facts','5','')
                   + #13#10 + readstring('Facts','6','') + #13#10 +
                   readstring('Facts','7','')
      else LabelFacts.Caption:=
      'Most interface elements have their context hints.' + #13#10 +
      'Double-clicking main window''s caption will make it stay on top.' + #13#10 +
      'Right mouse click on progressbar will open a menu with some settings.' + #13#10 +
      'Clicking progressbar during testing will toggle different time modes.' + #13#10 +
      'Graphs will only work if Everest or Speedfan import is active.' + #13#10 +
      'Graph windows can be resized, graphs can be saved with double-click.' + #13#10 +
      'List of supported command-line switches: LinX.exe /help.';

      free;
    end;
  end;

var I : integer;
begin
  localize;
  SpeedButtonReadMe.Enabled := fileexists('readme.txt');
  if glass and (Win32MajorVersion >= 6) and CompositingEnabled then begin
    DoubleBuffered := true;
    GlassFrame.Enabled := true;
    for I := 0 to ControlCount - 1 do
      if (Controls[i] is TLabel) then begin
        (Controls[i] as TLabel).GlowSize := 8;
        if ((Controls[i] as TLabel).AutoSize = false) and
          ((Controls[i] as TLabel).Layout = tlCenter)
          then (Controls[i] as TLabel).Top := (Controls[i] as TLabel).Top + 8;
      end;
  end;
  SpeedButtonInfo.Down := true;
  SpeedButtonInfo.Click;
end;

procedure TFormAbout.LabelUPXLinkClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://upx.sourceforge.net', nil, nil, 1);
end;

procedure TFormAbout.LabelXSLinkClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open',
               'http://www.xtremesystems.org/forums/showthread.php?t=201670',
               nil, nil, 1);
end;

procedure TFormAbout.SpeedButtonAboutClick(Sender: TObject);
var I : integer;
begin
  if SpeedButtonAbout.Down then begin
    for I := 0 to ControlCount - 1 do
      if (Controls[i] is TLabel) then
        (Controls[i] as TLabel).Visible := not (((Controls[i] as TLabel).Name = 'LabelInfo') or
          ((Controls[i] as TLabel).Name = 'LabelFacts')) or
          ((Controls[i] as TLabel).Name = 'LabelVersion');
    EditEMailLink.Visible := true;
  end;
end;

procedure TFormAbout.SpeedButtonInfoClick(Sender: TObject);
var I : integer;
begin
  if SpeedButtonInfo.Down then begin
    for I := 0 to ControlCount - 1 do
      if (Controls[i] is TLabel) then
        (Controls[i] as TLabel).Visible := ((Controls[i] as TLabel).Name = 'LabelInfo') or
          ((Controls[i] as TLabel).Name = 'LabelFacts') or
          ((Controls[i] as TLabel).Name = 'LabelVersion');
    EditEMailLink.Visible := false;
  end;
end;

procedure TFormAbout.SpeedButtonReadMeClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'readme.txt', nil, nil, 1);
end;

procedure TFormAbout.LabelOversLinkClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open',
               'http://forums.overclockers.ru/viewtopic.php?t=272642', nil, nil,
               1);
end;

procedure TFormAbout.LabelsMouseEnter(Sender: TObject);
begin
  (sender as Tlabel).Font.Color := TangoOrange3;
end;

procedure TFormAbout.LabelsMouseLeave(Sender: TObject);
begin
  (sender as Tlabel).Font.Color := TangoBlue3;
end;

procedure TFormAbout.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var filename : string;
begin
  if Key = VK_F5 then begin
    if datetimeinnames then filename := AddDateTimeToFilename(progname, 'png', Now)
    else filename := progname + '.png';
    WindowScreenshot(FormMain.Handle, filename);
  end;
end;

procedure TFormAbout.LabelLinpackLinkClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open',
               'http://software.intel.com/en-us/articles/intel-math-kernel-library-linpack-download/',
               nil, nil, 1);
end;

end.
