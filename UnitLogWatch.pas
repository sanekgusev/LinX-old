{$STRINGCHECKS OFF}
unit UnitLogWatch;

interface

uses
  Classes, Windows, SysUtils, Graphics, Forms, ExtCtrls, MMSystem;

type
  TLogWatchThread = class(TThread)
  private
    { Private declarations }
    s : string;
    flops_st, res_norm_st : string;
    flops, max_flops : single;
    stopcode : byte;
    curr : word;
    procedure UpdateMainForm;
    procedure UnhideProgressbar;
    procedure FullProgressbar;
    procedure StopExecution;
  protected
    procedure Execute; override;
  end;

  function AppendMonitoringData : string;

implementation

uses UnitMain, LinX_routines;

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TLogWatchThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TLogWatchThread }

procedure TLogWatchThread.UpdateMainForm;
var runs_st : string;
begin
  with FormMain do begin
    ListViewTable.Items.BeginUpdate;
    with ListViewTable.Items.Add do begin
      Caption := inttostr(curr);
      SubItems.Text := str_PS_LDnum_align + trimright(copy(s, 22, 7)) +
                          #13 + flops_st + #13 + copy(s, 42, 13) +
                          #13 + res_norm_st;
      MakeVisible(false);

      if flops > max_flops then begin
        Selected := true;
        max_flops := flops;
        Statusbar.Panels[3].Text := flops_st + ' ' + str_flops + ' ' + str_peak;
      end;
    end;
    ListViewTable.Items.EndUpdate;

    if NumberOfMinutes <> -1 then runs_st := format('%d/∞', [curr])
    else runs_st := format('%d/%d', [curr, NumberOfRuns]);
    Statusbar.Panels[0].Text := runs_st;
    if simplecaption then Caption := test_win_capt + ' - ' + version
    else Caption := test_win_capt + ' (' + runs_st + ') - ' + version;
  end;
end;

procedure TLogWatchThread.UnhideProgressbar;
begin
  With FormMain do begin
    ShapeBar.Width := 0;
    ShapeBar.Visible := true;
  end;
end;

procedure TLogWatchThread.FullProgressbar;
begin
  With FormMain do
    ShapeBar.Width := ShapeBar.Constraints.MaxWidth;
end;

procedure TLogWatchThread.StopExecution;
var tmpstr : string;

  function TimeToString(Time : TDateTime) : string;
  var Hour, Minute, Second : byte; totalseconds : cardinal;
  begin
    totalseconds := round(Time * 86400);
    Hour := totalseconds div 3600;
    Minute := (totalseconds mod 3600) div 60;
    Second := totalseconds mod 60;
    if Hour = 0 then
      if Minute > 0 then result := format('%d ' + str_m + ' %d ' + str_s, [Minute,Second])
      else result := format('%d ' + str_s, [Second])
    else
      result := format('%d ' + str_h + ' %d ' + str_m + ' %d ' + str_s, [Hour,Minute,Second]);
  end;

