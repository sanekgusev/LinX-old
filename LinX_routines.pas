{$STRINGCHECKS OFF}
unit LinX_routines;

interface
uses Windows;

procedure CreateInputFile(FileName : string;
                         ProblemSize, LeadingDimensions : cardinal;
                         NumberOfRuns : word;
                         DataAlignment : byte;
                         Version : string;
                         x64Mode : boolean);

function SetOutputString(ProblemSize, LeadingDimensions : cardinal;
                         DataAlignment : byte) : string;

function SetLeadingDimensions(ProblemSize : cardinal;
                              Optimal : boolean) : cardinal;

function StartLinpack(FileName : string; InputFileName : string;
                      NumberOfThreads : byte;
                      PriorityClass : byte;
                      var ProcessInformation : TProcessInformation;
                      var LogReadHandle, LogWriteHandle : THandle) : boolean;

function ReadLogHeader(LogHandle, LinpackHandle, ReadComplete : THandle;
                       var stopcode : byte) : string;

function ReadLogString(LogHandle, LinpackHandle, ReadComplete : THandle;
                       var OutputString : string; var stopcode : byte) : boolean;

function ReadLogFooter(LogHandle, LinpackHandle, ReadComplete : THandle) : string;

function IsX64Supported : boolean;

function GetTempFolderPath : string;

function GetMaxThreadsNumber : byte;

function GetFreeMemory : word;

function GetTotalMemory: word;

procedure WindowScreenShot(WinHandle : HWND; Filename : string);

procedure WindowFlash(Flashtype : cardinal; WinHandle : HWND;
                      Count, Timeout : cardinal);

function GetCPUName : string;

function SizeToMem(Size: cardinal) : cardinal;

function MemToSize(Mem : cardinal) : cardinal;

function GetVersion (full : boolean) : string;

function CompositingEnabled: Boolean;

function AddDateTimeToFilename (Filename, Extension : string; TimeToAdd : TDateTime) : string;

procedure CalcMinMax(var data_arr: array of single; arrlength : integer; var min, max : real);

implementation
uses SysUtils, Graphics, PngImage, StrUtils;

type TMemoryStatusEx = packed record
       dwLength: DWORD;
       dwMemoryLoad: DWORD;
       ullTotalPhys: Int64;
       ullAvailPhys: Int64;
       ullTotalPageFile: Int64;
       ullAvailPageFile: Int64;
       ullTotalVirtual: Int64;
       ullAvailVirtual: Int64;
       ullAvailExtendedVirtual: Int64;
     end;

function GlobalMemoryStatusEx(var lpBuffer: TMemoryStatusEx): BOOL; stdcall; external kernel32;

procedure CreateInputFile(FileName : string;
                         ProblemSize, LeadingDimensions : cardinal;
                         NumberOfRuns : word;
                         DataAlignment : byte;
                         Version : string;
                         x64Mode : boolean);
var InputFile : HFile; BytesWritten : cardinal; SettingsString : ansistring;
    Mode : byte; InfoString : string;
const HeaderString = 'Sample Intel(R) LINPACK data file';
      InfoStr = 'Intel(R) LINPACK %d-bit data - ';
begin
  InfoString := InfoStr + version;
  InputFile := CreateFile(PChar(filename), GENERIC_WRITE, 0, nil, CREATE_ALWAYS,
                          0, 0);
  if InputFile <> INVALID_HANDLE_VALUE then begin
    if x64Mode then Mode := 64
    else Mode := 32;
    SettingsString := Ansistring(Format(HeaderString + #13#10 + InfoString + #13#10 +
                             '1'#13#10'%d'#13#10'%d'#13#10'%d'#13#10'%d',[Mode,
                             ProblemSize, LeadingDimensions, NumberOfRuns,
                             DataAlignment]));
    WriteFile(InputFile, Pointer(SettingsString)^, length(SettingsString),
              BytesWritten, nil);
    CloseHandle(InputFile);
  end;
end;

function SetOutputString(ProblemSize, LeadingDimensions : cardinal;
                          DataAlignment : byte) : string;
begin
  result := Format('%d'#13'%d'#13'%d'#13,
                   [ProblemSize, LeadingDimensions, DataAlignment]);
end;

