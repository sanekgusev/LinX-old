program LinX;



{$R *.dres}

uses
  Forms,
  UnitMain in 'UnitMain.pas' {FormMain},
  UnitGraph in 'UnitGraph.pas' {FormGraph},
  UnitSett in 'UnitSett.pas' {FormSett},
  UnitAbout in 'UnitAbout.pas' {FormAbout},
  UnitLogWatch in 'UnitLogWatch.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