begin
  With FormMain do begin
    SpeedButtonStop.Enabled := false;
    if not SpeedButtonAllMem.Down then begin
      ComboBoxPS.Enabled := true;
      ComboBoxMem.Enabled := true;
    end;
    ComboBoxRuns.Enabled := true;
    ComboBoxTimesMinutes.Enabled := true;
    SpeedButtonStart.Enabled := true;
    SpeedButtonAllMem.Enabled := true;
    LabelStatus.Hint := memo_hint1;
    time_show_mode := 6;
    Statusbar.Panels[5].Text := str_log;

    case stopcode of  //a story with many endings
      0 : begin
        ShapeBar.Brush.Color := TangoGray2;
        ShapeBar.Pen.Color := TangoGray3;
        //ShapeBase.Brush.Color := TangoGray1;
        LabelStatus.Caption := msg_lin_error;
        if not Visible then begin
          Trayicon.BalloonHint := msg_lin_error;
          Trayicon.BalloonFlags := bfWarning;
          TrayIcon.ShowBalloonHint;
        end;
        Trayicon.Hint := version;
        TrayIcon.Icon := Tray1;
        Caption := version + ' - ' + idle_win_capt;
      end;
      1 : begin
        tmpstr := str_done + ' ' + TimeToString(Now - StartTime);
        ShapeBar.Brush.Color := TangoBlue1;
        ShapeBar.Pen.Color := TangoBlue3;
        LabelStatus.Caption := tmpstr;
        if not Visible then begin
          Trayicon.BalloonHint := tmpstr;
          Trayicon.BalloonTitle := done_win_capt;
          Trayicon.BalloonFlags := bfInfo;
          TrayIcon.ShowBalloonHint;
        end;
        Trayicon.Hint := done_win_capt + ' - ' + version;
        Trayicon.Icon := Application.Icon;
        Caption := done_win_capt + ' - ' + version;
        if sounds then PlaySound('SystemExclamation', 0, SND_ALIAS or SND_ASYNC);
      end;
      2 : begin
        ShapeBar.Brush.Color := TangoYellow1;
        ShapeBar.Pen.Color := TangoYellow3;
        LabelStatus.Caption := str_stop + ' ' + TimeToString(Now - StartTime);
        TrayIcon.Icon := Tray3;
        Trayicon.Hint := stop_win_capt + ' - ' + version;
        Caption := stop_win_capt + ' - ' + version;
      end;
      3 : begin
        tmpstr := str_err + ' ' + TimeToString(Now - StartTime) + '!';
        ShapeBar.Brush.Color := TangoRed1;
        ShapeBar.Pen.Color := TangoRed3;
        LabelStatus.Caption := tmpstr;
        if not Visible then begin
          Trayicon.BalloonHint := tmpstr;
          Trayicon.BalloonTitle := err_win_capt;
          Trayicon.BalloonFlags := bfError;
          TrayIcon.ShowBalloonHint;
        end;
        Trayicon.Hint := err_win_capt + ' - ' + version;
        TrayIcon.Icon := Tray2;
        Caption := err_win_capt + ' - ' + version;
        WindowFlash(FLASHW_TRAY, Handle, 3, 250);
        if sounds then time_show_mode := 5;
      end;
      4 : begin
        tmpstr := str_done_err + ' ' + TimeToString(Now - StartTime) + '!';
        ShapeBar.Brush.Color := TangoRed1;
        ShapeBar.Pen.Color := TangoRed3;
        LabelStatus.Caption := tmpstr;
        if not Visible then begin
          Trayicon.BalloonHint := tmpstr;
          Trayicon.BalloonTitle := done_win_capt;
          Trayicon.BalloonFlags := bfError;
          TrayIcon.ShowBalloonHint;
        end;
        Trayicon.Hint := done_win_capt + ' - ' + version;
        TrayIcon.Icon := Tray2;
        Caption := done_win_capt + ' - ' + version;
        WindowFlash(FLASHW_TRAY, Handle, 3, 250);
        if sounds then PlaySound('LowBatteryAlarm', 0, SND_ALIAS or SND_ASYNC);
      end;
      5 : begin
        tmpstr := str_done + ' ' + TimeToString(Now - StartTime);
        ShapeBar.Brush.Color := TangoViolet1;
        ShapeBar.Pen.Color := TangoViolet3;
        LabelStatus.Caption := tmpstr;
        if not Visible then begin
          Trayicon.BalloonHint := tmpstr;
          Trayicon.BalloonTitle := done_win_capt;
          Trayicon.BalloonFlags := bfInfo;
          TrayIcon.ShowBalloonHint;
        end;
        Trayicon.Hint := done_win_capt + ' - ' + version;
        Trayicon.Icon := Application.Icon;
        Caption := done_win_capt + ' - ' + version;
        if sounds then PlaySound('SystemExclamation', 0, SND_ALIAS or SND_ASYNC);
      end;
      6 : begin
        tmpstr := str_hot + ' ' + TimeToString(Now - StartTime);
        ShapeBar.Brush.Color := TangoYellow1;
        ShapeBar.Pen.Color := TangoYellow3;
        LabelStatus.Caption := tmpstr;
        if not Visible then begin
          Trayicon.BalloonHint := tmpstr;
          Trayicon.BalloonTitle := hot_win_capt;
          Trayicon.BalloonFlags := bfWarning;
          TrayIcon.ShowBalloonHint;
        end;
        Trayicon.Hint := hot_win_capt + ' - ' + version;
        TrayIcon.Icon := Tray3;
        Caption := hot_win_capt+ ' - ' + version;
        if sounds then time_show_mode := 5;
      end;
    end;

    if glass then begin
      ShapeBar.Pen.Color := ShapeBar.Brush.Color xor $00FFFFFF;
      ShapeBar.Brush.Style := bsClear;
      ShapeBase.Pen.Mode := pmWhite;
    end;
  end;
end;

