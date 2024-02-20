unit uFormSettings;

interface

uses
  uOBDII,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzTabs, ExtCtrls, RzPanel, StdCtrls, Mask, RzEdit, RzSpnEdt, Registry,
  IniFiles;

type
  TFormSettings = class(TForm)
    Panel1: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    btnApply: TButton;
    RzPageControl1: TRzPageControl;
    TabSheet1: TRzTabSheet;
    RzGroupBox1: TRzGroupBox;
    Label1: TLabel;
    cbPortList: TComboBox;
    RzGroupBox2: TRzGroupBox;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    cbBaudRate: TComboBox;
    edDelay: TRzSpinEdit;
    RzGroupBox6: TRzGroupBox;
    Label3: TLabel;
    Label11: TLabel;
    CbPortLC: TComboBox;
    CBLamda: TComboBox;
    RzGroupBox3: TRzGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RzINOP: TRzSpinEdit;
    RzINCL: TRzSpinEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    RzEXOP: TRzSpinEdit;
    RzEXCL: TRzSpinEdit;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SaveSetting;
    Procedure loadsetting;
   // procedure btnCheckConnectionClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure Label8Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSettings: TFormSettings;
  ObdII:TObdII;
implementation

uses
  main;

{$R *.dfm}


procedure TFormSettings.btnOKClick(Sender: TObject);
begin
SaveSetting;
MainForm.LoadSettings;
close;
end;



procedure TFormSettings.btnApplyClick(Sender: TObject);
begin
SaveSetting;
mainForm.LoadSettings;
btnApply.Enabled:=False;
end;

procedure TFormSettings.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFormSettings.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFormSettings.FormCreate(Sender: TObject);
var
  i: integer;
  Reg: TRegistry;
  ComList: TStringList;
//  por:string;
//  Han:Thandle;
begin
LoadSetting;
btnApply.Enabled:=True;
Reg:=TRegistry.Create;
  ComList := TStringList.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.OpenKeyReadOnly('HARDWARE\DEVICEMAP\SERIALCOMM');
    Reg.GetValueNames( ComList );
    for i := 0 to ComList.Count - 1 do begin
      cbPortList.Items.Add( Reg.ReadString( ComList[ i ] ) );
      CbPortLC.Items.Add(Reg.ReadString( ComList[ i ] ) );
    end;
    for i := -1 to ComList.Count - 1 do begin
   cbportlist.ItemIndex:=i;
   if cbportlist.text = FcomPort then begin
   break;
   end;
    end;
     for i := -1 to ComList.Count - 1 do begin
   CbPortLC.ItemIndex:=i;
   if CbPortLC.text = FComPortLC then begin
   break;
   end;
    end;

    if True then
  finally
    ComList.Free;
    Reg.Free;
  end;

end;
procedure TFormSettings.Label8Click(Sender: TObject);
begin

end;

//сохранение настроек порта
procedure Tformsettings.SaveSetting;
var
  FileName: string;
  Fport:string;
  FportLC:string;
  FBaudrate:Integer;
  FDelayRate:Integer;
  Lamsensor:string;
  Ini: TIniFile;
  BolWrite:boolean;
begin
  FileName := ExtractFilePath( Application.ExeName ) + 'Settings.ini';
  FPort := cbPortList.Text;
  FportLC := cbPortLC.Text;
  FBaudrate := StrToInt( cbBaudrate.Text );
  FDelayRate := StrToInt( edDelay.Text );
  Lamsensor:= CBlamda.Text;
  if RadioButton1.Checked then BolWrite:=True else BolWrite:=False;
  //создание обьекта
  Ini := TIniFile.Create( FileName );
  //запись данных в файл
  Ini.WriteString ( 'OBDII', 'Port',        FPort );
  Ini.WriteInteger( 'OBDII', 'BaudRate1nd', FBaudrate );
  Ini.WriteInteger( 'OBDII', 'BaudRate2nd', 10400 );
  Ini.WriteInteger( 'OBDII', 'DelayRate',   FDelayRate );
  Ini.WriteString ( 'LC_1',  'Port',        FportLC );
  Ini.WriteString ( 'LC_1',  'LamSensor',   Lamsensor);
 //связанно с фазой впрыска
  Ini.WriteInteger( 'Faza', 'Intake Open', RzINOP.IntValue );
  Ini.WriteInteger( 'FAZA', 'Intake Close', RzINCL.IntValue );

  Ini.WriteInteger( 'Faza', 'exhaust Open', RzEXOP.IntValue );
  Ini.WriteInteger( 'FAZA', 'exhaust Close', RzEXCL.IntValue );

  Ini.WriteBool   ( 'FAZA', 'Send open(0)/close(1)',   BolWrite );

  Ini.WriteInteger( 'educate', 'TWAT', MAINFORM.RzSpinEdit1.IntValue );
  Ini.WriteInteger( 'educate', 'TPS', MAINFORM.RzSpinEdit2.IntValue );
  Ini.WriteInteger( 'educate', 'SLEEP', MAINFORM.RzSpinEdit4.IntValue );
  Ini.WriteInteger( 'educate', 'COUNT', MAINFORM.RzSpinEdit7.IntValue );
  Ini.WriteInteger( 'educate', 'RT_PERCENT', MAINFORM.RzSpinEdit6.IntValue );
  Ini.WriteInteger( 'educate', 'TOCHNAYA', MAINFORM.RzSpinEdit5.IntValue );
 //удаление обьекта
  Ini.Free;
end;

procedure Tformsettings.LoadSetting;
var
  FileName: string;
 // FRM: TFormSettings;
  Ini: TIniFile;
  LamName:string;
begin
  FileName := ExtractFilePath( Application.ExeName ) + 'settings.ini';
  if not FileExists( FileName ) then begin
    Exit;
  end;
    Ini := TIniFile.Create( FileName );
    FcomPortLc := ini.ReadString('LC_1','Port','COM2');
    FComPort   := Ini.ReadString ('OBDII','Port','COM1');
    FBaudRate  := Ini.ReadInteger('OBDII','BaudRate1nd',10400);
    FDelayRate := Ini.ReadInteger('OBDII','DelayRate',200);
    LamName:=ini.ReadString('LC_1','LamSensor','LC/LM-1/2');
    Self.RzINOP.Value:=Ini.ReadInteger('Faza', 'Intake Open',0);
    Self.RzINCL.Value:=Ini.ReadInteger('Faza', 'Intake Close',0);
    Self.RzEXOP.Value:=Ini.ReadInteger('Faza', 'exhaust Open',0);
    Self.RzEXCL.Value:=Ini.ReadInteger('Faza', 'exhaust Close',0);

    if ini.ReadBool('FAZA', 'Send open(0)/close(1)',false) then  self.RadioButton1.Checked:=True else self.RadioButton2.Checked:=true;

    if LamName = 'LC/LM-1/2' then cblamda.ItemIndex:=0;
    if LamName = 'AEM' then cblamda.ItemIndex:=1;
    if LamName = 'VEMS' then cblamda.ItemIndex:=2;

    edDelay.Value:=FDelayRate;

    case FBaudRate of
     10400:begin
     cbBaudrate.ItemIndex:=0;
     end;
     38400:begin
     cbBaudrate.ItemIndex:=1;
     end;
     57600:begin
     cbBaudrate.ItemIndex:=2;
     end;
    end;
end;


end.
