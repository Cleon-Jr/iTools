program inforTools;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {main},
  uDM in 'uDM.pas' {DM: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tmain, main);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
