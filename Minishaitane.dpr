program Minishaitane;

uses
  Vcl.Forms,
  Main in 'Main.pas' {MainForm},
  uFirmware in 'uFirmware.pas',
  uOBDII in 'uOBDII.pas',
  uLC1 in 'uLC1.pas',
  uEducationThread in 'uEducationThread.pas',
  uFormSettings in 'uFormSettings.pas' {FormSettings};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TFormSettings, FormSettings);
  Application.Run;
end.