function AppendMonitoringData : string;
var tmpstr : string; tmpmin, tmpmax : real; arrlen : integer;
begin
  if (temps <> nil) or (fans <> nil) or (vcores <> nil) or (p12vs <> nil)
    then begin
    tmpstr := #13#10#13#10 + 'Monitoring data:' + #13#10;
    arrlen := run_time;
    if temps <> nil then begin
      if length(temps) < arrlen then arrlen := length(temps);
      CalcMinMax(temps, arrlen, tmpmin, tmpmax);
      tmpstr := tmpstr + #13#10 + Format('CPU Temperature  Min: %d C Max %d C', [round(tmpmin), round(tmpmax)]);
    end;
    if fans <> nil then begin
      if length(fans) < arrlen then arrlen := length(fans);
      CalcMinMax(fans, arrlen, tmpmin, tmpmax);
      tmpstr := tmpstr + #13#10 + Format('CPU Fan Speed    Min: %d RPM Max %d RPM', [round(tmpmin), round(tmpmax)]);
    end;
    if vcores <> nil then begin
      if length(vcores) < arrlen then arrlen := length(vcores);
      CalcMinMax(vcores, arrlen, tmpmin, tmpmax);
      tmpstr := tmpstr + #13#10 + Format('CPU Vcore        Min: %f V Max %f V', [tmpmin, tmpmax]);
    end;
    if p12vs <> nil then begin
      if length(p12vs) < arrlen then arrlen := length(p12vs);
      CalcMinMax(p12vs, arrlen, tmpmin, tmpmax);
      tmpstr := tmpstr + #13#10 + Format('+12V Voltage     Min: %f V Max %f V', [tmpmin, tmpmax]);
    end;
    result := tmpstr;
  end;
end;


procedure TLogWatchThread.Execute;
var PipeReadEvent, LinpackPipeRead, LinpackPipeWrite : THandle; lin_exe : string;
var res_str : string;
begin
  { Place thread code here }
  //FreeOnTerminate := true;
  stopcode := 1;
  curr := 0;
  max_flops := 0;
  s := '';
  PipeReadEvent := CreateEvent(nil, true, false, nil);

  if x64mode then lin_exe := lin64exe_name
  else lin_exe := lin32exe_name;
  StartLinpack(lin_exe, inputfile_name, NumberOfThreads, lin_priority,
               LinpackProcessInfo, LinpackPipeRead, LinpackPipeWrite);

  SetThreadPriority(Handle, THREAD_PRIORITY_IDLE);
  if Win32MajorVersion > 5 then SetThreadPriority(Handle, $00010000);
  LinpackLog := LinpackLog + ReadLogHeader(LinpackPipeRead,
    LinpackProcessInfo.hProcess, PipeReadEvent, stopcode);
  DeleteFile(inputfile_name);

  while (curr < NumberOfRuns) and (stopcode = 1)
    and ReadLogString(LinpackPipeRead, LinpackProcessInfo.hProcess,
    PipeReadEvent, s, stopcode)
    do begin

    inc(curr);

    LinpackLog := LinpackLog + s;
    if autosavelog then SaveLogFile;

    flops_st := trimright(copy(s, 33, 8));
    flops := strtofloatdef(flops_st, 0);
    res_norm_st := copy(s, 56, 13);

    if NumberOfMinutes <> -1 then total_time := NumberOfMinutes * 60
    else total_time := round((Now - StartTime) / curr * NumberOfRuns * 86400);

    Synchronize(UpdateMainForm);

    if curr = 1 then begin
      Synchronize(UnhideProgressbar);
    end;
    res_str := copy(s, 72, 4);
    if pos(res_str, 'pass') = 0 then
      if stoponerror then stopcode := 3
      else was_error := true;

  end;

  case stopcode of
    1 : begin
          LinpackLog := LinpackLog + ReadLogFooter(LinpackPipeRead, LinpackProcessInfo.hProcess,
    PipeReadEvent);
          Synchronize(FullProgressbar);
          if was_error then stopcode := 4;
          WaitForSingleObject(LinpackProcessInfo.hProcess, INFINITE);
        end;
    3 : TerminateProcess(LinpackProcessInfo.hProcess, 3);
  end;
  if stopcode > 6 then stopcode := 0;

  LinpackLog := LinpackLog + AppendMonitoringData;
  if autosavelog then SaveLogFile;

  CloseHandle(PipeReadEvent);

  DisconnectNamedPipe(LinpackPipeRead);
  CloseHandle(LinpackPipeWrite);
  CloseHandle(LinpackPipeRead);

  CloseHandle(LinpackProcessInfo.hThread);
  CloseHandle(LinpackProcessInfo.hProcess);

  if Win32MajorVersion > 5 then SetThreadPriority(Handle, $00020000);
  Synchronize(StopExecution);
end;

end.
