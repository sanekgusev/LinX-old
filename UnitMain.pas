{$STRINGCHECKS OFF}
unit UnitMain;

interface

uses
  Windows, Messages, SysUtils, {Variants,} Classes, Graphics, Controls, Forms,
  {Dialogs,} StdCtrls, Menus, ExtCtrls, ComCtrls, MMSystem, IniFiles,
  Buttons, UnitLogWatch;

type
  TFormMain = class(TForm)
    ComboBoxPS: TComboBox;
    ComboBoxRuns: TComboBox;
    MemoLog: TMemo;
    LabelPS: TLabel;
    LabelRuns: TLabel;
    ComboBoxMem: TComboBox;
    LabelMem: TLabel;
    TimerMain: TTimer;
    MainMenu: TMainMenu;
    MIAbout: TMenuItem;
    StatusBar: TStatusBar;
    MIGraphs: TMenuItem;
    ListViewTable: TListView;
    SpeedButtonAllMem: TSpeedButton;
    MIFile: TMenuItem;
    MIScreenshot: TMenuItem;
    MILog: TMenuItem;
    MISettings: TMenuItem;
    TrayIcon: TTrayIcon;
    PopupMenuTray: TPopupMenu;
    TMMinimize: TMenuItem;
    TMStart: TMenuItem;
    TMStop: TMenuItem;
    TMExit: TMenuItem;
    TMSep1: TMenuItem;
    TMSep2: TMenuItem;
    PopupMenuSettings: TPopupMenu;
    SM32: TMenuItem;
    SM64: TMenuItem;
    SMSep1: TMenuItem;
    SMStopOnError: TMenuItem;
    SMSounds: TMenuItem;
    SMTrayIcon: TMenuItem;
    MISep1: TMenuItem;
    MIExit: TMenuItem;
    SMSavelog: TMenuItem;
    ShapeBase: TShape;
    SpeedButtonStart: TSpeedButton;
    SpeedButtonStop: TSpeedButton;
    SMThreads: TMenuItem;
    SMSep2: TMenuItem;
    ShapeBar: TShape;
    LabelStatus: TLabel;
    ComboBoxTimesMinutes: TComboBox;
    SMFullSettings: TMenuItem;
    SMSep4: TMenuItem;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Panel1DblClick(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure MIAboutClick(Sender: TObject);
    procedure ComboBoxRunsChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButtonStopClick(Sender: TObject);
    procedure TimerMainTimer(Sender: TObject);
    procedure ComboBoxMemChange(Sender: TObject);
    procedure ComboBoxPSChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButtonStartClick(Sender: TObject);
    procedure MIDisplayClick(Sender: TObject);
    procedure SpeedButtonAllMemClick(Sender: TObject);
    procedure MIScreenshotClick(Sender: TObject);
    procedure MILogClick(Sender: TObject);
    procedure th1Click(Sender: TObject);
    procedure MISettingsClick(Sender: TObject);
    procedure TMMinimizeClick(Sender: TObject);
    procedure ComboBoxMemCloseUp(Sender: TObject);
    procedure ComboBoxPSCloseUp(Sender: TObject);
    procedure SMThreadsClick(Sender: TObject);
    procedure PopupMenuSettingsPopup(Sender: TObject);
    procedure SM32Click(Sender: TObject);
    procedure SMStopOnErrorClick(Sender: TObject);
    procedure SMSavelogClick(Sender: TObject);
    procedure SMSoundsClick(Sender: TObject);
    procedure SMTrayIconClick(Sender: TObject);
    procedure MIExitClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure StatusBarClick(Sender: TObject);
    procedure TMStartClick(Sender: TObject);
    procedure PopupMenuTrayPopup(Sender: TObject);
    procedure TMStopClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OnMinimize(Sender : TObject);

    procedure PSandMem(IsSourceSize : boolean; var PS: integer; showmsg: boolean);
    procedure ShowFreeMemory;
    procedure ShowEstimatedTime;
    procedure ShowElapsedTime;
    procedure ShowFinishTime;
    procedure ToggleTableLog;
    procedure ToggleGlass(enable : boolean);
    procedure ComboBoxTimesMinutesKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure WMNCLBUTTONDBLCLK(var msg: TMessage); message WM_NCLBUTTONDBLCLK;
  public
    { Public declarations }
  end;

  dataarray = array of single;

  function Monitoring(b_everest, b_speedfan, b_temps, b_fans, b_vcores, b_p12vs,
                      b_testing : boolean; var infostr : string) : boolean;
  function SetWinHeight(curr_count : integer; total_count : integer;
                        def_items_count, min_items_count,row_height : byte;
                        def_win_height : integer) : integer;
  procedure SaveSettingsToINI;
  procedure SaveLogFile;
  function GetThreadsString(threads : byte) : string;

const
  inputfile_name = 'lininput';
  temps_file_name = 'CPU Temp';
  fans_file_name = 'CPU Fan speed';
  vcores_file_name = 'CPU Vcore';
  p12vs_file_name = '+12V';
  SFinifile_name = 'Speedfan.ini';
  maininifile_name = 'LinX.ini';
  localizationfile_name = 'local.lng';

  TangoGreen1 = $34e28a;
  TangoGreen2 = $16d273;
  TangoGreen3 = $069a4e;

  TangoBlue1 = $cf9f72;
  //TangoBlue2 = $a46534;
  TangoBlue3 = $874a20;

  TangoRed1 = $2929ef;
  //TangoRed2 = $0000cc;
  TangoRed3 = $0000a4;

  TangoGray1 = $eceeee;
  TangoGray2 = $cfd7d3;
  TangoGray3 = $b6bdba;
  TangoGray6 = $36342e;

  TangoYellow1 = $4fe9fc;
  //TangoYellow2 = $00d4ed;
  TangoYellow3 = $00a0c4;

  TangoOrange1 = $3EAFFC;
  //TangoOrange2 = $0079F5;
  TangoOrange3 = $005CCE;

  TangoViolet1 = $A87FAD;
  //TangoViolet2 = $7B5075;
  TangoViolet3 = $66355C;

  progname = 'LinX';

  //Where OS matters...
  Lin32XP = 16134;
  Lin32Vista = 15500;

  MinProblemSize = 500;
  DefProblemSize = 10000;
  DefNumberOfRuns = 20;
  DefNumberOfMinutes = 30;

var
  FormMain: TFormMain;
  LogWatch : TLogWatchThread;
  version : string;
  sound_time : integer;
  StartTime : TDateTime; total_time : integer; run_time : integer;
  x64, was_error : boolean; glass: boolean = false; everest_imp : boolean = false; speedfan_imp : boolean = false;
  LinpackLog : string;
  time_show_mode : byte = 4;
  LinpackProcessInfo : TProcessInformation;
  win_height : smallint; //Hello, thick vista borders!
  table_line_height : byte;
  temps, fans, vcores, p12vs : dataarray;
  buildtemps : boolean = false; buildfans : boolean = false;
  buildvcores : boolean = false; buildp12vs : boolean = false;
  max_temp : byte = 0;
  SFsettings : array[0..7] of byte;
  total_mem : integer;
  ProblemSize : integer = DefProblemSize; tmpProblemSize : integer;
  NumberOfRuns : integer = DefNumberOfRuns;
  NumberOfMinutes : integer = -1;

  lin32exe_name : string = 'linpack_xeon32.exe';
  lin64exe_name : string = 'linpack_xeon64.exe';

  GraphWindows : array[1..4] of TRect;

  maxsize_lin32 : integer = Lin32XP;
  maxmem_offset : byte = 5;
  dataalign : byte = 4;
  useoptld : boolean = true;
  NumberOfThreads : byte = 0;
  NumberOfCPUs : byte = 0;
  x64mode : boolean = false;
  lin_priority : byte = 2;
  stoponerror : boolean = true;
  autosavelog : boolean = false;
  sounds : boolean = false;
  datetimeinnames : boolean = true;
  stoponoverheat : boolean = false;
  stop_temp : byte = 75;
  simplecaption : boolean = false;

  Tray0, Tray1, Tray2, Tray3 : TIcon;

  str_CPUName : string;
  str_PS_LDnum_align : string;

  { Here they go, the strings! }

  idle_win_capt : string = 'Simply Linpack';
  test_win_capt : string = 'Testing';
  err_win_capt : string = 'Error';
  hot_win_capt : string = 'CPU Overheat';
  done_win_capt : string = 'Finished';
  stop_win_capt : string = 'Stopped';

  str_temps_capt : string = 'CPU Temperature';
  str_fans_capt : string = 'CPU Fan Speed';
  str_vcores_capt : string = 'CPU Core Voltage';
  str_p12vs_capt : string = '+12 V Voltage';

  msg_nomem : string = 'Not enough physical memory! Values corrected.';
  msg_noexe : string = 'Some of the Linpack files are missing. LinX will quit now.';
  msg_lin_error : string = 'Linpack has stopped unexpectedly (not enough memory?). Press the "Log >" button for details';
  msg_exit_prompt : string = 'Testing in progress! Shutdown Linpack and quit anyway?';
  msg_mem2048 : string = 'Cannot allocate more than 2 GB of memory due to Linpack32 limitation. Values corrected.';

  str_stop : string = 'Stopped on demand after';
  str_done : string = 'Finished without errors in';
  str_err : string = 'Stopped upon error after';
  str_hot : string = 'Stopped upon overheat after';
  str_done_err : string = 'Finished with errors in';
  str_freemem : string = 'Physical memory available:';
  str_CPU : string = 'CPU:'; str_peak : string = 'peak';
  str_mib : string = 'MiB'; str_flops : string = 'GFlops';
  str_32 : string = '32-bit'; str_64 : string = '64-bit';
  str_h : string = 'h'; str_m : string = 'm'; str_s : string = 's';
  str_grad : string = '°'; str_volts : string = 'V'; str_mhz : string = 'MHz';
  str_sep : string = '|'; str_log : string = 'Log ›'; str_table : string = '‹ Table';
  str_rpm : string = 'RPM'; str_celsius : string = '°C';
  str_wait : string = 'Please wait…';
  str_finish_time : string = 'Estimated finish time:';
  str_elapsed : string = 'Elapsed';
  str_remaining : string = 'Remaining';
  str_thread : string = 'thread'; str_threads : string = 'threads';
  str_threadsalt : string = 'threads';
  str_custom : string = 'Custom';
  str_tray_hide : string = 'Minimize'; str_tray_restore : string = 'Restore';

  memo_hint1 : string = 'Double click - show free memory';
  memo_hint2 : string = 'Click - cycle time view modes, double click - disable time';
  memo_hint3 : string = 'Right mouse click - settings menu';

  msg_comline : string = 'All command-line parameters start with a „-“ or a „/“,' + #13#10 +
                         'e. g. /help or -help. X is any decimal digit.' + #13#10 + #13#10 +
                         'Supported command-line switches:' + #13#10 + #13#10 +
                         '?, h, help - displays this message;' + #13#10 +
                         'psXXXXX - sets the desired Problem size value;' + #13#10 +
                         'mXXXX - sets the desired Memory to use value in MiB;' + #13#10 +
                         'nXXX - sets the desired Number of runs value;' + #13#10 +
                         'tXXX - sets the desired Time to run (in minutes) value;' + #13#10 +
                         'mm, maxmemory - enable using all available memory;' + #13#10 +
                         '64 - use 64-bit Linpack (ignored on 32-bit OS);' + #13#10 +
                         '32 - use 32-bit Linpack (ignored on 32-bit OS);' + #13#10 +
                         'm, minimized - start minimized;' + #13#10 +
                         'a, autostart - testing will start immediately.' + #13#10 + #13#10 +
                         'Any combination of the above switches is acceptable,' + #13#10 +
                         'however, some switches will override others.';
  msg_comline_capt : string = 'LinX command-line switches';

implementation

uses UnitGraph, UnitSett, UnitAbout, LinX_routines;

{$R *.dfm}

procedure TFormMain.WMNCLBUTTONDBLCLK(var msg: TMessage);
begin
  if msg.wParam = HTCAPTION then
    if FormStyle <> fsStayOnTop then FormStyle := fsStayOnTop
    else FormStyle := fsNormal;
  inherited;
end;

procedure TFormMain.MIAboutClick(Sender: TObject);
begin
  FormAbout := TFormAbout.Create(Self);
  with FormAbout do
    try
      ShowModal;
    finally
      FreeandNil(FormAbout);
    end;
end;

procedure TFormMain.SpeedButtonStopClick(Sender: TObject);
begin
  TerminateProcess(LinpackProcessInfo.hProcess, 2);
end;

procedure TFormMain.SpeedButtonStartClick(Sender: TObject);
var LeadingDimensions : integer;
begin
  was_error := false;
  sound_time := 0;
  max_temp := 0;
  LinpackLog := '';
  run_time := 0;
  total_time := 1;
  StartTime := Now;
  time_show_mode := 1;

  temps := nil;
  fans := nil;
  vcores := nil;
  p12vs := nil;

  PSandMem(true, ProblemSize, false);

  ListviewTable.Clear;
  if not listviewTable.Visible then ToggleTableLog;
  SpeedButtonStop.Enabled := true;
  SpeedButtonStart.Enabled := false;
  SpeedButtonAllMem.Enabled := false;
  MILog.Enabled := true;
  ComboBoxPS.Enabled := false;
  ComboBoxRuns.Enabled := false;
  ComboBoxMem.Enabled := false;
  ComboBoxTimesMinutes.Enabled := false;
  LabelStatus.Hint := memo_hint2;
  Statusbar.Panels[0].Text := '';
  if x64mode then Statusbar.Panels[1].Text := str_64
  else Statusbar.Panels[1].Text := str_32;
  Statusbar.Panels[2].Text := GetThreadsString(NumberOfThreads);
  Statusbar.Panels[3].Text := '';
  Statusbar.Panels[5].Text := '';
  ShapeBar.Pen.Color := TangoGreen3;
  ShapeBar.Visible := false;
  if stoponerror then ShapeBar.Brush.Color := TangoGreen1
  else ShapeBar.Brush.Color := TangoGray2;
  Caption := test_win_capt + ' - ' + version;
  TrayIcon.Icon := Tray0;

  LeadingDimensions := SetLeadingDimensions(ProblemSize, UseOptLD);

  CreateInputFile(inputfile_name, ProblemSize,
                  LeadingDimensions, NumberOfRuns, DataAlign, Version, x64Mode);

  str_PS_LDnum_align := SetOutputString(ProblemSize, LeadingDimensions, DataAlign);

  SaveSettingsToINI;

  LogWatch := TLogWatchThread.Create(true);
  LogWatch.FreeOnTerminate := true;
  LogWatch.Resume;
  ShowElapsedTime;
end;

procedure TFormMain.ToggleTableLog;
begin
  if ListViewTable.Visible then begin
    Statusbar.Panels[5].Text := str_table;
    ListViewTable.Visible := false;
    MemoLog.Text := LinpackLog;
    MemoLog.SelStart := 0;
    Constraints.MaxHeight := win_height - 10 * table_line_height + MemoLog.Lines.Count * 14 - 10;
    if Top + Constraints.MaxHeight < Screen.Height - 40
      then Height := Constraints.MaxHeight;
    ShapeBar.Constraints.MaxWidth := ShapeBar.Constraints.MaxWidth + 50;
    Constraints.MaxWidth := Constraints.MaxWidth + 50; //50 was enough =)
    Constraints.MinWidth := Constraints.MaxWidth;
    MemoLog.Visible := true;
    MemoLog.SetFocus;
  end
  else begin
    Statusbar.Panels[5].Text := str_log;
    MemoLog.Visible := false;
    Constraints.MinWidth := Constraints.MaxWidth - 50;
    Constraints.MaxWidth := Constraints.MaxWidth - 50;
    ShapeBar.Constraints.MaxWidth := ShapeBar.Constraints.MaxWidth - 50;
    Constraints.MaxHeight := SetWinHeight(ListViewTable.Items.Count,
                                          NumberOfRuns,10,5,table_line_height,win_height);
    ListViewTable.Visible := true;
  end;
end;

procedure TFormMain.ComboBoxPSChange(Sender: TObject);
begin
  PSandMem(true, ProblemSize, true);
end;

procedure TFormMain.ComboBoxPSCloseUp(Sender: TObject);
begin
  PSandMem(true, ProblemSize, false);
end;

procedure TFormMain.ComboBoxRunsChange(Sender: TObject);
var number : integer;
begin
  number := strtointdef(ComboBoxRuns.Text, 0);
  ComboboxRuns.Text := inttostr(number);
  if number = 0 then SpeedButtonStart.Enabled := false
  else
    if (ProblemSize >= MinProblemSize) and (time_show_mode > 3) then SpeedButtonStart.Enabled := true;
  if ComboBoxTimesMinutes.ItemIndex = 0 then begin
    if ListViewTable.Visible
      then Constraints.MaxHeight := SetWinHeight(ListViewTable.Items.Count,
                                                number,10,5,table_line_height,
                                                win_height);
    NumberOfRuns := number;
    NumberOfMinutes := -1;
  end
  else begin
    if ListViewTable.Visible
      then Constraints.MaxHeight := 0;
    NumberOfMinutes := number;
    NumberOfRuns := high(integer);
  end;
end;

procedure TFormMain.MIExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFormMain.ComboBoxTimesMinutesKeyPress(Sender: TObject; var Key: Char);
begin
  Key := #0;
end;

procedure TFormMain.ComboBoxMemChange(Sender: TObject);
begin
  PSandMem(false, ProblemSize, true);
end;

procedure TFormMain.ComboBoxMemCloseUp(Sender: TObject);
begin
  PSandMem(false, ProblemSize, false);
end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if time_show_mode < 4 then begin
    if MessageBox(Handle, PChar(msg_exit_prompt), PChar(version),
                  MB_YESNO or MB_ICONQUESTION) = IDYES
      then TerminateProcess(LinpackProcessInfo.hProcess, 2)
    else Action := caNone;
  end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
var maininifile, SFinifile, localizationfile : tinifile;
    ok32, ok64 : boolean; h : integer; EXEDirectory : string;

  procedure FillComboboxMem(var CB : TCombobox; TotalMemory : integer);
  var CurValue, Increment : integer; I : byte;
  begin
    Increment := 16;
    CurValue := 16;
    i := 0;
    while CurValue <= TotalMemory do begin
      CB.Items.Append(Inttostr(CurValue));
      if CurValue <= 256 then Increment := CurValue
      else
        if CurValue >= 2048 then begin
          if (i mod 4 = 0) then inc(Increment, Increment);
          inc(i);
        end;
      inc(CurValue, Increment);
    end;
  end;

  procedure FillComboboxSize(var CB : TCombobox; TotalMemory : integer);
  var MaxProblemSize : integer; i : byte;
  begin
    MaxProblemSize := memtosize(TotalMemory);
    for I := 1 to (MaxProblemSize div 1000) do
      CB.Items.Append(Inttostr(i*1000));
  end;

  procedure FillPopupMenu(var Menu : TMenuItem; Num : byte);
  var Item : TMenuItem; i : byte;
  begin
    for I := 0 to Num - 1 do begin
      item := Tmenuitem.Create(Menu);
      item.Caption := GetThreadsString(i + 1);
      item.RadioItem := true;
      item.AutoCheck := true;
      item.OnClick := th1Click;
      Menu.Insert(Menu.Count, item);
    end;
    item := Tmenuitem.Create(Menu);
    item.Caption := str_custom;
    item.RadioItem := true;
    item.Enabled := false;
    item.Visible := false;
    Menu.Insert(Menu.Count, item);
  end;

  procedure localize;
  begin
    With localizationfile do begin
      localizationfile := tinifile.Create(EXEDirectory +
                          localizationfile_name);
      LabelPS.Caption:=readstring('Interface','ProblemSize',LabelPS.Caption);
      LabelMem.Caption:=readstring('Interface','MemoryToUse',LabelMem.Caption);
      SpeedButtonAllMem.Caption:=readstring('Interface','AllMem',SpeedButtonAllMem.Caption);
      LabelRuns.Caption:=readstring('Interface','NumberOfTimes',LabelRuns.Caption);
      ComboboxTimesMinutes.Items.Strings[0] := readstring('Interface','Times',ComboboxTimesMinutes.Items.Strings[0]);
      ComboboxTimesMinutes.Items.Strings[1] := readstring('Interface','Minutes',ComboboxTimesMinutes.Items.Strings[1]);
      ComboboxTimesMinutes.ItemIndex := 0;
      SpeedButtonStart.Caption:=readstring('Interface','Start',SpeedButtonStart.Caption);
      SpeedButtonStop.Caption:=readstring('Interface','Stop',SpeedButtonStop.Caption);

      LabelPS.Hint:=readstring('Hints','ProblemSize',LabelPS.Hint);
      ComboBoxPS.Hint:=readstring('Hints','ComboboxHint',ComboBoxPS.Hint);
      ComboBoxMem.Hint := ComboBoxPS.Hint;
      ComboBoxRuns.Hint := ComboBoxPS.Hint;
      LabelMem.Hint:=readstring('Hints','MemoryToUse',LabelMem.Hint);
      SpeedButtonAllMem.Hint:=readstring('Hints','AllMem',SpeedButtonAllMem.Hint);
      LabelRuns.Hint:=readstring('Hints','NumberOfTimes',LabelRuns.Hint);
      SpeedButtonStart.Hint:=readstring('Hints','Start',SpeedButtonStart.Hint);
      SpeedButtonStop.Hint:=readstring('Hints','Stop',SpeedButtonStop.Hint);
      memo_hint1:=readstring('Hints','StatusPanel1',memo_hint1);
      memo_hint2:=readstring('Hints','StatusPanel2',memo_hint2);
      memo_hint3:=readstring('Hints','StatusPanel3',memo_hint3);

      MIFile.Caption:=readstring('MainMenu','File',MIFile.Caption);
      MIScreenshot.Caption:=readstring('MainMenu','SaveScreenshot',
                                  MIScreenshot.Caption);
      MILog.Caption:=readstring('MainMenu','SaveTextLog',
                               MILog.Caption);
      MIExit.Caption := readstring('MainMenu','Exit',
                                  MIExit.Caption);
      MISettings.Caption:=readstring('MainMenu','Settings',MISettings.Caption);

      MIGraphs.Caption:=readstring('MainMenu','Graphs',MIGraphs.Caption);

      idle_win_capt:= {version + ' - ' +} readstring('WindowCaptions','Idle',idle_win_capt);
      test_win_capt:= readstring('WindowCaptions','Test',test_win_capt){ + ' - ' + version};
      err_win_capt:= readstring('WindowCaptions','Error',err_win_capt) {+ ' - ' + version};
      hot_win_capt:= readstring('WindowCaptions','Overheat',hot_win_capt) {+ ' - ' + version};
      done_win_capt:= readstring('WindowCaptions','Done',done_win_capt) {+ ' - ' + version};
      stop_win_capt:= readstring('WindowCaptions','Stop',stop_win_capt) {+ ' - ' + version};

      str_temps_capt:=readstring('GraphCaptions','Temp',str_temps_capt);
      str_fans_capt:=readstring('GraphCaptions','Fan',str_fans_capt);
      str_vcores_capt:=readstring('GraphCaptions','VCore',str_vcores_capt);
      str_p12vs_capt:=readstring('GraphCaptions','12V',str_p12vs_capt);

      msg_noexe:=readstring('Messages','NoEXE',msg_noexe);
      msg_nomem:=readstring('Messages','NoMem',msg_nomem);
      msg_mem2048:=readstring('Messages','Lin32Lim',msg_mem2048);
      msg_exit_prompt:=readstring('Messages','ExitConfirm',msg_exit_prompt);

      if readstring('CommandLine','1','') <> ''
        then msg_comline:=readstring('CommandLine','1','') + #13#10 +
                          readstring('CommandLine','2','') + #13#10 + #13#10 +
                          readstring('CommandLine','3','') + #13#10 + #13#10 +
                          readstring('CommandLine','4','') + #13#10 +
                          readstring('CommandLine','5','') + #13#10 +
                          readstring('CommandLine','6','') + #13#10 +
                          readstring('CommandLine','7','') + #13#10 +
                          readstring('CommandLine','8','') + #13#10 +
                          readstring('CommandLine','9','') + #13#10 +
                          readstring('CommandLine','10','') + #13#10 +
                          readstring('CommandLine','11','') + #13#10 +
                          readstring('CommandLine','12','') + #13#10 +
                          readstring('CommandLine','13','') + #13#10 + #13#10 +
                          readstring('CommandLine','14','') + #13#10 +
                          readstring('CommandLine','15','');
      msg_comline_capt := readstring('CommandLine','Caption',msg_comline_capt);

      str_freemem:=readstring('StatusPanel','Idle',str_freemem);
      str_stop:=readstring('StatusPanel','Stop',str_stop);
      str_done:=readstring('StatusPanel','Done',str_done);
      str_done_err:=readstring('StatusPanel','DoneWError',str_done_err);
      str_err:=readstring('StatusPanel','Error',str_err);
      str_hot:=readstring('StatusPanel','Overheat',str_hot);
      msg_lin_error:=readstring('StatusPanel','LinStopped',msg_lin_error);
      str_elapsed:=readstring('StatusPanel','Elapsed',str_elapsed);
      str_remaining:=readstring('StatusPanel','Remaining',str_remaining);
      str_finish_time:=readstring('StatusPanel','FinishTime',str_finish_time);
      str_wait:=readstring('StatusPanel','Wait',str_wait);

      ListViewTable.Columns[0].Caption:=readstring('OutputTable','Number',ListViewTable.Columns[0].Caption);
      ListViewTable.Columns[1].Caption:=readstring('OutputTable','Size',ListViewTable.Columns[1].Caption);
      ListViewTable.Columns[2].Caption:=readstring('OutputTable','LDA',ListViewTable.Columns[2].Caption);
      ListViewTable.Columns[3].Caption:=readstring('OutputTable','Align',ListViewTable.Columns[3].Caption);
      ListViewTable.Columns[4].Caption:=readstring('OutputTable','Time',ListViewTable.Columns[4].Caption);
      ListViewTable.Columns[5].Caption:=readstring('OutputTable','GFlops',ListViewTable.Columns[5].Caption);
      ListViewTable.Columns[6].Caption:=readstring('OutputTable','Residual',ListViewTable.Columns[6].Caption);
      ListViewTable.Columns[7].Caption:=readstring('OutputTable','Residual(norm)',ListViewTable.Columns[7].Caption);

      str_cpu:=readstring('Statusbar','CPU',str_cpu);
      str_peak:=readstring('Statusbar','Peak',str_peak);
      str_sep:=readstring('Statusbar','Separator',str_sep);
      str_log:=readstring('Statusbar','Log',str_log);
      str_table:=readstring('Statusbar','Table',str_table);

      str_mib := readstring('MeasUnits','MiB',str_mib);
      str_flops:=readstring('MeasUnits','GFlops',str_flops);
      str_32 := readstring('MeasUnits','32',str_32);
      str_64 := readstring('MeasUnits','64',str_64);
      SM32.Caption := str_32;
      SM64.Caption := str_64;
      str_h:=readstring('MeasUnits','h',str_h);
      str_m:=readstring('MeasUnits','m',str_m);
      str_s:=readstring('MeasUnits','s',str_s);
      str_grad:=readstring('MeasUnits','Grad',str_grad);
      str_celsius:=readstring('MeasUnits','Celsius',str_celsius);
      str_volts:=readstring('MeasUnits','Volt',str_volts);
      str_mhz:=readstring('MeasUnits','MHz',str_mhz);
      str_rpm:=readstring('MeasUnits','RPM',str_rpm);

      str_tray_hide := readstring('TrayMenu','Minimize',str_tray_hide);
      str_tray_restore := readstring('TrayMenu','Restore',str_tray_restore);
      TMExit.Caption := readstring('TrayMenu','Exit',TMExit.Caption);
      TMStart.Caption := SpeedButtonStart.Caption;
      TMStop.Caption := SpeedButtonStop.Caption;

      SMFullSettings.Caption := readstring('SettingsMenu','AllSettings',SMFullSettings.Caption);
      str_thread := readstring('SettingsMenu','Thread',str_thread);
      str_threads := readstring('SettingsMenu','Threads',str_threads);
      str_threadsalt := readstring('SettingsMenu','ThreadsAlt',str_threadsalt);
      SMThreads.Caption := readstring('SettingsMenu','ThreadsCaption', SMThreads.Caption);
      str_custom := readstring('SettingsMenu','Custom',str_custom);
      SMStopOnError.Caption := readstring('SettingsMenu','StopOnError',SMStopOnError.Caption);
      SMSaveLog.Caption := readstring('SettingsMenu','AutoSaveLog',SMSaveLog.Caption);
      SMSounds.Caption := readstring('SettingsMenu','Sounds',SMSounds.Caption);
      SMTrayIcon.Caption := readstring('SettingsMenu','TrayIcon',SMTrayIcon.Caption);

      free;
    end;
  end;

  procedure ParseCommandLine;
  var i : integer; helpshown, autostart, allmem : boolean; s : string;
  begin
    i := 1;
    helpshown := false;
    autostart := false;
    allmem := SpeedButtonAllMem.Down;
    tmpProblemSize := ProblemSize;
    while (i <= ParamCount) and ((ParamStr(i)[1] = '-') or (ParamStr(i)[1] = '/'))
      do begin
      s := ParamStr(i);
      delete(s, 1, 1);
      if ((s = 'help') or (s = 'h') or (s = '?')) and not helpshown then begin
        helpshown := true;
        MessageBox(Handle, Pchar(msg_comline), Pchar(msg_comline_capt), MB_OK or MB_ICONINFORMATION);
      end
      else
        if (s = 'mm') or (s = 'maxmemory') then allmem := true
        else
          if (s = 'm') or (s = 'minimized') and not TrayIcon.Visible
            then TMMinimize.Click
          else
            if pos('ps', s) = 1 then begin
              delete(s, 1, 2);
              tmpProblemSize := strtointdef(s, ProblemSize);
              allmem := false;
            end
            else
              if pos('m', s) = 1 then begin
                delete(s, 1, 1);
                tmpProblemSize := memtosize(strtointdef(s, sizetomem(ProblemSize)));
                allmem := false;
              end
              else
                if pos('n', s) = 1 then begin
                  delete(s, 1, 1);
                  NumberOfRuns := strtointdef(s, NumberOfRuns);
                  NumberOfMinutes := -1;
                end
                else
                  if pos('t', s) = 1 then begin
                    delete(s, 1, 1);
                    NumberOfRuns := high(integer);
                    NumberOfMinutes := strtointdef(s, DefNumberOfMinutes);
                  end
                  else
                    if (s = 'a') or (s = 'autostart') then autostart := true
                    else
                      if (s = '64') and x64 then x64mode := true
                      else
                        if (s = '32') and x64 then x64mode := false
                        else
                          if s = 'simpletitle' then begin
                            version := progname;
                            simplecaption := true;
                            Caption := version + ' - ' + idle_win_capt;
                          end;
      inc(i);
    end;
    if (NumberOfMinutes = -1) then begin
      ComboboxRuns.Text := inttostr(NumberOfRuns);
      ComboBoxTimesMinutes.ItemIndex := 0;
    end
    else begin
      ComboboxRuns.Text := inttostr(NumberOfMinutes);
      ComboBoxTimesMinutes.ItemIndex := 1;
    end;
    SpeedButtonAllMem.Down := allmem;
    SpeedbuttonAllMem.Click;
    if autostart then SpeedButtonStart.Click;
  end;

begin
  version := progname + ' ' + GetVersion(false);

  EXEDirectory := ExtractFilePath(Application.ExeName);
  SetCurrentDir(EXEDirectory);

  localize;
  Caption := version + ' - ' + idle_win_capt;

  if not fileexists(EXEDirectory + lin32exe_name) then begin
    lin32exe_name := EXEDirectory + '32-bit/' + lin32exe_name;
    ok32 := fileexists(lin32exe_name);
  end
  else begin
    lin32exe_name := EXEDirectory + lin32exe_name;
    ok32 := true;
  end;
  if not fileexists(EXEDirectory + lin64exe_name) then begin
    lin64exe_name := EXEDirectory + '64-bit/' + lin64exe_name;
    ok64 := fileexists(lin64exe_name);
  end
  else begin
    lin64exe_name := EXEDirectory + lin64exe_name;
    ok64 := true;
  end;

  x64 := IsX64Supported;

  if ok32 or (ok64 and x64) then begin

    if x64 then
      if not ok32 then begin
        x64mode := true;
        x64 := false;
      end
      else
        if not ok64 then x64 := false;

    if Screen.PixelsPerInch <> PixelsPerInch then begin
      ScaleBy(Screen.PixelsPerInch, PixelsPerInch);
    end;

    if Win32MajorVersion > 5 then begin
      ClientHeight := 275;
      Constraints.MinHeight := Height - 85;
      table_line_height := 17;
    end
    else begin
      ClientHeight := 241;
      Constraints.MinHeight := Height - 70;
      table_line_height := 14;
    end;
    win_height := Height;

    ClientWidth := 515;
    Constraints.MaxWidth := Width;
    Constraints.MinWidth := Width;

    ComboBoxPS.Left := LabelPS.Left + labelPS.Width + 5;
    LabelMem.Left := ComboBoxMem.Left - LabelMem.Width - 5;
    LabelRuns.Left := ComboBoxRuns.Left - LabelRuns.Width - 5;
    ShapeBar.Constraints.MaxWidth := ShapeBase.Width - 4;

    total_mem := GetTotalMemory;
    FillComboboxMem(ComboboxMem, total_mem);
    FillComboboxSize(ComboboxPS,total_mem);

    //FillChar(SA, SizeOf(TSecurityAttributes), #0);
    //SA.nLength := SizeOf(TSecurityAttributes);
    //SA.bInheritHandle := True;

    //LinpackPipeRead := CreateNamedPipe('\\.\pipe\linx', PIPE_ACCESS_INBOUND or
    //                          FILE_FLAG_OVERLAPPED, 0, 2, 1024, 1024, 0, @SA);
    //LinpackPipeWrite := CreateFile('\\.\pipe\linx', {GENERIC_READ or} GENERIC_WRITE,
    //                      {FILE_SHARE_READ or FILE_SHARE_WRITE}0, @SA, OPEN_EXISTING,
    //                      FILE_ATTRIBUTE_NORMAL{ or FILE_FLAG_OVERLAPPED}, 0);

    LabelStatus.Hint := memo_hint3;
    Application.Title := version;
    Application.OnMinimize := OnMinimize;

    Tray0 := TIcon.Create;
    Tray0.Handle := LoadIcon(HInstance, 'Tray0');
    Tray1 := TIcon.Create;
    Tray1.Handle := LoadIcon(HInstance, 'Tray1');
    Tray2 := TIcon.Create;
    Tray2.Handle := LoadIcon(HInstance, 'Tray2');
    Tray3 := TIcon.Create;
    Tray3.Handle := LoadIcon(HInstance, 'Tray3');

    TrayIcon.Icon := Tray1;
    TrayIcon.Hint := version;
    str_CPUName := GetCPUName;
    Statusbar.Panels[4].Text := str_CPUName;
    Decimalseparator := '.'; //Kiss EConvertError good-bye!

    NumberOfCPUs := GetMaxThreadsNumber;
    FillPopupMenu(SMThreads,NumberOfCPUs);

    if Getdrivetype(Pchar(ExtractFileDrive(Application.EXEName))) = DRIVE_CDROM
      then SetCurrentDir(GetTempFolderPath);

    With maininifile do begin
      maininifile := Tinifile.Create(GetCurrentDir + '\' + maininifile_name);
      ClientHeight := readinteger('Window','ClientHeight',ClientHeight);
      Top := readinteger('Window','Top',Top);
      if Top < 0 then Top := 0
      else
        if Top > Screen.Height - Height then Top := Screen.Height - Height;
      Left := readinteger('Window','Left',Left);
      if Left < 0 then Left := 0
      else
        if Left > Screen.Width - Width then Left := Screen.Width - Width;

      SpeedButtonAllMem.Down := readbool('Settings','UseAllMem',SpeedButtonAllMem.Down);
      stoponerror := readbool('Settings','StopOnError',stoponerror);
      autosavelog := readbool('Settings','AutoSaveLog',autosavelog);
      stop_temp := readinteger('Settings','OverheatValue',stop_temp);
      sounds := readbool('Settings','EnableSounds',sounds);
      datetimeinnames := readbool('Settings','DateTimeInFilenames',datetimeinnames);
      ShowHint:= readbool('Settings','ShowHints',ShowHint);
      Trayicon.Visible := readbool('Settings','TrayIcon',Trayicon.Visible);
      speedfan_imp := readbool('Settings','SpeedfanImport',speedfan_imp);
      everest_imp := readbool('Settings','EverestImport',everest_imp);
      if speedfan_imp or everest_imp then begin
        stoponoverheat := readbool('Settings','StopOnOverheat',stoponoverheat);
      end;
      buildtemps := readbool('Settings', 'TempGraph', buildtemps);
      buildfans := readbool('Settings', 'FanGraph', buildfans);
      buildvcores := readbool('Settings', 'VcoreGraph', buildvcores);
      buildp12vs := readbool('Settings', 'P12VGraph', buildp12vs);

      if Win32MajorVersion >= 6 then begin
        maxsize_lin32 := Lin32Vista;
        glass := readbool('Settings','GlassEffect', glass);
        if CompositingEnabled then begin
          if glass then ToggleGlass(true);
        end
        else glass := false;
      end;

      maxsize_lin32 := readinteger('Advanced','MaximumSizeForLinpack32',maxsize_lin32);
      maxmem_offset := readinteger('Advanced','MaxmemFromFreememOffset',maxmem_offset);

      if x64 then x64mode := readbool('Linpack','x64',true);
      lin_priority := readinteger('Linpack','Priority',lin_priority);
      if lin_priority > 5 then lin_priority := 2;

      if NumberOfCPUs = readinteger('Advanced','LastLogicalCPUs',NumberOfCPUs)
        then begin
        NumberOfThreads := readinteger('Linpack','NumberOfThreads',NumberOfCPUs);
        if NumberOfThreads < 1 then NumberOfThreads := NumberOfCPUs;
      end
      else NumberOfThreads := NumberOfCPUs;

      ProblemSize := readinteger('Linpack','ProblemSize',ProblemSize);
      if (ProblemSize > 99999) or (ProblemSize < MinProblemSize) then ProblemSize := DefProblemSize;
      //ComboBoxPS.Text := inttostr(ProblemSize);

      NumberOfMinutes := readinteger('Linpack','MinutesToRun',NumberOfMinutes);
      if NumberOfMinutes <> -1 then begin
        ComboBoxTimesMinutes.ItemIndex := 1;
        if NumberOfMinutes < 1 then NumberOfMinutes := DefNumberOfMinutes;
        NumberOfRuns := High(integer);
        ComboBoxRuns.Text := inttostr(NumberOfMinutes);
      end
      else begin
        NumberOfRuns := readinteger('Linpack','TimesToRun',NumberOfRuns);
        if NumberOfRuns < 1 then NumberOfRuns := DefNumberOfRuns;
        ComboBoxRuns.Text := inttostr(NumberOfRuns);
      end;
      useoptld := readbool('Linpack','UseOptimizedLeadingDimensions',useoptld);
      dataalign := readinteger('Linpack','DataAlignment',dataalign);
      if dataalign > 64 then dataalign := 4;

      h := (screen.Height - 80) div 4;
      GraphWindows[1].Left := readinteger('Graphs','TempLeft', 40);
      GraphWindows[1].Top := readinteger('Graphs','TempTop', 40);
      GraphWindows[1].Right := readinteger('Graphs','TempWidth', 416) +
                               GraphWindows[1].Left;
      GraphWindows[1].Bottom := readinteger('Graphs','TempHeight', h) +
                                GraphWindows[1].Top;

      GraphWindows[2].Left := readinteger('Graphs','FanLeft', 40);
      GraphWindows[2].Top := readinteger('Graphs','FanTop', GraphWindows[1].Bottom);
      GraphWindows[2].Right := readinteger('Graphs','FanWidth', 416) +
                               GraphWindows[2].Left;
      GraphWindows[2].Bottom := readinteger('Graphs','FanHeight', h) +
                                GraphWindows[2].Top;

      GraphWindows[3].Left := readinteger('Graphs','VcoreLeft', 40);
      GraphWindows[3].Top := readinteger('Graphs','VcoreTop', GraphWindows[2].Bottom);
      GraphWindows[3].Right := readinteger('Graphs','VcoreWidth', 416) +
                               GraphWindows[3].Left;
      GraphWindows[3].Bottom := readinteger('Graphs','VcoreHeight', h) +
                                GraphWindows[3].Top;

      GraphWindows[4].Left := readinteger('Graphs','12VLeft', 40);
      GraphWindows[4].Top := readinteger('Graphs','12VTop', GraphWindows[3].Bottom);
      GraphWindows[4].Right := readinteger('Graphs','12VWidth', 416) +
                               GraphWindows[4].Left;
      GraphWindows[4].Bottom := readinteger('Graphs','12VHeight', h) +
                                GraphWindows[4].Top;

      Free;
    end;

    if fileexists(GetCurrentDir + '\' + SFinifile_name) then with SFinifile do begin
      SFinifile := Tinifile.Create(GetCurrentDir + '\' + SFinifile_name);
      SFsettings[0] := ReadInteger('Speedfan','CPU_temp_num',0);
      SFsettings[1] := ReadInteger('Speedfan','CPU_core0_num',0);
      SFsettings[2] := ReadInteger('Speedfan','CPU_core1_num',0);
      SFsettings[3] := ReadInteger('Speedfan','CPU_core2_num',0);
      SFsettings[4] := ReadInteger('Speedfan','CPU_core3_num',0);
      SFsettings[5] := ReadInteger('Speedfan','CPU_fan_num',0);
      SFsettings[6] := ReadInteger('Speedfan','CPU_vcore_num',0);
      SFsettings[7] := ReadInteger('Speedfan','12V_volt_num',0);
      Free;
    end;

    ComboboxRunsChange(Sender);
    //if SpeedButtonAllMem.Down then SpeedButtonAllMem.Click
    //else PSandMem(true, ProblemSize, false);
    ParseCommandLine;
    TimerMain.Enabled := true;
    ShowFreeMemory;
  end
  else begin
    MessageBox(Handle, Pchar(msg_noexe),Pchar(progname),MB_OK or MB_ICONSTOP);
    Application.Terminate;
  end;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
var SFinifile : Tinifile;
begin
  if not fileexists(GetCurrentDir + '\' + SFinifile_name) then begin
    SFinifile := tinifile.Create(GetCurrentDir + '\' + SFinifile_name);
    try
      SFinifile.WriteInteger('Speedfan','CPU_temp_num',SFsettings[0]);
      SFinifile.WriteInteger('Speedfan','CPU_core0_num',SFsettings[1]);
      SFinifile.WriteInteger('Speedfan','CPU_core1_num',SFsettings[2]);
      SFinifile.WriteInteger('Speedfan','CPU_core2_num',SFsettings[3]);
      SFinifile.WriteInteger('Speedfan','CPU_core3_num',SFsettings[4]);
      SFinifile.WriteInteger('Speedfan','CPU_fan_num',SFsettings[5]);
      SFinifile.WriteInteger('Speedfan','CPU_vcore_num',SFsettings[6]);
      SFinifile.WriteInteger('Speedfan','12V_volt_num',SFsettings[7]);
    finally
      SFinifile.Free;
    end;
  end;

  if Assigned(FormTemps) then FormTemps.Close;
  if Assigned(FormFans) then FormFans.Close;
  if Assigned(FormVcores) then FormVcores.Close;
  if Assigned(FormP12Vs) then FormP12Vs.Close;

  SaveSettingsToINI;
  Tray0.Free;
  Tray1.Free;
  Tray2.Free;
  Tray3.Free;
end;

procedure TFormMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    '0'..'9', #8 : begin end;
    #27 : begin
      if SpeedButtonStop.Enabled then SpeedButtonStop.Click;
      Key := #0;
    end;
    #13 : begin
      if SpeedButtonStart.Enabled then SpeedButtonStart.Click;
      Key := #0;
    end
  else Key := #0;
  end;
end;

procedure TFormMain.FormResize(Sender: TObject);
begin
  GlassFrame.Bottom := ClientHeight;
end;

procedure TFormMain.TimerMainTimer(Sender: TObject);
var tmpstr : string;

  procedure flashpanelontimer;
  begin
    ShapeBar.Width := run_time * ShapeBar.Constraints.MaxWidth div total_time;
    if glass then begin
      if ShapeBar.Pen.Color <> TangoGreen2 xor $00ffffff
        then begin
          ShapeBar.Pen.Color := TangoGreen2 xor $00ffffff;
          ShapeBase.Pen.Mode := pmNotXor;
        end
      else begin
        ShapeBase.Pen.Mode := pmWhite;
        if was_error then ShapeBar.Pen.Color := TangoOrange1 xor $00ffffff
        else
          if stoponerror then ShapeBar.Pen.Color := TangoGreen1 xor $00ffffff
          else ShapeBar.Pen.Color := TangoYellow1 xor $00ffffff;
      end;
    end
    else
      if ShapeBar.Brush.Color <> TangoGreen2 then begin
        ShapeBar.Brush.Color := TangoGreen2;
        ShapeBar.Pen.Color := TangoGreen3;
        ShapeBase.Brush.Color := TangoGray2;
      end
      else begin
        ShapeBase.Brush.Color := TangoGray1;
        if was_error then begin
          ShapeBar.Brush.Color := TangoOrange1;
          ShapeBar.Pen.Color := TangoOrange3;
        end
        else
          if stoponerror then ShapeBar.Brush.Color := TangoGreen1
          else begin
            ShapeBar.Brush.Color := TangoYellow1;
            ShapeBar.Pen.Color := TangoYellow3;
          end;
      end;
  end;

  procedure increasetimecounter;
  begin
    if run_time mod 60 = 0 then begin
      if run_time div 60 = NumberOfMinutes
        then TerminateProcess(LinpackProcessInfo.hProcess, 5);
      run_time := round((Now - StartTime) * 86400);
    end
    else inc(run_time);
  end;

begin
  if speedfan_imp or everest_imp then
    if Monitoring(everest_imp,speedfan_imp, buildtemps, buildfans, buildvcores,
                  buildp12vs, (time_show_mode < 4), tmpstr) then begin
      MIGraphs.Enabled := buildtemps or buildfans or buildvcores or buildp12vs;
      if stoponoverheat and (max_temp > stop_temp) then TerminateProcess(LinpackProcessInfo.hProcess, 6);
      Statusbar.Panels[4].Text := tmpstr;
      if time_show_mode < 4 then begin //strange part I must admit
        if Assigned(FormTemps) and buildtemps then FormTemps.Repaint;
        if Assigned(FormFans) and buildfans then FormFans.Repaint;
        if Assigned(FormVcores) and buildvcores then FormVcores.Repaint;
        if Assigned(FormP12Vs) and buildp12vs then FormP12Vs.Repaint;
      end;
    end
    else begin
      stoponoverheat := false;
      Statusbar.Panels[4].Text := str_CPUName;
      MIGraphs.Enabled := false;
      max_temp := 0;
    end;

  case time_show_mode of
    0 : increasetimecounter;
    1 : begin
      increasetimecounter;
      flashpanelontimer;
      ShowElapsedTime;
    end;
    2 : begin
      increasetimecounter;
      flashpanelontimer;
      ShowEstimatedTime;
    end;
    3 : begin
      increasetimecounter;
      flashpanelontimer;
      ShowFinishTime;
    end;
    4 : ShowFreeMemory;
    5 : begin
      if sound_time mod 3 = 0
        then PlaySound('LowBatteryAlarm', 0, SND_ALIAS or SND_ASYNC); //what a trick!
      inc(sound_time);
    end;
  end;
end;


procedure TFormMain.MIDisplayClick(Sender: TObject);
var dummystr : string;
begin
  if (everest_imp or speedfan_imp) and Monitoring(everest_imp,
    speedfan_imp, buildtemps, buildfans, buildvcores, buildp12vs,
    (time_show_mode < 4), dummystr) then begin

    if buildtemps and not Assigned(FormTemps) then begin
      FormTemps := TFormGraph.Create(FormMain);
      with FormTemps do begin
        Caption := str_temps_capt;
        Width := GraphWindows[1].Right - GraphWindows[1].Left;
        Height := GraphWindows[1].Bottom - GraphWindows[1].Top;
        Left := GraphWindows[1].Left;
        Top := GraphWindows[1].Top;
        Show;
      end;
    end;
    if buildfans and not Assigned(FormFans) then begin
      FormFans := TFormGraph.Create(FormMain);
      with FormFans do begin
        Caption := str_fans_capt;
        Width := GraphWindows[2].Right - GraphWindows[2].Left;
        Height := GraphWindows[2].Bottom - GraphWindows[2].Top;
        Left := GraphWindows[2].Left;
        Top := GraphWindows[2].Top;
        Show;
      end;
    end;
    if buildvcores and not Assigned(FormVcores) then begin
      FormVcores := TFormGraph.Create(FormMain);
      with FormVcores do begin
        Caption := str_vcores_capt;
        Width := GraphWindows[3].Right - GraphWindows[3].Left;
        Height := GraphWindows[3].Bottom - GraphWindows[3].Top;
        Left := GraphWindows[3].Left;
        Top := GraphWindows[3].Top;
        Show;
      end;
    end;
    if buildp12vs and not Assigned(FormP12Vs) then begin
      FormP12Vs := TFormGraph.Create(FormMain);
      with FormP12Vs do begin
        Caption := str_p12vs_capt;
        Width := GraphWindows[4].Right - GraphWindows[4].Left;
        Height := GraphWindows[4].Bottom - GraphWindows[4].Top;
        Left := GraphWindows[4].Left;
        Top := GraphWindows[4].Top;
        Show;
      end;
    end;
    SetFocus;
  end;
end;

procedure TFormMain.th1Click(Sender: TObject);
begin
  NumberOfThreads := SMThreads.IndexOf(sender as tmenuitem) + 1;
end;

procedure TFormMain.Panel1Click(Sender: TObject);
begin
  case time_show_mode of
    1 : begin
    time_show_mode := 2;
    ShowEstimatedTime;
    end;
    2 : begin
    time_show_mode := 3;
    ShowFinishTime;
    end;
    3 : begin
    time_show_mode := 1;
    ShowElapsedTime;
    end;
  end;
end;

procedure TFormMain.Panel1DblClick(Sender: TObject);
begin
  case time_show_mode of
    0: begin
      time_show_mode := 1;
      run_time := 0;
      ShowElapsedTime;
    end;
    1 .. 3 : begin
      time_show_mode := 0;
      ShapeBar.Width := 0;
      LabelStatus.Caption := '';
      Trayicon.Hint := version;
    end;
    4 : SMFullSettings.Click;
    5 .. 6 : begin
      Time_show_mode := 4;
      Trayicon.Hint := version;
      TrayIcon.Icon := Tray1;
      LabelStatus.Hint := memo_hint3;
      Caption := version + ' - ' + idle_win_capt;
      if glass then
        ShapeBar.Pen.Color := TangoGray2 xor $00FFFFFF
      else begin
        ShapeBar.Brush.Color := TangoGray2;
        ShapeBar.Pen.Color := TangoGray3;
        ShapeBase.Brush.Color := TangoGray1;
      end;
      ShowFreeMemory;
    end;
  end;
end;

procedure TFormMain.SMThreadsClick(Sender: TObject);
begin
  if NumberOfThreads <= NumberOfCPUs then begin
    SMThreads.Items[SMThreads.Count - 1].Visible := false;
    SMThreads.Items[NumberOfThreads - 1].Checked := true;
  end
  else begin
    SMThreads.Items[SMThreads.Count - 1].Visible := true;
    SMThreads.Items[SMThreads.Count - 1].Checked := true;
  end;
end;

procedure TFormMain.PopupMenuSettingsPopup(Sender: TObject);
begin
  if x64mode then begin
    SM64.Checked := true;
    SM32.Enabled := x64;
  end
  else begin
    SM32.Checked := true;
    SM64.Enabled := x64;
  end;
  SMStopOnError.Checked := stoponerror;
  SMSaveLog.Checked := autosavelog;
  SMSounds.Checked := sounds;
  SMTrayIcon.Checked := Trayicon.Visible;
  SMFullSettings.Default := (time_show_mode = 4);
end;

procedure TFormMain.PopupMenuTrayPopup(Sender: TObject);
begin
  if Visible then TMMinimize.Caption := str_tray_hide
  else TMMinimize.Caption := str_tray_restore;
  TMStart.Enabled := SpeedButtonStart.Enabled;
  TMStop.Enabled := SpeedButtonStop.Enabled;
end;

function Monitoring(b_everest, b_speedfan, b_temps, b_fans, b_vcores, b_p12vs,
                    b_testing : boolean; var infostr : string) : boolean;
type  TSharedMem = packed record
        version:word;
        flags :word;
        MemSize:integer;
        handle :THandle;
        NumTemps:word;
        NumFans :word;
        NumVolts:word;
        temps:array[0..31] of integer;
        fans :array[0..31] of integer;
        volts:array[0..31] of integer;
      end;
      PSharedmem = ^TSharedmem;
const buf_size = 4096; SF_sharedmem_size = sizeof(TSharedmem);
var buf : PAnsiChar; tm : byte; i,j : byte; value, v12, vcore: single; fan : integer;
    id_cpu, tempstr, status_str : string; SFdata : TSharedMem; //SFdataP : PSharedMem;

  Function ExtApp_SharedMem_ReadBuffer(sharedmem_name : pchar; bu: Pointer; bu_size:integer):Boolean;
  Var mappedData : PansiChar; th : THandle;
  Begin
    Result:=False;
    th:=OpenFileMapping(FILE_MAP_READ,False,sharedmem_name);
    If th<>INVALID_HANDLE_VALUE Then begin
      mappedData:=MapViewOfFile(th,FILE_MAP_READ,0,0,0);
      If mappedData<>Nil Then begin
        StrLCopy(bu,mappedData,bu_size);
        If UnmapViewOfFile(mappedData) Then Result:=True;
      end;
      CloseHandle(th);
    end;
  end;

  function SF_ReadSharedmem (sharedmem_name : pchar; var res : TSharedmem) : boolean;
  Var mappedData : PSharedmem; th : THandle;
  begin
    Result:=False;
    th:=OpenFileMapping(FILE_MAP_READ,False,sharedmem_name);
    If th<>INVALID_HANDLE_VALUE Then begin
      mappedData:=MapViewOfFile(th,FILE_MAP_READ,0,0,SF_sharedmem_size);
      If mappedData<>Nil Then begin
        res := mappeddata^;
        If UnmapViewOfFile(mappedData) Then Result:=True;
      end;
      CloseHandle(th);
    end;
  end;

  function xmltoval(inputst : string; id : string; var value : single) : boolean;
  var p,beg,ttl : integer; errcode : integer;
  begin
    value := 0;
    p := pos(id,inputst);
    if p <> 0 then begin
      inputst := copy(inputst,p, 128);
      beg := pos('<v',inputst) + 7;
      ttl := pos('</v',inputst) - beg;
      val(copy(inputst,beg,ttl),value,errcode);
      result := (errcode = 0);
    end
    else result := false;
  end;

begin
  tm := 0;
  vcore := 0;
  fan := 0;
  v12 := 0;
  result := false;
  if b_everest then begin
    Buf := AllocMem(buf_size + 1);
    if (ExtApp_SharedMem_ReadBuffer(PChar('EVEREST_SensorValues'),buf,buf_size))
    then begin
      result := true;

      tempstr := string(buf);

      for i := 1 to 2 do begin
        j := 1;
        id_cpu := format('TCC-%d-%d',[i, j]);
        while xmltoval(tempstr,id_cpu,value) do begin
          if value > tm then tm := round(value);
          inc(j);
          id_cpu := format('TCC-%d-%d',[i, j]);
        end;
      end;
      if (tm = 0) and (xmltoval(tempstr,'TCPU',value)) then tm := round(value);
      if tm > max_temp then max_temp := tm;

      status_str := str_CPU;
      if tm > 0
        then status_str := format(status_str + ' %d' + str_grad + ' ' + str_sep +
                           ' %d' + str_grad + ' max', [tm, max_temp]);
      if (xmltoval(tempstr,'VCPU',vcore))
        then status_str := status_str + ' ' + str_sep + ' ' +
                           floattostrf(vcore,fffixed,4,3) + ' ' + str_volts;
      if (xmltoval(tempstr,'SCPUCLK',value))
        then status_str := format(status_str + ' ' + str_sep + ' %d ' + str_mhz,
                                  [trunc(value)]);

      if status_str <> str_CPU then infostr := status_str;

      xmltoval(tempstr,'VP12V',v12);
      xmltoval(tempstr,'FCPU',value);
      fan := round(value);
    end;
    FreeMem(Buf);
  end
  else
    if b_speedfan then begin
      if ((SFsettings[0] > 0) or (SFsettings[1] > 0) or (SFsettings[2] > 0) or
         (SFsettings[3] > 0) or (SFsettings[4] > 0) or (SFsettings[5] > 0) or
         (SFsettings[6] > 0) or (SFsettings[7] > 0)) and
          SF_readsharedmem(PChar('SFSharedMemory_ALM'),SFdata)
           then begin

        result := true;

        for I := 1 to 4 do
          if (SFsettings[i] > 0) and (SFsettings[i] - 1 <= SFdata.NumTemps - 1) and
          (SFdata.temps[SFsettings[i] - 1] > tm)
            then tm := SFdata.temps[SFsettings[i] - 1] div 100;
        if (tm = 0) and (SFsettings[0] > 0) and (SFsettings[0] - 1 <= SFdata.NumTemps - 1)
          then tm := SFdata.temps[SFsettings[0] - 1] div 100;
        if tm > max_temp then max_temp := tm;

        status_str := str_CPU;
        if tm > 0
          then status_str := format(status_str + ' %d' + str_grad + ' ' + str_sep +
                             ' %d' + str_grad + ' max', [tm, max_temp]);
        if (SFsettings[6] > 0) and (SFsettings[6] - 1 <= SFdata.NumVolts - 1)
          then begin
          vcore := SFdata.volts[SFsettings[6] - 1] / 100;
          status_str := status_str + ' ' + str_sep + ' ' +
                      floattostrf(vcore,fffixed,3,2) + ' ' + str_volts;
        end;
        if status_str <> str_CPU then infostr := status_str;

        if (SFsettings[7] > 0) and (SFsettings[7] - 1 <= SFdata.NumVolts - 1)
          then v12 := SFdata.volts[SFsettings[7] - 1] / 100;
        if (SFsettings[5] > 0) and (SFsettings[5] - 1 <= SFdata.NumFans - 1)
          then fan := SFdata.fans[SFsettings[5] - 1];
      end;
    end;
  if b_testing and result then begin
    if b_temps and (tm <> 0) then begin
      if length(temps) - 30 < run_time then setlength(temps, length(temps) + 30);
      temps[run_time] := tm;
      temps[run_time + 1] := tm;
    end;
    if b_fans and (fan > 0) then begin
      if length(fans) - 30 < run_time then setlength(fans, length(fans) + 30);
      fans[run_time] := fan;
      fans[run_time + 1] := fan;
    end;
    if b_vcores and (vcore > 0) then begin
      if length(vcores) - 30 < run_time then setlength(vcores, length(vcores) + 30);
      vcores[run_time] := vcore;
      vcores[run_time + 1] := vcore;
    end;
    if b_p12vs and (v12 > 0) then begin
      if length(p12vs) - 30 < run_time then setlength(p12vs, length(p12vs) + 30);
      p12vs[run_time] := v12;
      p12vs[run_time + 1] := v12;
    end;
  end;
end;

procedure TFormMain.MIScreenshotClick(Sender: TObject);
var filename : string;
begin
  if datetimeinnames then filename := AddDateTimeToFilename(progname, 'png', Now)
  else filename := progname + '.png';
  WindowScreenShot(Handle, filename);
end;

procedure TFormMain.MILogClick(Sender: TObject);
begin
  SaveLogFile;
end;

procedure TFormMain.SpeedButtonAllMemClick(Sender: TObject);
begin
  ComboBoxMem.Enabled := not SpeedButtonAllMem.Down;
  ComboBoxPS.Enabled := ComboBoxMem.Enabled;
  if SpeedButtonAllMem.Down then begin
    tmpProblemSize := ProblemSize;
    ComboBoxMem.Text := inttostr(GetFreeMemory - maxmem_offset);
    PSandMem(false, ProblemSize, false);
  end
  else begin
    ComboBoxPS.Text := inttostr(tmpProblemSize);
    PSandMem(true, ProblemSize, false);
  end;
end;

procedure TFormMain.StatusBarClick(Sender: TObject);
begin
  if (Statusbar.ScreenToClient(Mouse.CursorPos).X > 480) and
    (time_show_mode > 3) and (LinpackLog <> '') then ToggleTableLog;
end;

function SetWinHeight(curr_count : integer; total_count : integer;
                      def_items_count, min_items_count,
                      row_height : byte; def_win_height : integer) : integer;
begin
  if (curr_count > def_items_count) and (curr_count > total_count) then
    result := def_win_height - row_height *
      (def_items_count - min_items_count) + (curr_count - def_items_count +
      min_items_count) * row_height
  else
    if (total_count > def_items_count) then
      result := def_win_height - row_height *
      (def_items_count - min_items_count) + (total_count - def_items_count +
      min_items_count) * row_height
    else result := def_win_height;
end;

procedure TFormMain.SM32Click(Sender: TObject);
begin
  (Sender as TMenuitem).Checked := true;
  x64mode := SM64.Checked;
end;

procedure TFormMain.SMStopOnErrorClick(Sender: TObject);
begin
  stoponerror := SMStopOnError.Checked;
end;

procedure TFormMain.SMSavelogClick(Sender: TObject);
begin
  autosavelog := SMSaveLog.Checked;
end;

procedure TFormMain.SMSoundsClick(Sender: TObject);
begin
  sounds := SMSounds.Checked;
end;

procedure TFormMain.SMTrayIconClick(Sender: TObject);
begin
  TrayIcon.Visible := SMTrayIcon.Checked;
end;

procedure TFormMain.MISettingsClick(Sender: TObject);
var tmpglass : boolean;
begin
  tmpglass := glass;
  FormSett := TFormSett.Create(self);
  with FormSett do
  try
    ShowModal;
  finally
    FreeAndNil(FormSett);
  end;
  if not (everest_imp or speedfan_imp) then begin
    Statusbar.Panels[4].Text := str_CPUName;
    MIGraphs.Enabled := false;
  end;
  if glass <> tmpglass then ToggleGlass(glass);
end;

procedure TFormMain.TMMinimizeClick(Sender: TObject);
begin
  if FormMain.Visible then Application.Minimize
  else begin
    Application.Restore;
    If WindowState = wsMinimized then WindowState := wsNormal;
    Visible := True;
    Application.BringToFront;
  end;
end;

procedure TFormMain.TMStartClick(Sender: TObject);
begin
  if SpeedButtonStart.Enabled then SpeedButtonStart.Click;
end;

procedure TFormMain.TMStopClick(Sender: TObject);
begin
  if SpeedButtonStop.Enabled then SpeedButtonStop.Click;
end;

procedure TFormMain.PSandMem(IsSourceSize : boolean; var PS: integer; showmsg: boolean);
var mem, maxmem, size : integer;

  procedure addandnotify(var msg : string);
  begin
     MessageBox(Handle, Pchar(msg),Pchar(version),MB_OK or
                            MB_ICONEXCLAMATION);
     if IsSourceSize then begin
       ComboBoxPS.AddItem(inttostr(size),ComboBoxPS);
       ComboBoxPS.ItemIndex := ComboBoxPS.Items.Count - 1;
       ComboBoxPS.Items.Delete(ComboBoxPS.Items.Count - 2);
     end
     else begin
       ComboBoxMem.AddItem(inttostr(mem),ComboBoxMem);
       ComboBoxMem.ItemIndex := ComboBoxMem.Items.Count - 1;
       ComboBoxMem.Items.Delete(ComboBoxMem.Items.Count - 2);
     end;
  end;

begin
  mem := 0;
  size := 0;
  if IsSourceSize then size := strtointdef(ComboboxPS.Text, 0)
  else mem := strtointdef(ComboBoxMem.Text, 0);
  if (size <> 0) or (mem <> 0) then begin
    if IsSourceSize then begin
      Mem := sizetomem(size);
      if showmsg then ComboBoxMem.Text := inttostr(Mem)
    end
    else begin
      size := memtosize(mem);
      if showmsg then ComboBoxPS.Text := inttostr(size);
    end;
    maxmem := GetFreeMemory - maxmem_offset;
    if mem > maxmem then begin
      mem := maxmem;
      size := memtosize(mem);
      if (not x64mode) and (size > maxsize_lin32) then begin
        size := maxsize_lin32;
        Mem := sizetomem(size);
        if showmsg then addandnotify(msg_mem2048);
      end
      else
        if showmsg then addandnotify(msg_nomem);
    end
    else
      if (not x64mode) and (size > maxsize_lin32) then begin
        size := maxsize_lin32;
        Mem := sizetomem(size);
        if showmsg then addandnotify(msg_mem2048);
      end;
  end;
  PS := size;
  ComboBoxMem.Text := inttostr(Mem);
  ComboBoxPS.Text := inttostr(size);
  if size < MinProblemSize then SpeedButtonStart.Enabled := false
  else
    if (NumberOfRuns > 0) and (time_show_mode > 3) then SpeedButtonStart.Enabled := true;
end;

procedure SaveSettingsToINI;
var maininifile : tinifile;
begin
  with maininifile do begin
    maininifile := tinifile.Create(GetCurrentDir + '\' + maininifile_name);
    try
      writeinteger('Window','Top',FormMain.Top);
      writeinteger('Window','Left',FormMain.Left);
      writeinteger('Window','ClientHeight',FormMain.ClientHeight);
      writebool('Settings','UseAllMem',FormMain.SpeedButtonAllMem.Down);
      writebool('Settings','StopOnError',stoponerror);
      writebool('Settings','AutoSaveLog', autosavelog);
      writebool('Settings','StopOnOverheat',stoponoverheat);
      writeinteger('Settings','OverheatValue',stop_temp);
      writebool('Settings','EnableSounds',sounds);
      writebool('Settings', 'GlassEffect', glass);
      writebool('Settings','ShowHints',FormMain.ShowHint);
      writebool('Settings','TrayIcon',FormMain.Trayicon.Visible);
      writebool('Settings','DateTimeInFilenames',datetimeinnames);
      writebool('Settings','EverestImport',everest_imp);
      writebool('Settings','SpeedfanImport',speedfan_imp);
      writebool('Settings', 'TempGraph', buildtemps);
      writebool('Settings', 'FanGraph', buildfans);
      writebool('Settings', 'VcoreGraph', buildvcores);
      writebool('Settings', 'P12VGraph', buildp12vs);

      writeinteger('Advanced','MaximumSizeForLinpack32',maxsize_lin32);
      writeinteger('Advanced','MaxmemFromFreememOffset',maxmem_offset);
      writeinteger('Advanced','LastLogicalCPUs',NumberOfCPUs);

      writeinteger('Linpack','ProblemSize',ProblemSize);
      writeinteger('Linpack','TimesToRun',NumberOfRuns);
      writeinteger('Linpack','MinutesToRun',NumberOfMinutes);
      writebool('Linpack','UseOptimizedLeadingDimensions',useoptld);
      writeinteger('Linpack','DataAlignment',dataalign);
      writeinteger('Linpack','NumberOfThreads',NumberOfThreads);
      writebool('Linpack','x64',x64mode);
      writeinteger('Linpack','Priority',lin_priority);

      writeinteger('Graphs','TempLeft', GraphWindows[1].Left);
      writeinteger('Graphs','TempTop', GraphWindows[1].Top);
      writeinteger('Graphs','TempWidth', GraphWindows[1].Right -
                    GraphWindows[1].Left);
      writeinteger('Graphs','TempHeight', GraphWindows[1].Bottom -
                    GraphWindows[1].Top);

      writeinteger('Graphs','FanLeft', GraphWindows[2].Left);
      writeinteger('Graphs','FanTop', GraphWindows[2].Top);
      writeinteger('Graphs','FanWidth', GraphWindows[2].Right -
                    GraphWindows[2].Left);
      writeinteger('Graphs','FanHeight', GraphWindows[2].Bottom -
                    GraphWindows[2].Top);

      writeinteger('Graphs','VcoreLeft', GraphWindows[3].Left);
      writeinteger('Graphs','VoreTop', GraphWindows[3].Top);
      writeinteger('Graphs','VcoreWidth', GraphWindows[3].Right -
                    GraphWindows[3].Left);
      writeinteger('Graphs','VcoreHeight', GraphWindows[3].Bottom -
                    GraphWindows[3].Top);

      writeinteger('Graphs','12VLeft', GraphWindows[4].Left);
      writeinteger('Graphs','12VTop', GraphWindows[4].Top);
      writeinteger('Graphs','12VWidth', GraphWindows[4].Right -
                    GraphWindows[4].Left);
      writeinteger('Graphs','12VHeight', GraphWindows[4].Bottom -
                    GraphWindows[4].Top);
      free;
    except
      free;
    end;
  end;
end;

procedure TFormMain.ShowFreeMemory;
var freemem : integer;
begin
  freemem := GetFreeMemory;
  ShapeBar.Width := freemem * (ShapeBase.Width - 4) div total_mem;
  LabelStatus.Caption := format(str_freemem + ' %d ' + str_mib, [freemem]);
end;

procedure TFormMain.ShowElapsedTime;
var timestr : string;
begin
  timestr := str_elapsed + Format(' %d:%.2d:%.2d', [run_time div 3600,
    (run_time mod 3600) div 60, run_time mod 60]);
  LabelStatus.Caption := timestr;
  if TrayIcon.Visible then Trayicon.Hint := timestr + ' - ' + version;
end;

procedure TFormMain.ShowEstimatedTime;
var timestr : string;
begin
  if ShapeBar.Visible then begin
    timestr := str_remaining + Format(' %d:%.2d:%.2d', [(total_time - run_time) div 3600,
    ((total_time - run_time) mod 3600) div 60, (total_time - run_time) mod 60]);
    if TrayIcon.Visible then Trayicon.Hint := timestr + ' - ' + version;
  end
  else begin
    timestr := str_wait;
    if TrayIcon.Visible then Trayicon.Hint := version;
  end;
  LabelStatus.Caption := timestr;
end;

procedure TFormMain.ShowFinishTime;
var timestr : string;
begin
  if ShapeBar.Visible then begin
    timestr := str_finish_time + FormatDateTime(' dddd, t', StartTime + total_time / 86400);
    if TrayIcon.Visible then Trayicon.Hint := timestr + ' - ' + version;
  end
  else begin
    timestr := str_wait;
    if TrayIcon.Visible then Trayicon.Hint := version;
  end;
  LabelStatus.Caption := timestr;
end;

procedure SaveLogFile;
var filename : string;
begin
  if datetimeinnames then filename := AddDateTimeToFilename(progname, 'log', StartTime)
  else filename := progname + '.log';
  with TFileStream.Create(filename, fmCreate) do
    try
      Write(Pointer(LinpackLog)^, Length(LinpackLog) * Sizeof(LinpackLog[1]));
    finally
      Free;
    end;
end;

function GetThreadsString(threads : byte) : string;
begin
  if (threads mod 10 = 1) and (threads <> 11) then result := format('%d ' + str_thread, [threads])
  else
    if (threads mod 10 < 5) and (threads >= 22) then result := format('%d ' + str_threads, [threads])
    else result := format('%d ' + str_threadsalt, [threads]);
end;

procedure TFormMain.ToggleGlass(enable : boolean);
begin
  if enable and CompositingEnabled then begin
    DoubleBuffered := true;
    GlassFrame.Enabled := true;
    SpeedButtonAllMem.Flat := false;
    Glassframe.Bottom := ClientHeight;
    ListViewTable.Columns.BeginUpdate;
    ListViewTable.Columns.EndUpdate;
    LabelPS.GlowSize := 8;
    LabelMem.GlowSize := 8;
    LabelRuns.GlowSize := 8;
    LabelStatus.GlowSize := 8;
    ShapeBase.Brush.Style := bsClear;
    ShapeBase.Pen.Mode := pmWhite;
    ShapeBar.Top := ShapeBar.Top + 1;
    ShapeBar.Left := ShapeBar.Left + 1;
    ShapeBar.Height := ShapeBar.Height - 2;
    ShapeBar.Width := ShapeBar.Width - 2;
    ShapeBar.Constraints.MaxWidth := ShapeBar.Constraints.MaxWidth - 2;
    ShapeBar.Pen.Color := ShapeBar.Brush.Color xor $00ffffff;
    ShapeBar.Brush.Style := bsClear;
    ShapeBar.Pen.Mode := pmNotXor;
    ShapeBar.Pen.Width := 11;
    SpeedButtonAllMem.Layout := blGlyphLeft;
    SpeedButtonStart.Left := SpeedButtonStart.Left - 5;
    SpeedButtonStart.Width := SpeedButtonStart.Width + 5;
    SpeedButtonStop.Width := SpeedButtonStop.Width + 5;
    LabelPS.Left := LabelPS.Left - 3;
    ComboboxPS.Left := ComboboxPS.Left - 3;
    LabelRuns.Left := LabelRuns.Left + 4;
    ComboboxRuns.Left := ComboboxRuns.Left + 4;
    ComboboxTimesMinutes.Left := ComboboxTimesMinutes.Left + 4;
    ComboboxTimesMinutes.Style := csDropDown;
    OnResize := FormResize;
  end
  else begin
    DoubleBuffered := false;
    GlassFrame.Enabled := false;
    SpeedButtonAllMem.Flat := true;
    Glassframe.Bottom := 0;
    LabelPS.GlowSize := 0;
    LabelMem.GlowSize := 0;
    LabelRuns.GlowSize := 0;
    LabelStatus.GlowSize := 0;
    ShapeBase.Brush.Style := bsSolid;
    ShapeBase.Pen.Mode := pmCopy;
    ShapeBar.Top := ShapeBar.Top - 1;
    ShapeBar.Left := ShapeBar.Left - 1;
    ShapeBar.Height := ShapeBar.Height + 2;
    ShapeBar.Constraints.MaxWidth := ShapeBar.Constraints.MaxWidth + 2;
    ShapeBar.Width := ShapeBar.Width + 2;
    ShapeBar.Brush.Style := bsSolid;
    ShapeBar.Brush.Color := ShapeBar.Pen.Color xor $00ffffff;
    ShapeBar.Pen.Mode := pmCopy;
    ShapeBar.Pen.Width := 1;
    SpeedButtonAllMem.Layout := blGlyphTop;
    SpeedButtonStart.Left := SpeedButtonStart.Left + 5;
    SpeedButtonStart.Width := SpeedButtonStart.Width - 5;
    SpeedButtonStop.Width := SpeedButtonStop.Width - 5;
    LabelPS.Left := LabelPS.Left + 3;
    ComboboxPS.Left := ComboboxPS.Left + 3;
    LabelRuns.Left := LabelRuns.Left - 4;
    ComboboxRuns.Left := ComboboxRuns.Left - 4;
    ComboboxTimesMinutes.Left := ComboboxTimesMinutes.Left - 4;
    ComboboxTimesMinutes.Style := csDropDownList;
    OnResize := nil;
    if time_show_mode = 4 then begin
      ShapeBar.Pen.Color := TangoGray3;
      ShapeBase.Brush.Color := TangoGray1;
    end;
  end;
  ComboboxPS.Repaint;
  ComboboxMem.Repaint;
  ComboboxRuns.Repaint;
  ComboboxTimesMinutes.Repaint;
end;

{procedure TFormMain.ToggleMenu(enable : boolean);
begin
  if enable then begin
    Menu := MainMenu;
    GlassFrame.SheetOfGlass := false;
    if glass then OnResize := FormResize;
  end
  else begin
    Menu := nil;
    if glass then GlassFrame.SheetOfGlass := true;
    OnResize := nil;
  end;
end;}

procedure TFormMain.OnMinimize(Sender : TObject);
begin
  if TrayIcon.Visible then Visible := false;
end;

end.
