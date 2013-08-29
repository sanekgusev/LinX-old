{$STRINGCHECKS OFF}
unit UnitGraph;

interface

uses
  Windows, {Messages,} SysUtils, {Variants,} Classes, Graphics, Controls, Forms,
  {Dialogs,} PNGImage, StdCtrls, Buttons;

type
  TFormGraph = class(TForm)
    EditMax: TEdit;
    EditMin: TEdit;
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormPaint(Sender: TObject);
    procedure EditMinChange(Sender: TObject);
    procedure EditMaxChange(Sender: TObject);
    procedure EditMaxKeyPress(Sender: TObject; var Key: Char);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure EditMaxExit(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    var min, max : real;
  public
    { Public declarations }
  end;

var
  FormTemps: TFormGraph;
  FormFans: TFormGraph;
  FormVcores: TFormGraph;
  FormP12Vs: TFormGraph;

implementation

uses UnitMain, LinX_routines;

{$R *.dfm}

procedure PaintGraph(buf : TFormGraph; font, grid, graph : TColor;
                     var data_arr : Dataarray; arrlength : integer;
                     gridx : integer; gridy : real;
                     var des_min, des_max : real;
                     var graph_capt, meas_unit : string);
const xoffset = 35; yoffset = 15; topoffset = 20; rightoffset = 5;
var i, w, h : word; dy, dx, min, max : real;
    time_st : string;
begin
//  if (data_arr <> nil) and (arrlength > 0) then begin
    w := buf.ClientWidth;
    h := buf.ClientHeight;
    {min := 100000;
    max := -128;}
    min := des_min;
    max := des_max;
    {for i := 0 to arrlength do begin
      if data_arr[i] < min then min := data_arr[i]
      else
        if data_arr[i] > max then max := data_arr[i];
    end;

    des_min := min;
    des_max := max;}

    while (arrlength div gridx) > 5 do begin
      gridx := gridx * 2;
      if gridx = 960 then gridx := 900;
    end;
    {if des_min < min then min := des_min
    else des_min := min;
    if des_max > max then max := des_max
    else des_max := max;}
    if ((max - min) / gridy) > 10 then gridy := (max - min) / 10;
    {if (max = min) then begin
      max := min + gridy;
      min := min - gridy;
    end;}

    dy := (h - yoffset - topoffset) / (max - min);
    dx := (w - xoffset - rightoffset) / arrlength;

    if buf.Canvas.Pen.Mode = pmNotXor then begin
      buf.Canvas.Brush.Color := clBlack;
      buf.Canvas.Brush.Style := bsClear;
      buf.Canvas.Font.Color := font;
      buf.Canvas.Font.Color := clGray;
      buf.Canvas.Pen.Color := grid xor $00FFFFFF;
    end
    else begin
      buf.Canvas.Pen.Color := grid;
      buf.Canvas.Font.Color := font;
    end;
    buf.Canvas.Pen.Style := psDot;

    for I := 0 to (arrlength div gridx) do begin
      buf.Canvas.MoveTo(round(i * dx * gridx) + xoffset, topoffset);
      buf.Canvas.LineTo(round(i * dx * gridx) + xoffset, h - yoffset);
      if i * gridx < 60 then time_st := inttostr(i * gridx) + str_s
      else
        if i * gridx < 3600 then time_st := floattostr(i * gridx / 60) + str_m
        else time_st := floattostr(i * gridx / 3600) + str_h;
      buf.Canvas.TextOut(round(i * dx * gridx) + xoffset, h - yoffset,
                         time_st);
    end;
    buf.Canvas.MoveTo(w - 1 - rightoffset, topoffset);
    buf.Canvas.LineTo(w - 1 - rightoffset, h - yoffset);

    for i := 0 to round((max - min) / gridy) do begin
      buf.Canvas.MoveTo(xoffset, h - round(i * dy * gridy) - 1 - yoffset);
      buf.Canvas.LineTo(w - rightoffset, h - round(i * dy * gridy) - 1 - yoffset);
      buf.Canvas.TextOut(5,
                         h - round(i * dy * gridy) - 1 - yoffset - buf.Canvas.Font.Size,
                         floattostrf(min + i * gridy, ffgeneral, 4,2));
    end;

    buf.Canvas.TextOut(xoffset, topoffset - 15, meas_unit);
    buf.Canvas.TextOut(xoffset + (w - xoffset - rightoffset) div 2
                       - length(graph_capt) * (buf.Canvas.Font.Size - 1) div 2, 0, graph_capt);

    if buf.Canvas.Pen.Mode = pmNotXor then begin
      buf.Canvas.Pen.Color := graph xor $00FFFFFF;
    end
    else buf.Canvas.Pen.Color := graph;
    buf.Canvas.Pen.Style := psSolid;
    buf.Canvas.MoveTo(xoffset,
                      round((- data_arr[0] + min) * dy) + h - yoffset - 1);
    for I := 1 to arrlength do
      buf.Canvas.LineTo(round(i * dx) + xoffset,
                        round((- data_arr[i] + min) * dy) + h - yoffset - 1);
//  end;
end;

procedure TFormGraph.EditMaxChange(Sender: TObject);
begin
  max := strtofloatdef(EditMax.Text, max);
  FormPaint(EditMax.Parent);
end;

procedure TFormGraph.EditMaxExit(Sender: TObject);
begin
  (Sender as TEdit).Hide;
end;

procedure TFormGraph.EditMaxKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then (Sender as TEdit).Hide;
end;

procedure TFormGraph.EditMinChange(Sender: TObject);
begin
  min := strtofloatdef(EditMin.Text, min);
  FormPaint(EditMax.Parent);
end;

procedure TFormGraph.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (Sender.Equals(FormTemps)) then begin
    GraphWindows[1].Left := FormTemps.Left;
    GraphWindows[1].Top := FormTemps.Top;
    GraphWindows[1].Right := FormTemps.Left + FormTemps.Width;
    GraphWindows[1].Bottom := FormTemps.Top + FormTemps.Height;
    FormTemps := nil;
  end
  else
    if (Sender.Equals(FormFans)) then begin
      GraphWindows[2].Left := FormFans.Left;
      GraphWindows[2].Top := FormFans.Top;
      GraphWindows[2].Right := FormFans.Left + FormFans.Width;
      GraphWindows[2].Bottom := FormFans.Top + FormFans.Height;
      FormFans := nil;
    end
    else
      if (Sender.Equals(FormVcores)) then begin
        GraphWindows[3].Left := FormVcores.Left;
        GraphWindows[3].Top := FormVcores.Top;
        GraphWindows[3].Right := FormVcores.Left + FormVcores.Width;
        GraphWindows[3].Bottom := FormVcores.Top + FormVcores.Height;
        FormVcores := nil;
      end
      else begin
        GraphWindows[4].Left := FormP12Vs.Left;
        GraphWindows[4].Top := FormP12Vs.Top;
        GraphWindows[4].Right := FormP12Vs.Left + FormP12Vs.Width;
        GraphWindows[4].Bottom := FormP12Vs.Top + FormP12Vs.Height;
        FormP12Vs := nil;
      end;
  Action := caFree;
end;

procedure TFormGraph.FormCreate(Sender: TObject);
begin
  if glass and (Win32MajorVersion >= 6) and CompositingEnabled then begin
    GlassFrame.Enabled := true;
    Canvas.Pen.Mode := pmNotXor;
  end;
end;

procedure TFormGraph.FormDblClick(Sender: TObject);
var png : TPNGImage; filename : string; buf : TBitmap;
begin
  png := TPNGImage.Create;
  buf := TBitmap.Create;
  buf.Width := (Sender as TFormGraph).ClientWidth;
  buf.Height := (Sender as TFormGraph).ClientHeight;
  BitBlt(buf.Canvas.Handle, 0, 0, buf.Width, buf.Height,
    (Sender as TFormGraph).Canvas.Handle, 0, 0, SRCCOPY);
  png.Assign(buf);
  if (Sender.Equals(FormTemps)) then filename := temps_file_name
  else
    if (Sender.Equals(FormFans)) then filename := fans_file_name
    else
      if (Sender.Equals(FormVcores)) then filename := vcores_file_name
      else filename := p12vs_file_name;
  if datetimeinnames then filename := AddDateTimeToFilename(filename, 'png', Now)
  else filename := filename + '.png';
  png.SaveToFile(filename);
  png.Free;
  buf.Free;
end;

procedure TFormGraph.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if not charinset(key, ['0'..'9',#8,#13,DecimalSeparator]) then key := #0;
end;

procedure TFormGraph.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (x > EditMax.Left) and (x < EditMax.Left + EditMax.Width)
    and (y > EditMax.Top) and (y < EditMax.Top + EditMax.Height) then begin
      EditMax.Text := floattostrf(max,ffgeneral,5,2);
      EditMax.Show;
      EditMax.SetFocus;
    end
  else
    if (x > EditMin.Left) and (x < EditMin.Left + EditMin.Width)
    and (y > EditMin.Top) and (y < EditMin.Top + EditMin.Height) then begin
      EditMin.Text := floattostrf(min,ffgeneral,5,2);
      EditMin.Show;
      EditMin.SetFocus;
    end;
end;

procedure TFormGraph.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if AlphaBlendValue >= 135
    then AlphaBlendValue := AlphaBlendValue - 10;
end;

procedure TFormGraph.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if AlphaBlendValue <= 245
    then AlphaBlendValue := AlphaBlendValue + 10;
end;

procedure TFormGraph.FormPaint(Sender: TObject);
var adjmin, adjmax : real; arrlen : integer;
begin
  Canvas.Brush.Style := bsClear;
  Canvas.FillRect(Rect(0, 0, ClientWidth, ClientHeight));
  if (Sender.Equals(FormTemps)) and (temps <> nil) and (run_time > 0) then begin
    arrlen := length(temps);
    if run_time < arrlen then arrlen := run_time;
    calcminmax(temps, arrlen, adjmin, adjmax);
    if (adjmin < min) or (min = 0) then min := trunc(adjmin / 5) * 5;
    if (adjmax > max) or (max = 0) then max := trunc(adjmax / 5 + 1) * 5;
    Paintgraph((Sender as TFormGraph), TangoGray6, TangoGray2, TangoRed3, temps, arrlen, 30, 1,
               min, max, str_temps_capt, str_celsius);
  end
  else
    if (Sender.Equals(FormFans)) and (fans <> nil) and (run_time > 0) then begin
      arrlen := length(fans);
      if run_time < arrlen then arrlen := run_time;
      calcminmax(fans, arrlen, adjmin, adjmax);
      if (adjmin < min) or (min = 0) then min := trunc(adjmin / 100) * 100;
      if (adjmax > max) or (max = 0) then max := trunc(adjmax / 100 + 1) * 100;
      Paintgraph((Sender as TFormGraph), TangoGray6, TangoGray2, TangoBlue3, fans, arrlen, 30, 10,
                 min, max, str_fans_capt, str_rpm);
    end
    else
      if (Sender.Equals(FormVcores)) and (vcores <> nil) and (run_time > 0) then begin
        arrlen := length(vcores);
        if run_time < arrlen then arrlen := run_time;
        calcminmax(vcores, arrlen, adjmin, adjmax);
        if (adjmin < min) or (min = 0) then min := trunc(adjmin*20) / 20;
        if (adjmax > max) or (max = 0) then max := trunc(adjmax*20 + 1) / 20;
        Paintgraph((Sender as TFormGraph), TangoGray6, TangoGray2, TangoGreen3, vcores, arrlen,
                   30, 0.01, min, max, str_vcores_capt, str_volts);
      end
      else
        if (Sender.Equals(FormP12Vs)) and (p12vs <> nil) and (run_time > 0) then begin
          arrlen := length(p12vs);
          if run_time < arrlen then arrlen := run_time;
          calcminmax(p12vs, arrlen, adjmin, adjmax);
          if (adjmin < min) or (min = 0) then min := trunc(adjmin*10) / 10;
          if (adjmax > max) or (max = 0) then max := trunc(adjmax*10 + 1) / 10;
          Paintgraph((Sender as TFormGraph), TangoGray6, TangoGray2, TangoYellow3, p12vs, arrlen, 30,
                     0.01, min, max, str_p12vs_capt, str_volts);
        end;
end;

procedure TFormGraph.FormResize(Sender: TObject);
begin
  Repaint;
end;

end.