function SetLeadingDimensions(ProblemSize : cardinal; Optimal : boolean) : cardinal;
var LeadingDimensions : cardinal;
begin
  LeadingDimensions := ProblemSize;
  if Optimal then
    if LeadingDimensions mod 8 = 0 then
      if LeadingDimensions mod 16 = 0 then inc(LeadingDimensions, 8)
      else
    else
      if odd(LeadingDimensions div 8)
        then LeadingDimensions := (LeadingDimensions div 8 + 2) * 8
      else LeadingDimensions := (LeadingDimensions div 8 + 1) * 8;
  result := LeadingDimensions;
end;

function StartLinpack(FileName : string; InputFileName : string;
                      NumberOfThreads : byte;
                      PriorityClass : byte;
                      var ProcessInformation : TProcessInformation;
                      var LogReadHandle, LogWriteHandle : THandle) : boolean;
var Startup : TStartupInfo; EnvVarString : ansistring;
    pSD : PSECURITY_DESCRIPTOR; SecAttr: TSecurityAttributes;
    Priority : cardinal; timesuffix : string;
begin
  pSD := PSECURITY_DESCRIPTOR(LocalAlloc(LPTR, SECURITY_DESCRIPTOR_MIN_LENGTH));
  InitializeSecurityDescriptor (pSD, SECURITY_DESCRIPTOR_REVISION);
  SetSecurityDescriptorDacl(pSD, false, nil, false);
  //FillChar(SecAttr, SizeOf(TSecurityAttributes), #0);
  SecAttr.nLength := SizeOf(TSecurityAttributes);
  SecAttr.bInheritHandle := True;
  SecAttr.lpSecurityDescriptor := pSD;

  timesuffix := FormatDateTime('hhmmss', Now);
  LogReadHandle := CreateNamedPipe(PChar('\\.\pipe\linx' + timesuffix), PIPE_ACCESS_INBOUND or
                              FILE_FLAG_OVERLAPPED, 0, 2, 1024, 1024, 0, @SecAttr);
  LogWriteHandle := CreateFile(Pchar('\\.\pipe\linx' + timesuffix), GENERIC_WRITE,
                          0, @SecAttr, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL
                          or FILE_FLAG_NO_BUFFERING or FILE_FLAG_WRITE_THROUGH,
                          0);

  FillChar(Startup, SizeOf(Startup), #0);
  Startup.cb          := SizeOf(Startup);
  Startup.dwFlags     := STARTF_USESTDHANDLES;
  Startup.hStdOutput  := LogWriteHandle;

  FillChar(ProcessInformation, SizeOf(ProcessInformation), #0);

  EnvVarString := Ansistring(
      Format('MKL_DOMAIN_NUM_THREADS=MKL_BLAS=1,MKL_ALL=%d', [NumberOfThreads]) + #0 +
      //'MKL_DOMAIN_NUM_THREADS=MKL_BLAS=1' + #0 +
      'MKL_DYNAMIC=FALSE' + #0 +
      //'MKL_NUM_THREADS=' + inttostr(NumberOfThreads) + #0 +
      Format('OMP_NUM_THREADS=%d', [NumberOfThreads]) + #0 + #0);

  //SetEnvironmentVariable(PChar('MKL_DYNAMIC'),PChar('FALSE'));
  //SetEnvironmentVariable(PChar('OMP_NUM_THREADS'),PChar(Format('%d',[NumberOfThreads])));
  //SetEnvironmentVariable(PChar('MKL_NUM_THREADS'),PChar(Format('%d',[NumberOfThreads])));
  //SetEnvironmentVariable(PChar('MKL_DOMAIN_NUM_THREADS'),PChar(Format('MKL_BLAS 1, MKL_ALL %d', [NumberOfThreads])));
  //SetEnvironmentVariable(PChar('MKL_DOMAIN_NUM_THREADS'),PChar('MKL_BLAS=1'));

  case PriorityClass of
    0 : Priority := IDLE_PRIORITY_CLASS;
    1 : Priority := $00004000;
    2 : Priority := NORMAL_PRIORITY_CLASS;
    3 : Priority := $00008000;
    4 : Priority := HIGH_PRIORITY_CLASS;
    5 : Priority := REALTIME_PRIORITY_CLASS;
    else Priority := NORMAL_PRIORITY_CLASS;
  end;
  if PriorityClass > 2 then SetPriorityClass(GetCurrentProcess, Priority)
  else SetPriorityClass(GetCurrentProcess, NORMAL_PRIORITY_CLASS);

  result := CreateProcess(nil, PChar(FileName + ' ' + InputFileName), @SecAttr,
                          @SecAttr, true, CREATE_NO_WINDOW or Priority, PAnsiChar(EnvVarString){nil}, nil, Startup,
                          ProcessInformation);
  LocalFree(HLOCAL(pSD));
end;

function ReadLogHeader(LogHandle, LinpackHandle, ReadComplete : THandle;
                       var stopcode : byte) : string;
const BufferSize = 1024;
var Buffer : PAnsiChar; BytesRead, TotalBytes, ExitCode : cardinal;
    tmpstr : string;
    norunspos : integer; normpos : integer;
begin
  Buffer := AllocMem(BufferSize + 1);
  TotalBytes := 0;
  BytesRead := 0;
  tmpstr := '';
  while (WaitForSingleObject(LinpackHandle, 0) <> WAIT_OBJECT_0) do begin
    ReadFile(LogHandle, Buffer[TotalBytes], 1, BytesRead, nil);
    inc(TotalBytes, BytesRead);
    tmpstr := string(Buffer);
    if TotalBytes >= BufferSize then begin
      Break;
    end;
    norunspos := pos('No runs', tmpstr);
    if (norunspos <> 0) and (PosEx(#10, tmpstr, norunspos) <> 0) then
      Break;
    normpos := pos('(norm)', tmpstr);
    if (normpos <> 0) and (PosEx(#10, tmpstr, normpos) <> 0) then
      Break;
  end;
  if WaitForSingleObject(LinpackHandle, 0) = WAIT_OBJECT_0 then begin
    GetExitCodeProcess(LinpackHandle, ExitCode);
    stopcode := ExitCode;
    if (stopcode <> 2) and (stopcode <> 6) then stopcode := 0;
  end
  else stopcode := 1;
  result := tmpstr;
  Freemem(Buffer);
end;

function ReadLogString(LogHandle, LinpackHandle, ReadComplete : THandle;
                       var OutputString : string; var stopcode : byte) : boolean;
const BufferSize = 81;
var Buffer : PAnsiChar; BytesRead, TotalBytes : cardinal;
    Overlap : TOverlapped;
    HandleArr : array[0..1] of THandle;
    ExitCode : cardinal;
begin
  result := true;
  Buffer  := AllocMem(BufferSize + 1);
  FillChar(Overlap, Sizeof(TOverlapped), #0);
  Overlap.hEvent := ReadComplete;
  HandleArr[0] := ReadComplete;
  HandleArr[1] := LinpackHandle;
  TotalBytes := 0;
  BytesRead := 0;
  OutputString := '';
  while pos(#10, OutputString) = 0 do begin
    if not ReadFile(LogHandle, Buffer[TotalBytes], 1, BytesRead, @Overlap) then begin
      if (GetLastError = ERROR_IO_PENDING) then begin
        if WaitForMultipleObjects(2, @HandleArr, false, INFINITE) <> WAIT_OBJECT_0 then begin
          CancelIO(LogHandle);
          GetExitCodeProcess(LinpackHandle, ExitCode);
          stopcode := ExitCode;
          result := false;
          Break;
        end
        else begin
          inc(TotalBytes, 1);
          OutputString := String(Buffer);
          if TotalBytes >= BufferSize then begin
            Break;
          end;
        end;
      end
      else begin
        stopcode := 1;
        CancelIO(LogHandle);
        Result := false;
        Break;
      end;
    end
    else begin
      inc(TotalBytes, BytesRead);
      OutputString := String(Buffer);
      if TotalBytes >= BufferSize then begin
        Break;
      end;
    end;
  end;
  FreeMem(Buffer);
end;

function ReadLogFooter(LogHandle, LinpackHandle, ReadComplete : THandle) : string;
const BufferSize = 1024;
var Buffer : PAnsiChar; BytesRead, TotalBytes : cardinal;
    Overlap : TOverlapped;
    HandleArr : array[0..1] of THandle;
begin
  Buffer  := AllocMem(BufferSize + 1);
  FillChar(Overlap, Sizeof(TOverlapped), #0);
  Overlap.hEvent := ReadComplete;
  HandleArr[0] := ReadComplete;
  HandleArr[1] := LinpackHandle;
  TotalBytes := 0;
  BytesRead := 0;
  result := '';
  while true do begin
    if not ReadFile(LogHandle, Buffer[TotalBytes], 1, BytesRead, @Overlap) then begin
      if (GetLastError = ERROR_IO_PENDING) then begin
        if WaitForMultipleObjects(2, @HandleArr, false, INFINITE) <> WAIT_OBJECT_0 then begin
          CancelIO(LogHandle);
          Break;
        end
        else begin
          inc(TotalBytes, 1);
          result := String(Buffer);
          if TotalBytes >= BufferSize then begin
            Break;
          end;
        end;
      end
      else begin
        CancelIO(LogHandle);
        Break;
      end;
    end
    else begin
      inc(TotalBytes, BytesRead);
      result := String(Buffer);
      if TotalBytes >= BufferSize then begin
        Break;
      end;
    end;
  end;
  FreeMem(Buffer);
end;

function IsX64Supported : boolean;
var IsWow64Process  : function(Handle: THandle; var Res: BOOL): BOOL; stdcall;
    IsWow64Result: BOOL;
begin
  result := false;
  IsWow64Process := GetProcAddress(GetModuleHandle('kernel32'), 'IsWow64Process');
  if Assigned(IsWow64Process) and IsWow64Process(GetCurrentProcess, IsWow64Result)
    then result := IsWow64Result;
end;

function GetTempFolderPath : string;
var lng: DWORD; thePath: string;
begin
  SetLength(thePath, MAX_PATH);
  lng := GetTempPath(MAX_PATH, PChar(thePath));
  SetLength(thePath, lng);
  result := thePath;
end;

function GetMaxThreadsNumber : byte;
begin
  result := strtointdef(GetEnvironmentVariable('NUMBER_OF_PROCESSORS'), 1);
end;

function GetFreeMemory : word;
var MemoryStatusEx : TMemorystatusEx;
begin
  MemoryStatusEx.dwLength := SizeOf(MemoryStatusEx);
  GlobalMemoryStatusEx(MemoryStatusEx);
  result := MemoryStatusEx.ullAvailPhys div 1048576;
end;

function GetTotalMemory: word;
var MemoryStatusEx : TMemorystatusEx;
begin
  MemoryStatusEx.dwLength := SizeOf(MemoryStatusEx);
  GlobalMemoryStatusEx(MemoryStatusEx);
  result := MemoryStatusEx.ullTotalPhys div 1048576;
end;

procedure WindowScreenShot(WinHandle : HWND; filename : string);
var DC : HDC; r : TRect; destBitmap : TBitmap; destPNG : TPNGImage;
begin
   dc := GetWindowDC(GetDesktopWindow);
   GetWindowRect(WinHandle,r) ;
   destBitmap := TBitmap.Create;
   destPNG := TPNGImage.Create;
   try
     destBitmap.Width := r.Right - r.Left;
     destBitmap.Height := r.Bottom - r.Top;
     BitBlt(destBitmap.Canvas.Handle, 0, 0, destBitmap.Width, destBitmap.Height,
            DC, r.Left, r.Top, SRCCOPY);
     destPNG.assign(destBitmap);
     destPNG.SaveToFile(filename);
   finally
     ReleaseDC(GetDesktopWindow, DC) ;
     destBitmap.FreeImage;
     Freeandnil(destBitmap);
     destPNG.Free;
   end;
end;

function GetCPUBrandString : string;
  function CPUIDAvail : boolean; assembler;
  {Tests whether the CPUID instruction is available}
  asm
    pushfd // get flags into ax
    pop eax // save a copy on the stack
    mov edx,eax
    xor eax, 0200000h // flip bit 21
    push eax // load new value into flags
    popfd // get them back
    pushfd
    pop eax
    xor eax,edx
    and eax, 0200000h // clear all but bit 21
    shr eax, 21
  end;

var s:array[0..48] of ansichar;
begin
  fillchar(s,sizeof(s),0);
  if CPUIDAvail then begin
    asm
      //save regs
      push ebx
      push ecx
      push edx
      //check if necessary extended CPUID calls are
      //supported, if not return null string
      mov eax,080000000h
      CPUID
      cmp eax,080000004h
      jb @@endbrandstr
      //get first name part
      mov eax,080000002h
      CPUID
      mov longword(s[0]),eax
      mov longword(s[4]),ebx
      mov longword(s[8]),ecx
      mov longword(s[12]),edx
      //get second name part
      mov eax,080000003h
      CPUID
      mov longword(s[16]),eax
      mov longword(s[20]),ebx
      mov longword(s[24]),ecx
      mov longword(s[28]),edx
      //get third name part
      mov eax,080000004h
      CPUID
      mov longword(s[32]),eax
      mov longword(s[36]),ebx
      mov longword(s[40]),ecx
      mov longword(s[44]),edx
    @@endbrandstr:
      //restore regs
      pop edx
      pop ecx
      pop ebx
    end;
    result:=string(s);
  end
  else result := '';
end;

function GetCPUName : string;
var s : string;
begin
  s := GetCPUBrandString;
  if s <> '' then begin
    s := stringreplace(s,'  ','',[rfReplaceAll]);
    s := stringreplace(s,'CPU','',[rfIgnoreCase]);
    s := stringreplace(s,'Processor','',[rfIgnoreCase]);
    s := stringreplace(s,'(R)','®',[rfReplaceAll,rfIgnoreCase]);
    s := stringreplace(s,'(TM)','™',[rfReplaceAll,rfIgnoreCase]);
    s := stringreplace(s,'  ',' ',[rfReplaceAll]);
    if pos('@',s) <> 0 then delete(s,pos('@',s),10);
    result := trimright(s);
  end
  else result := s;
end;

procedure WindowFlash(Flashtype : cardinal; WinHandle : HWND;
                      Count, Timeout : cardinal);
var
  FWinfo: TFlashWInfo;
begin
  FWinfo.cbSize := SizeOf(TFlashWInfo);
  FWinfo.hwnd := WinHandle; // Handle of Window to flash
  FWinfo.dwflags := Flashtype;//FLASHW_ALL;
  SystemParametersInfo(SPI_GETFOREGROUNDFLASHCOUNT, 0,
                       @FWinfo.uCount, 0); //number of times to flash (get from Windows)
  FWinfo.dwtimeout := Timeout; // speed in ms, 0 default blink cursor rate
  FlashWindowEx(FWinfo); // make it flash!
end;

function SizeToMem(Size: cardinal) : cardinal;
begin
  result := trunc(((size + 15 + 80) * (size + 2.5)) / 131072) + 2;
end;

function MemToSize(Mem : cardinal) : cardinal;
begin
  result := trunc(- 48.75 + sqrt(2376.5625 + (mem - 1) * 131072 - 59.375));
end;

function GetVersion (full : boolean) : string;
var VerInfoSize: DWORD;
    VerInfo: Pointer;
    VerValueSize: DWORD;
    VerValue: PVSFixedFileInfo;
    Dummy: DWORD;
begin
  VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), Dummy);
  GetMem(VerInfo, VerInfoSize);
  GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo);
  VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
  with VerValue^ do begin
    Result := Format('%d.%d.%d',[dwFileVersionMS shr 16,
                     dwFileVersionMS and $FFFF, dwFileVersionLS shr 16]);
    if full then Result := Result + Format('.%d',[dwFileVersionLS and $FFFF]);
  end;
  FreeMem(VerInfo, VerInfoSize);
end;

function CompositingEnabled: Boolean;
const
  dwmapi = 'dwmapi.dll';
  DwmIsCompositionEnabledSig = 'DwmIsCompositionEnabled';
var
  DLLHandle: THandle;
  DwmIsCompositionEnabledProc: function(pfEnabled: PBoolean): HRESULT; stdcall;
  Enabled: Boolean;
begin
  Result := False;
  if Win32MajorVersion >= 6 then
  begin
    DLLHandle := LoadLibrary(dwmapi);

    if DLLHandle <> 0 then
    begin
      @DwmIsCompositionEnabledProc := GetProcAddress(DLLHandle,
        DwmIsCompositionEnabledSig);

      if (@DwmIsCompositionEnabledProc <> nil) then
      begin
        DwmIsCompositionEnabledProc(@Enabled);
        Result := Enabled;
      end;

      FreeLibrary(DLLHandle);
    end;
  end;
end;

function AddDateTimeToFilename (Filename, Extension : string; TimeToAdd : TDateTime) : string;
var DS, TS : char;
begin
  DS := DateSeparator;
  TS := TimeSeparator;
  DateSeparator := '-';
  TimeSeparator := '-';
  result := Filename + FormatDateTime(' ddddd tt', TimeToAdd) + '.' + Extension;
  TimeSeparator := TS;
  DateSeparator := DS;
end;

procedure CalcMinMax(var data_arr: array of single; arrlength : integer; var min, max : real);
var i : integer; tmpmin, tmpmax : real;
begin
  tmpmin := 10000;
  tmpmax := -10000;
  for i := 0 to arrlength do begin
    if data_arr[i] < tmpmin then tmpmin := data_arr[i]
    else
      if data_arr[i] > tmpmax then tmpmax := data_arr[i];
  end;
  min := tmpmin;
  max := tmpmax;
end;

end.
