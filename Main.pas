unit Main;
//----ver 2.6
//  добавлено сглаживание БЦН и запись в ОЛТ
//  добавлено отображение связи с ЛС  - 1   lc1.LC_CONNECT
//-----ver 2.7
//--- добавлена тблица 32х16 по дросселю для дад j7es
//--- переработан алгоритм работы ЛC/LM-1/2
//--- добавлена таблица состава смеси
//--- исправлена возможный деффект ручной коррекции уоз с таблицей ПЦН на 32
//---ver 3.2
//--- переделан алгоритм настройки ПЦН
//--- исправлена ручная коррекция 2d таблиц
//---  ver 4.2
//-- исправлено переключение памяти после разрыва и установки связи.
//-- ver 6.0.5
//-- добавлен ввод дробных значений в олт
//-- ver 6.0.6
//-- Изменён пакет приёма ОЛТ J7ES (0D - запрос)
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils,System.UITypes, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, RzPanel, Vcl.Menus,
  RzStatus,uFirmware, Vcl.StdCtrls, Vcl.Grids, RzTabs,
  uOBDII,IniFiles,uEducationThread,uFormSettings,
  ulc1, Vcl.ImgList, Vcl.ComCtrls, RzPrgres, RzGrids, VCLTee.TeEngine,
  VCLTee.Series, VCLTee.TeeProcs, VCLTee.Chart, Vcl.Mask, RzEdit, RzSpnEdt,
  Vcl.Samples.Spin;


type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    Exit1: TMenuItem;
    Connect1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    SaveDialog1: TSaveDialog;
    PANEL_RPM: TPanel;
    PANEL_TPS: TPanel;
    PANEL_DAD: TPanel;
    panel_twat: TPanel;
    panel_tair: TPanel;
    panel_coeff: TPanel;
    panel_afr: TPanel;
    Panel_lc: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    ImageList1: TImageList;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    Panel_GBC: TPanel;
    Label9: TLabel;
    PopupMenuPCN: TPopupMenu;
    N7: TMenuItem;
    N11: TMenuItem;
    RzStatusBar1: TRzStatusBar;
    RzGlyphStatus1: TRzGlyphStatus;
    RzStatusPane1: TRzStatusPane;
    RzStatusPane3: TRzStatusPane;
    RzProgressBar1: TRzProgressBar;
    RzStatusPane4: TRzStatusPane;
    N8: TMenuItem;
    N9: TMenuItem;
    PopupMenuUOZ: TPopupMenu;
    N10: TMenuItem;
    N12: TMenuItem;
    PopupMenuBCN: TPopupMenu;
    N13: TMenuItem;
    RzStatusPaneLC: TRzStatusPane;
    ImageList2: TImageList;
    RPM1: TMenuItem;
    Load1: TMenuItem;
    RPM2: TMenuItem;
    Panel_inj: TPanel;
    Panel_UOZ: TPanel;
    Label21: TLabel;
    PopupMenu_OLT: TPopupMenu;
    N14: TMenuItem;
    N15: TMenuItem;
    Timer1: TTimer;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    AFR1: TMenuItem;
    ComboBox2: TComboBox;
    FAZA1: TMenuItem;
    Timer2: TTimer;
    ComboBox3: TComboBox;
    PopFaza: TPopupMenu;
    SaveCte: TMenuItem;
    N20: TMenuItem;
    PopupMenuCOEFF: TPopupMenu;
    N21: TMenuItem;
    PopupMenu2D: TPopupMenu;
    N22: TMenuItem;
    Timer3: TTimer;
    Timer4: TTimer;
    RzGlyphStatus2: TRzGlyphStatus;
    CTE1: TMenuItem;
    N23: TMenuItem;
    SGpcgen1: TMenuItem;
    PopupMenu1: TPopupMenu;
    PCN1: TMenuItem;
    CTE2: TMenuItem;
    RzPageControl1: TRzPageControl;
    TabSheet_BCN: TRzTabSheet;
    SG_BCN: TStringGrid;
    TabSheet_pcn: TRzTabSheet;
    SG_PCN: TStringGrid;
    Tabsheet_UOZ: TRzTabSheet;
    SG_UOZ: TRzStringGrid;
    TabSheet_AFR: TRzTabSheet;
    SG_AFR: TRzStringGrid;
    TabSheet_OLT: TRzTabSheet;
    TreeView1: TTreeView;
    Panel2: TPanel;
    SG_OLT: TStringGrid;
    Panel3: TPanel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    RzProgressBar2: TRzProgressBar;
    Label15: TLabel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Button1: TButton;
    Button2: TButton;
    RB1: TRadioButton;
    RB2: TRadioButton;
    RB3: TRadioButton;
    Panel_2D: TPanel;
    Chart1: TChart;
    Series1: TLineSeries;
    SG_2D: TStringGrid;
    Satting: TRzTabSheet;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    GroupBox2: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    Label19: TLabel;
    Label17: TLabel;
    Label20: TLabel;
    Label29: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label18: TLabel;
    RzSpinEdit1: TRzSpinEdit;
    RzSpinEdit2: TRzSpinEdit;
    RzSpinEdit3: TRzSpinEdit;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RzSpinEdit4: TRzSpinEdit;
    RzSpinEdit5: TRzSpinEdit;
    RzSpinEdit6: TRzSpinEdit;
    CheckBCN: TCheckBox;
    CheckPCN: TCheckBox;
    CheckFAZA: TCheckBox;
    RzSpinEdit7: TRzSpinEdit;
    RzSpinEdit8: TRzSpinEdit;
    RzSpinEdit9: TRzSpinEdit;
    RzSpinEdit10: TRzSpinEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Panel15: TPanel;
    Panel16: TPanel;
    Button14: TButton;
    Panel17: TPanel;
    RadioGroup1: TRadioGroup;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    Button16: TButton;
    Button17: TButton;
    CheckBox4: TCheckBox;
    GroupBox1: TGroupBox;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    RzSpinEdit11: TRzSpinEdit;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RzSpinEdit12: TRzSpinEdit;
    RzSpinEdit13: TRzSpinEdit;
    CheckBox2: TCheckBox;
    GroupBox3: TGroupBox;
    Label53: TLabel;
    Label54: TLabel;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    SpinEdit3: TSpinEdit;
    CheckBox8: TCheckBox;
    Panel18: TPanel;
    SpinButton1: TSpinButton;
    CheckBox9: TCheckBox;
    TabSheet1: TRzTabSheet;
    Label1: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label16: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    ComboBox1: TComboBox;
    Panel7: TPanel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button3: TButton;
    Panel8: TPanel;
    Chart2: TChart;
    Series2: TLineSeries;
    Chart3: TChart;
    Series3: TLineSeries;
    Series4: TLineSeries;
    Panel10: TPanel;
    SpinEdit1: TSpinEdit;
    Panel11: TPanel;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Faza: TRzTabSheet;
    SG_FAZA: TRzStringGrid;
    TabSheet2: TRzTabSheet;
    ComboBox4: TComboBox;
    Panel9: TPanel;
    TrackBar1: TTrackBar;
    Button4: TButton;
    Button5: TButton;
    CheckBox1: TCheckBox;
    ComboBox5: TComboBox;
    Button6: TButton;
    Button7: TButton;
    Chart4: TChart;
    LineSeries1: TLineSeries;
    Chart5: TChart;
    LineSeries2: TLineSeries;
    Chart6: TChart;
    LineSeries3: TLineSeries;
    TabSheet_coeff: TRzTabSheet;
    SG_COEFF: TRzStringGrid;
    TabSheet3: TRzTabSheet;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label30: TLabel;
    Label40: TLabel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    CheckBox3: TCheckBox;
    Memo1: TMemo;
    Edit11: TEdit;
    Edit12: TEdit;
    Button15: TButton;
    Edit13: TEdit;
    PCN_GEN: TRzTabSheet;
    sg_pc_gen: TRzStringGrid;
    TabSheet6: TRzTabSheet;
    Label52: TLabel;
    SG_hip_at: TStringGrid;
    RadioGroup2: TRadioGroup;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    RadioButton10: TRadioButton;
    CheckBox5: TCheckBox;
    SpinEdit2: TSpinEdit;
    TabSheet4: TRzTabSheet;
    sg_idle: TRzStringGrid;
    procedure Exit1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    function OpenFirmware:boolean;
    procedure LoadMapFirm;
    procedure FormResize(Sender: TObject);
    procedure SaveFirmware;
    function connectToEcu():boolean;//установка связи с эбу
    procedure disconnect;
    PROCEDURE CONNECTECU;
    procedure Save1Click(Sender: TObject);
    function LoadSettings():boolean;
    procedure ReloadDiagData;
    Procedure Reload_status(intake:integer; max:integer);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure SG_PCNDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure N6Click(Sender: TObject);
    procedure SG_PCNKeyPress(Sender: TObject; var Key: Char);
    procedure N3Click(Sender: TObject);
    procedure SG_UOZDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure SG_UOZKeyPress(Sender: TObject; var Key: Char);
    procedure N7Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure PopupMenuUOZChange(Sender: TObject; Source: TMenuItem;
      Rebuild: Boolean);
    procedure N10Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure SG_AFRKeyPress(Sender: TObject; var Key: Char);
    procedure Resizetab_OLT;
    procedure ResizeFo;
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure Chart1ClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure Chart1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Chart1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);

    procedure RzSpinEdit1Change(Sender: TObject);
    procedure RzSpinEdit2Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RPM1Click(Sender: TObject);
    procedure InterTable_X(table:Tstringgrid;addr:integer);
    procedure InterTable_Y(table:Tstringgrid;addr:integer);
    procedure RevratePcn_olt;
    procedure RevraiteUoz_olt;
    procedure SaveCTEtab(TABLE:TStringGrid;NAME:string;ID:String);
    procedure Load1Click(Sender: TObject);
    procedure RPM2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SG_AFRDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure Button2Click(Sender: TObject);
    procedure ReWraiTeOLT;
    procedure SG_OLTKeyPress(Sender: TObject; var Key: Char);
    procedure SG_OLTDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure N14Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure N16Click(Sender: TObject);
    procedure SG_BCNDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure N17Click(Sender: TObject);
    procedure N18Click(Sender: TObject);
    procedure N19Click(Sender: TObject);
    procedure AFR1Click(Sender: TObject);
    procedure FAZA1Click(Sender: TObject);
    Procedure GetOLTtoTAB(Table:Tstringgrid);
    procedure Timer2Timer(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SaveCteClick(Sender: TObject);
    procedure SG_FAZADrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);

    procedure TrackBar1Change(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure SG_2DKeyPress(Sender: TObject; var Key: Char);
    procedure N22Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure RzSpinEdit4Change(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
    procedure RzSpinEdit5Changing(Sender: TObject; NewValue: Extended;
      var AllowChange: Boolean);
    procedure RzSpinEdit6Changing(Sender: TObject; NewValue: Extended;
      var AllowChange: Boolean);
    procedure CheckBCNClick(Sender: TObject);
    procedure CheckPCNClick(Sender: TObject);
    procedure CheckFAZAClick(Sender: TObject);
    procedure CTE1Click(Sender: TObject);
    procedure RzSpinEdit7Change(Sender: TObject);
    PROCEDURE SAVESET;
    procedure RzSpinEdit5Change(Sender: TObject);
    procedure RzSpinEdit1ButtonClick(Sender: TObject; Button: TSpinButtonType);
    procedure Button14Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure N23Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure RzSpinEdit9Change(Sender: TObject);
    procedure RzSpinEdit9Changing(Sender: TObject; NewValue: Extended;
      var AllowChange: Boolean);
    procedure SG_hip_atKeyPress(Sender: TObject; var Key: Char);
    procedure SG_hip_atDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure RzSpinEdit11Change(Sender: TObject);
    procedure RzSpinEdit12Change(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SpinButton1UpClick(Sender: TObject);
    procedure SpinButton1DownClick(Sender: TObject);
    procedure SGpcgen1Click(Sender: TObject);
    procedure PCN1Click(Sender: TObject);
    procedure CTE2Click(Sender: TObject);

   // procedure Button1Click(Sender: TObject);
  private
   // LoadFirmware:boolean;//флаг загруженной прошивки
    FOBDIIConnected:boolean;//флаг установленной связи с ЕСМ

  public
    { Public declarations }
    type_razdelitel_error:string;//разделитель дробной части, чтоб небыло ошибок
    type_razdelitel_ok:string;//разделитель дробной части, чтоб небыло ошибок
    LoadFirmware:boolean;//флаг загруженной прошивки
    MapName:string;//имя карты
    data_map: array of byte;
    SaveDialogDir:string;
    Naklo,smeshen:real;
    //загруска настроек фазы впрыска
    Intake_Open,Intake_close,exhaust_open,exhaust_close:integer;//угол открытия и угол закрытия клапана
    InjWrite:boolean;//впрыскивать в открытый или в закрытый клапан
    procedure Reload_IO;

  end;
  type
  hip_data = record
  hip_adc: array  of real; //ацп с дд
  increment_data : integer;//шаг изменения точки усилителя
  old_perehod:boolean;  //прошлое состояние ацп, выход за пределы.
  value_attenuator:integer;//номер точки усилителя хип
  cout_popad:byte;//количество попаданий в точку
  count_popad_norm:byte;//количество попаданий с нормальным ацп
  end;
   type
   Education_RT = record
    RPM_RT,LOAD_RT:integer;
   end;
   type
   tayble_2D = record
    ID:string;//ID калибровки
    value_index : Word;//номер точки, начинается от 0(количетсво точек на оси)
    value_count : Word;// количество точек на оси х
    edit_data : boolean;//разрешение тянуть точку
    Value_Y:double;//значение по оси У
    //---------------------------------
    type_calib:byte;//тип тарировки
    data_val:double;  //значение точки
    addr:word;       //адрес калибровки
    delitel :double;  // Делитель для шага
    sum :double;      // смещение ...
    OBR_MUL :double;  //обратный мультипликативный
    mnozitel:double;  // Шаг...
    sum_data:double;  // смещение ...
    MASK:BYTE; //МАСКА ДЛЯ ФЛГОВ 3Д ТАБЛИЦ
    //--------------------------------------------
    Table_dad,Table_Tps,Table_BCN:boolean;//флаг таблицы по дроселю, давлению для отображению РТ
    Load_Count,RPM_COUNT:integer;
   end;

var
  MainForm: TMainForm;//главная форма
  Firmware : TFirmware;//модуль прошивки
  OBDII:TobdII;//модуль связи
  LC1 : TLcThreat;//модуль связи с шдк
  series_data : Tayble_2D;
  hip_ : array [1..256] of hip_data;//данные по ацп
  hip_adc_series_table:array [0..31] of real;//ацп с дд для отображения графика
  //educat_data : Education_data;//данные стационарности
  PCN_RT,BCN_RT,UOZ_RT:Education_RT;//режимная точка у каждой таблицы
  EducationThread : TEducationThread;
    //port connect
    FComPort: String;//порт соединения с эбу
   FBaudRate: integer;//скорость 1
   FbaudRate2:integer;//скорость 2
   FDelayRate: integer;
    FComPortLC: string;//порт шдк
    LamSensor:  string;//тип шдк
   // MAX_PCN,MIN_PCN,AVG_PCN:real;//значения поправокдля закраски таблиц
    FstartPower:boolean;//флаг что нужно мерять заезд
    Fpower:boolean;//флаг что первый этап оборотов пройден(начало разгона)
    PowerValue:integer;//время заезда
    MIN_RPM_VAL:integer;//начало оборотов разгона
    MAX_RPM_VAL:integer;//конец оборотов разгона
    RPM_OLD:integer;//обороты для прошлого цикла
    //InTime:double; //время для расчёта разгона
    InTimeOLD:double;
    SP1,SP2,SP3,SP4,SP5,SP6:Real;//Отношение передачи
    TTimeZavis:integer;
    TTimeZavis_OBD:integer;
implementation

{$R *.dfm}





procedure TMainForm.Exit1Click(Sender: TObject);
var
ValMessage:cardinal;
begin
if LoadFirmware then begin
  // Отображение диалога с подтверждением
  ValMessage := MessageDlg('Сохранить прошивку?',mtConfirmation, mbYesNoCancel , 0);
  // обработка выбора на кнопке
  if ValMessage = mrYes then begin
   SaveFirmware;
  end;
  if ValMessage = mrCancel then exit;
end;
disconnect;
Application.Terminate;
end;
procedure TMainForm.FAZA1Click(Sender: TObject);
begin
faza_data.Addr:=series_data.addr;
faza_data.dad:=series_data.Table_dad;
faza_data.load_count:=series_data.Load_Count;
faza_data.TPS:=series_data.Table_Tps;
faza_data.RPM_count:=series_data.RPM_COUNT;
faza_data.BCN:=series_data.Table_BCN;
faza_data.Сount:=faza_data.load_count*faza_data.RPM_count - 1;
faza_data.mnozitel:=round(series_data.mnozitel);
//firmware.GetTable(SG_FAZA,faza_data.Addr,1,faza_data.mnozitel,faza_data.Сount,0);
GetOLTtoTAB(SG_FAZA);
end;
procedure Tmainform.GetOLTtoTAB(Table: TStringGrid);
var
i,t,s:integer;
begin
s:=0;
for i := 1 to sg_olt.ColCount - 1 do
  for t := 1 to sg_olt.RowCount - 1 do begin
  Table.Cells[i,t]:=FloatToStr(firmware.ReadvalueData_1D(series_data.type_calib,series_data.addr+s,series_data.OBR_MUL,
  series_data.delitel,series_data.mnozitel,series_data.sum,series_data.sum_data));
  inc(s,1);
  if S <= Table.ColCount  then begin
    if sg_olt.ColCount = 17 then Table.Cells[s,0]:=IntToStr(firmware.FRPMAxis[s]);
    if Table.ColCount = 33 then Table.Cells[s,0]:=IntToStr(firmware.FRPMAxis_32[s]);
  end;
 if S <= table.RowCount then
 Table.Cells[0,s]:=SG_OLT.Cells[0,s];
  end;
end;
procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
exit1.Click;
end;


procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if key = ' 'then begin
  if FOBDIIConnected then  begin
    if not obdii.Flag_indicator = 1  then
     obdii.Flag_indicator := 1;
  end;
 end;
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
resizefo;
end;

procedure TMainForm.Open1Click(Sender: TObject);
var
a:real;
s:string;
begin
try
 a:=StrToFloat('0.5');
 s:='.';
 self.type_razdelitel_error:=',';
 self.type_razdelitel_ok:='.';
except
 a:=StrToFloat('0,5');
 s:=',';
 self.type_razdelitel_error:='.';
 self.type_razdelitel_ok:=',';
end;
memo1.Lines.Add(s) ;
if not openfirmware then exit;
memo1.Lines.Add('Открываем прошивку...');
LoadSettings; //загружаем настройки
memo1.Lines.Add('Загружаем файл настроек....');
 if firmware.FdadNaklon = 0  then begin
    firmware.FdadNaklon:=Naklo;
    memo1.Lines.Add('Данные ДАД взяты из файла настроек, проверьте достоверность наклона и смещения!!!');
    showmessage('Проверьте данные ДАД в файле настроек!');
 end else begin
   memo1.Lines.Add('Данные ДАД взяты из прошивки!!!');
 end;
 if firmware.FdadSMeshenie = 0 then begin
   firmware.FdadSMeshenie:=smeshen;
 end;
 mainform.Resize;
 if MapName='ERROR' then begin
 memo1.Lines.Add('Не удалось найти карту прошивки!!!');
  exit;
 end;
 LoadMapFirm;  //загрузка карты
  memo1.Lines.Add('Карта прошивки успешно загружена...');
end;
//открытие прошивки
function TMainForm.openfirmware:boolean;
var
i:integer;
begin
if LoadFirmware then begin
if MessageDlg('Все не сохраненные данные будут потеряны, продолжить?',mtConfirmation, [mbYes, mbNo], 0)
= mrNo then  exit;
end;

LoadFirmware:=False;
SaveDialogDir:='';
OpenDialog1 := TOpenDialog.Create(self);
OpenDialog1.Filter := 'bin|*.bin|bir|*.bir';
OpenDialog1.FilterIndex:=1;
Opendialog1.InitialDir:=ExtractFilePath( Application.ExeName );
 if not opendialog1.Execute then begin
 result:=False;
   exit;
 end;
 result:=True;
firmware:=Tfirmware.Create;//создание обьекта firmware
firmware.MIN_PCN:=1000;
firmware.MAX_PCN:=0;
 if not Firmware.LoadFirmware( opendialog1.FileName ) then BEGIN//вызов функции загрузки прошивки
     self.RzStatusPane3.Caption:='SWID: '+firmware.ReadSwidFirmware;
     LoadFirmware:=True;

     if FOBDIIConnected then begin
      setlength(obdii.TableFirmwareOlt,length(firmware.FFirmwareWriteOlt));
       for i := 0 to length(firmware.FFirmwareWriteOlt) - 1 do
        obdii.TableFirmwareOlt[i] := firmware.FFirmwareWriteOlt[i];
      obdii.FlagWriteFirmware := true;
    end;
     firmware.FdadSMeshenie:=smeshen;
     firmware.FdadNaklon:=Naklo;
     hip_at.Addr:=$96FB;
      for i := 1 to 256 do begin
      hip_[i].value_attenuator:= firmware.FFirmwareData[$96FB+i-1];
      hip_[i].increment_data:=5;
      hip_[i].old_perehod:=false;
       sg_hip_at.Cells[i,0]:=floattostr(30*(i-1));
       sg_hip_at.Cells[i,1]:=inttostr(firmware.FFirmwareData[$96FB+i-1]);
     end;
    Exit;
  END else begin
     MainForm.Caption:='MSH_v6.3.1'+'    '+opendialog1.FileName; //меняем название главной формы(чтоб знать что загрузили)
     SaveDialogDir:=ExtractFileDir(opendialog1.FileName);
     opendialog1.Free;
    end;
    LoadFirmware:=True;
//вешаем флаг на запись прошивки в олт
    if FOBDIIConnected then begin
      setlength(obdii.TableFirmwareOlt,length(firmware.FFirmwareWriteOlt));
      for i := 0 to length(firmware.FFirmwareWriteOlt) - 1 do
      obdii.TableFirmwareOlt[i] := firmware.FFirmwareWriteOlt[i];
      obdii.FlagWriteFirmware := true;
    end;

 if obdii.RunThread then begin
  obdii.DIAG_DATA:=firmware.ReadSwidFirmware;
    if obdii.DIAG_DATA = 'D107'  then obdii.DIAG_DATA:='FB9C';
    if obdii.DIAG_DATA = 'D20F'  then obdii.DIAG_DATA:='FB9C';
    if obdii.DIAG_DATA = 'F6FC'  then obdii.DIAG_DATA:='FB9C';
    if obdii.DIAG_DATA = '1C2E'  then obdii.DIAG_DATA:='FB9C';
    if obdii.DIAG_DATA = '1C2F'  then obdii.DIAG_DATA:='FB9C';
    if obdii.DIAG_DATA = '28A7'  then obdii.DIAG_DATA:='FB9C';
    if obdii.DIAG_DATA = '28B8'  then obdii.DIAG_DATA:='FB9C';
 end;
 self.RzStatusPane3.Caption:='SWID: '+firmware.ReadSwidFirmware;
// tabsheet_bcn.Height:=RzPageControl1.Height;
// tabsheet_bcn.Width:=RzPageControl1.Width;
// разметка таблицы бцн pcn
SG_BCN.ColCount:=BCN_DATA.RPM_count+1;
SG_BCN.RowCount:=BCN_DATA.load_count+1;
SG_PCN.ColCount:=PCN_DATA.RPM_count+1;
SG_PCN.RowCount:=PCN_DATA.load_count+1;
SG_COEFF.ColCount:=PCN_DATA.RPM_count+1;
SG_COEFF.RowCount:=PCN_DATA.load_count+1;
SG_UOZ.ColCount:=UOZ_DATA.RPM_count+1;
SG_UOZ.RowCount:=uoz_data.load_count+1;
SG_AFR.ColCount:=afr_data.RPM_count+1;
SG_AFR.RowCount:=afr_data.load_count+1;
//
hip_at.Addr:=$96FB;
      for i := 1 to 256 do begin
       sg_hip_at.Cells[i,0]:=floattostr(30*(i-1));
       sg_hip_at.Cells[i,1]:=inttostr(firmware.FFirmwareData[$96FB+i-1]);
       hip_[i].value_attenuator:=firmware.FFirmwareData[$96FB+i-1];
     end;
sg_idle.Cells[0,0]:='RPM';
sg_idle.Cells[0,1]:='FIRM РХХ';
sg_idle.Cells[0,2]:='IDLE РХХ';

for I := 1 to 32 do begin
 sg_idle.Cells[i,0]:=inttostr(firmware.FRPMAxis_32[i]);
 sg_idle.Cells[i,1]:=inttostr(firmware.FFirmwareData[$9E5C+i-1]);
end;
//загрузка в таблицу
 firmware.GetTable(SG_BCN,bcn_data.Addr,3,bcn_data.mnozitel,bcn_data.Сount,0);
 firmware.GetTable(SG_PCN,pcn_data.Addr,128,1,pcn_DATA.Сount,0);
 firmware.GetTable(SG_UOZ,uoz_data.Addr,2,1,uoz_data.Сount,0);
 firmware.GetTable(SG_AFR,afr_data.Addr,256,14.7,afr_data.Сount,128);
 firmware.GetTable(SG_faza,faza_data.Addr,1,faza_data.mnozitel,faza_data.Сount,0);

 //оси на 16
 for I := 1 to 16 do begin
  if bcn_data.RPM_count = 16 then sg_bcn.Cells[i,0]:=IntToStr(firmware.FRPMAxis[i]);
  if bcn_data.load_count = 16 then  begin
   if BCN_DATA.dad then sg_bcn.Cells[0,i]:=IntToStr(firmware.FDADAxis[i]);
   if bcn_data.TPS then sg_bcn.Cells[0,i]:=IntToStr(firmware.FThrottleAxis[i]);
  end;
  if pcn_data.RPM_count = 16 then begin
   sg_pcn.Cells[i,0]:=IntToStr(firmware.FRPMAxis[i]);
   sg_coeff.Cells[i,0]:=IntToStr(firmware.FRPMAxis[i]);
  end;

  if pcn_data.load_count = 16 then begin
   if pcn_DATA.dad then begin
    sg_pcn.Cells[0,i]:=IntToStr(firmware.FDADAxis[i]);
    sg_coeff.Cells[0,i]:=IntToStr(firmware.FDADAxis[i]);
   end;
   if pcn_data.TPS then begin
    sg_pcn.Cells[0,i]:=IntToStr(firmware.FThrottleAxis[i]);
    sg_coeff.Cells[0,i]:=IntToStr(firmware.FThrottleAxis[i]);
   end;
  end;

  if uoz_data.RPM_count = 16 then  sg_uoz.Cells[i,0]:=IntToStr(firmware.FRPMAxis[i]);
  if uoz_data.load_count = 16 then begin
    if uoz_data.dad then  sg_uoz.Cells[0,i]:=IntToStr(firmware.FDADAxis[i]);
    if uoz_data.TPS then sg_uoz.Cells[0,i]:=IntToStr(firmware.FThrottleAxis[i]);
    if uoz_data.BCN then sg_uoz.Cells[0,i]:=IntToStr(firmware.FBCNAxis[i]);
  end;
  if afr_data.RPM_count = 16 then sg_afr.Cells[i,0]:=IntToStr(firmware.FRPMAxis[i]);
  if afr_data.load_count = 16 then begin
    if afr_data.dad then sg_afr.Cells[0,i]:=IntToStr(firmware.FDADAxis[i]);
    if afr_data.TPS then sg_afr.Cells[0,i]:=IntToStr(firmware.FThrottleAxis[i]);
    if afr_data.BCN then sg_afr.Cells[0,i]:=IntToStr(firmware.FBCNAxis[i]);
  end;
 end;
 //оси на 32
  for I := 1 to 32 do begin
  if bcn_data.RPM_count = 32 then sg_bcn.Cells[i,0]:=IntToStr(firmware.FRPMAxis_32[i]);
  if bcn_data.load_count = 32 then  begin
   if BCN_DATA.dad then sg_bcn.Cells[0,i]:=IntToStr(firmware.FDADAxis_32[i]);
   if bcn_data.TPS then sg_bcn.Cells[0,i]:=IntToStr(firmware.FThrottleAxis_32[i]);
  end;
  if pcn_data.RPM_count = 32 then begin
  sg_pcn.Cells[i,0]:=IntToStr(firmware.FRPMAxis_32[i]);
  sg_coeff.Cells[i,0]:=IntToStr(firmware.FRPMAxis_32[i]);
  end;
  if pcn_data.load_count = 32 then begin
   if pcn_DATA.dad then begin
    sg_pcn.Cells[0,i]:=IntToStr(firmware.FDADAxis_32[i]);
    sg_coeff.Cells[0,i]:=IntToStr(firmware.FDADAxis_32[i]);
   end;
   if pcn_data.TPS then begin
    sg_pcn.Cells[0,i]:=IntToStr(firmware.FThrottleAxis_32[i]);
    sg_coeff.Cells[0,i]:=IntToStr(firmware.FThrottleAxis_32[i]);
   end;
  end;
  if uoz_data.RPM_count = 32 then sg_uoz.Cells[i,0]:=IntToStr(firmware.FRPMAxis_32[i]);
  if uoz_data.load_count = 32 then begin
   if uoz_DATA.dad then sg_uoz.Cells[0,i]:=IntToStr(firmware.FDADAxis_32[i]);
   if uoz_data.TPS then sg_uoz.Cells[0,i]:=IntToStr(firmware.FThrottleAxis_32[i]);
  end;
 end;

end;

function FileToBufRead(name_file:string):boolean;
var
n: integer;
SizeFile:integer;
InFile:file of byte;
begin
name_file:=ExtractFilePath(Application.ExeName)+name_file;
if not FileExists(name_file) then begin
showmessage('Карта не найдена');
 exit(false);
end;

 AssignFile(InFile, name_file);
 Reset(InFile);
 SizeFile := FileSize(InFile);
 SetLength (Mainform.data_map, SizeFile);
 for n := 0 to SizeFile - 1 do
  begin
   Read (InFile, Mainform.data_map[n]);
  end;
 CloseFile(InFile);
 FileToBufRead:=true;
end;
//конвертирование символов на русский
function cp1252tocp1251(s : string) : string;
var i,p : integer;
const
cp1252 = 'àáâãäå¸æçèéêëìíîïðñòóôõö÷øùúûüýþÿÀÁÂÃÄÅ¨ÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞß';
cp1251 = 'абвгдеёжзийклмнопрстуфхцчшщъыьэюяАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ';
begin
  for i := 1 to length(s) do begin
    p := pos(s[i],cp1252);
    if p <> 0 then
      s[i] := cp1251[p];
  end;
  result := s;
end;
//*******разбор карты постройка дерева

procedure Read_C3 (Adr_Sel: Integer);
var
Dl_bl, n, ntr: integer;
fl_type: byte;
//S_f,
S_z,S_Tr: string;
SizeFile:integer;

//temp_sm:byte;
  Paren : array[0..50] of TTreeNode;
  AParent,node  : TTreeNode;
begin
mainform.TreeView1.Items.Clear;
 //temp_sm:=$00;
 SizeFile:=length(mainform.data_map);
  fl_type:= $FF;
  Dl_bl := $16;
  S_z:='';
  //пока выполняется условие работает цикл
  while Dl_bl < SizeFile - 2 do
    begin
     //****Dl_bl - это адрес начала названия
//************************* создаём директорию *****************************************
     if fl_type = $FF then
      begin
      //определяем тип тарировки
       fl_type := mainform.data_map[Dl_bl+$42];
       S_Tr:='';
        for n := Dl_bl+1 to Dl_bl+mainform.data_map[Dl_bl] do
         S_Tr:=S_Tr + chr(mainform.data_map[n]);
         s_z:=cp1252tocp1251(S_Tr);
       ntr := mainform.data_map[Dl_bl+$41];//определяем уровень(глубину) директории
       //****************************
       with mainform.TreeView1.Items do                        //  строим дерево...
        begin
        // ntr := t48;
         //ntr - level dir
         AParent := Paren[ntr-1];
         node:=AddChildObject( AParent, cp1252tocp1251(S_Tr), Pointer(Dl_bl));
        // form1.Listbox1.items.Add(cp1252tocp1251(S_Tr));
         AParent := node;
         Paren[ntr] := AParent;
         node.ImageIndex := fl_type+1;
         if Adr_Sel = Dl_bl then mainform.TreeView1.Select(node);
        end;

      inc(Dl_bl,$43);//устанавливаем адрес нового названия тарировки
      end;
//*************************** и здесь создаём директорию ***********************************
     if ((fl_type = 0) and (Dl_bl < SizeFile - $45)) then                                                      // директория...
      begin
       S_Tr:='';
       for n := Dl_bl+3 to Dl_bl+2+mainform.data_map[Dl_bl+2] do
       S_Tr:=S_Tr + chr(mainform.data_map[n]);
       fl_type := mainform.data_map[Dl_bl+$44];
       ntr := mainform.data_map[Dl_bl+$43];
       //**********
       with mainform.TreeView1.Items do                        //  строим дерево...
        begin
         AParent := Paren[ntr-1];
         node:=AddChildObject( AParent, cp1252tocp1251(S_Tr), Pointer(Dl_bl+2));
         AParent := node; Paren[ntr] := AParent;
         node.ImageIndex := fl_type+1;
         if Adr_Sel = Dl_bl+2 then mainform.TreeView1.Select(node);
        end;

      // mainform.Memo1.Lines.Add(S_z+cp1252tocp1251(S_Tr)+'  //уровень '+inttostr(ntr)+adres);
       //*********
       inc(Dl_bl,$45);
       {
       if ntr = 1 then S_z:='';
       if ntr = 2 then S_z:='    ';
       if ntr = 3 then S_z:='         ';
       mainform.Memo1.Lines.Add(S_z + cp1252tocp1251(S_Tr)+'  //уровень '+inttostr(ntr));
       }
      end;
//**************************** проверяем тип тарировки ******************************************
     if (fl_type = 1) then                                                      // график '2D'
      begin
       inc(Dl_bl, $1AE + 2);
       fl_type:= $FF; //inc(gr_2d,1);
      end;
//******************************************************************************
     if (fl_type = 2) then                                                      // график '3D'
      begin
       inc(Dl_bl, $2E2 + 2);
       fl_type:= $FF; //inc(gr_3d,1);
      end;
//******************************************************************************
     if (fl_type = 3) then                                                      // график '1D'
      begin
       inc(Dl_bl, $65 + 2 );
       fl_type:= $FF; //inc(gr_1d,1);
      end;

//******************************************************************************
     if (fl_type = 4) then                                                      // битовые флаги...
      begin
       inc(Dl_bl,$1286+2);
       fl_type:= $FF;
      end;

//******************************************************************************
     if (fl_type = 5) then                                                      // калибровки...
      begin
       inc(Dl_bl,$28F + 2);
       fl_type:= $FF;
      end;

//******************************************************************************

    end;
end;
//************ для расшифровки адреса калибровки
Function D_Word(Addr: integer; Xor_: boolean):dword;
var
 ww: dword;
 begin
   ww := mainform.data_map[Addr+3];
   ww := ww shl 8;
   ww := ww or mainform.data_map[Addr+2];
   ww := ww shl 8;
   ww := ww or mainform.data_map[Addr+1];
   ww := ww shl 8;
   ww := ww or mainform.data_map[Addr];
   if Xor_ = true then begin
    D_Word := ww xor $28A6FBB8;
   end
   else D_Word := ww;

 end;
 //***********
 Function D_Double(Addr: integer):double;
var
 n: integer;
 b:  PByteArray;
 ww:  double;
 begin
   b := @ww;
   for n:=0 to 7 do b[n]:=mainform.data_map[Addr+n];
   D_Double := ww;
 end;

procedure TMainForm.Load1Click(Sender: TObject);
var
Le,Ri,Topi,butti,i,t:integer;
RT,RT_1,RT_2:integer;
mnoz:real;
da_1,da_2,da:byte;
begin
Le:=sg_pcn.Selection.Left;
Ri:=sg_pcn.Selection.Right;
Topi:=sg_pcn.Selection.Top;
butti:=sg_pcn.Selection.Bottom;
//Le_top:=sg_pcn.Selection.TopLeft.X;
//ri_but:=sg_pcn.Selection.BottomRight;
for i := le to ri  do
 for t := topi to butti  do begin
 mnoz:=(t-topi)/(butti-topi);
 RT:=(t-1)*pcn_data.RPM_count+i-1;
 RT_1:=(topi-1)*pcn_data.RPM_count+i-1;
 RT_2:=(butti-1)*pcn_data.RPM_count+i-1;
 da_1:=firmware.FFirmwareData[pcn_data.Addr+RT_1];
 da_2:=firmware.FFirmwareData[pcn_data.Addr+RT_2];
 DA:=round(da_1+(DA_2-DA_1)*mnoz);
 firmware.FFirmwareData[pcn_data.Addr+rt]:=da;
 firmware.GetTable(SG_PCN,PCN_DATA.Addr,pcn_data.delitel,pcn_data.mnozitel,pcn_data.Сount,pcn_data.sum);
end;
RevratePcn_olt;
end;
procedure TMainForm.LoadMapFirm;
begin
if not FileToBufRead(MapName) then exit;
Read_C3(0);
tabsheet_olt.TabVisible:=true;
end;

procedure TMainForm.PCN1Click(Sender: TObject);
var
i,t,s:integer;
val:real;
table:array of array of real;
begin
 setlength(table, sg_pc_gen.ColCount - 1);
 for i := 0 to length(table)-1 do setlength(table[i],sg_pc_gen.RowCount - 1);
 //таблица по х 32 ----------------------------------------------
  if length(table) = 32 then begin
  //-------- 16 нагрузка ------------
   if length(table[0]) = 16 then begin
    for i:= 1 to 16 do begin
     for t := 1 to 16 do
       table[(t-1)*2,i-1]:=StrToFloat(SG_PCN.Cells[t,i]);
    end;
   //генерируем заполнение между точек
   for i := 0 to length(table) - 1 do
     for t := 0 to length(table[i]) - 1 do begin

       if table[i,t] = 0 then begin
        if i = 31 then val:=table[30,t] else
         val:=table[i-1,t] + (table[i+1,t]-table[i-1,t])*0.5 ;
         table[i,t]:=val;
       end;
      sg_pc_gen.Cells[i+1,t+1]:=FloatToStr(table[i,t]);
     end;

   end;
  //---- 32 нагрузка -------
  if length(table[0]) = 32 then begin


  end;

  end;
//----------------------------------------------------------------
end;

procedure TMainForm.PopupMenuUOZChange(Sender: TObject; Source: TMenuItem;
  Rebuild: Boolean);
begin
  if not LoadFirmware then
  // if uoz_data.TPS then
  n10.Enabled:=false else n10.Enabled:=true;
end;



//сохранение прошивки
procedure TMainForm.Save1Click(Sender: TObject);
begin
SaveFirmware;
end;

procedure TMainForm.SaveCteClick(Sender: TObject);
var
i,t:integer;
Myfile:textfile;
begin
if savedialog1.Execute then begin
  AssignFile(Myfile,SaveDialog1.Filename);
  rewrite(myfile);
  Append(myfile);
   WriteLn(myFile,'['+series_data.ID+']');
   WriteLn(myFile,'Name = Фаза впрыска');
  for i := 1 to 16 do
   for t := 1 to 16 do
   WriteLn(myFile,'X'+IntToStr(T)+'Z'+IntToStr(I)+'='+SG_FAZA.Cells[t,i]);
   closefile(myfile);
end;
end;

procedure TmainForm.SaveFirmware;
var
i:integer;
myFile:file of byte;
begin
if not LoadFirmware then exit;
firmware.CorrectCRC(firmware.FFirmwareData);
SaveDialog1.FilterIndex:=1;
SaveDialog1.InitialDir:=SaveDialogDir;
if savedialog1.Execute then begin
  AssignFile(Myfile,SaveDialog1.Filename);
  rewrite(myfile);
  for i := 0 to length(firmware.FFirmwareData)-1 do BEGIN
   WRITE(MYFILE,FIRMWARE.FFirmwareData[i]);
  END;
  closefile(myfile);
end;
end;

procedure TMainForm.SGpcgen1Click(Sender: TObject);
begin
PC_GEN.ID_CTE:=SERIES_DATA.ID;
PC_GEN.Addr:=series_data.addr;
PC_GEN.dad:=series_data.Table_dad;
PC_GEN.load_count:=series_data.Load_Count;
PC_GEN.TPS:=series_data.Table_Tps;
PC_GEN.RPM_count:=series_data.RPM_COUNT;
PC_GEN.BCN:=series_data.Table_bcn;
PC_GEN.Сount:=PC_GEN.load_count*PC_GEN.RPM_count - 1;
PC_GEN.mnozitel:=round(series_data.mnozitel);
firmware.GetTable(SG_PC_GEN,PC_GEN.Addr,128,1,PC_GEN.Сount,0);
resizefo;
end;

procedure TMainForm.SG_2DKeyPress(Sender: TObject; var Key: Char);
var
i:integer;
begin
//--меняем значение в прошивке

 case Key of
'+',#97,#1092,#61: for i:=SG_2d.Selection.Left to SG_2d.Selection.Right do begin
 if firmware.FFirmwareData[series_data.addr+i] < 255 then
  inc(firmware.FFirmwareData[series_data.addr+i],1)else begin
    if firmware.FFirmwareData[series_data.addr+i] = 255 then
    firmware.FFirmwareData[series_data.addr+i]:=0;
  end;
  series_data.value_index:=i;
  series1.YValue[series_data.value_index]:= firmware.ReadvalueData_1D(series_data.type_calib,series_data.addr+series_data.value_index,series_data.OBR_MUL,
  series_data.delitel,series_data.mnozitel,series_data.sum,series_data.sum_data);
  SG_2d.Cells[i,1]:=FormatFloat( '#0.#0',firmware.ReadvalueData_1D(series_data.type_calib,series_data.addr+series_data.value_index,series_data.OBR_MUL,
  series_data.delitel,series_data.mnozitel,series_data.sum,series_data.sum_data));
  end;

 '-',#100,#1074,#95: for i:=SG_2d.Selection.Left to SG_2d.Selection.Right do begin
 if firmware.FFirmwareData[series_data.addr+i] > 0 then
  inc(firmware.FFirmwareData[series_data.addr+i],-1) else begin
    if firmware.FFirmwareData[series_data.addr+i] = 0 then
    firmware.FFirmwareData[series_data.addr+i]:=255;
  end;
  series_data.value_index:=i;
  series1.YValue[series_data.value_index]:= firmware.ReadvalueData_1D(series_data.type_calib,series_data.addr+series_data.value_index,series_data.OBR_MUL,
  series_data.delitel,series_data.mnozitel,series_data.sum,series_data.sum_data);
  SG_2d.Cells[i,1]:=FormatFloat( '#0.#0',firmware.ReadvalueData_1D(series_data.type_calib,series_data.addr+series_data.value_index,series_data.OBR_MUL,
  series_data.delitel,series_data.mnozitel,series_data.sum,series_data.sum_data));
 end;
end;
//записываем в эбу
 if FOBDIIConnected then begin
  setlength(obdii.TableOLT,series_data.value_count);
 obdii.StartAddrTableOLT:=series_data.addr;
 for i := 0 to series_data.value_count - 1 do
   obdii.TableOLT[i]:=firmware.FFirmwareData[series_data.addr + i];
   obdii.FlagRewraiteTableOLT:=true;
 end;
end;

procedure TMainForm.SG_AFRDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
  VAR
  X,Y:integer;
begin
 if FOBDIIConnected then begin
  if not educationthread.run then exit;
  if not LoadFirmware then exit;

   X:= educationthread.WorkX_AFR;
   Y:= educationthread.WorkY_afr;
  if (Acol = X ) and (Arow = Y) then begin
   SG_AFR.Canvas.Brush.Color:=$009933;
   rect.Left:=rect.Left-4;
   SG_AFR.Canvas.FillRect(Rect);
   SG_AFR.Canvas.TextOut(Rect.Left+2,Rect.Top+1,SG_AFR.Cells[Acol,Arow]);
  end;
 end;
end;

procedure TMainForm.SG_AFRKeyPress(Sender: TObject; var Key: Char);
var
i,j:integer;
begin
if not self.FOBDIIConnected then  begin
  showmessage('Связь не установлена');
  exit;
end;
if not self.LoadFirmware then begin
  showmessage('Сперва загрузите прошивку');
  exit;
end;

if educationthread.Flag then begin
 showmessage('Сперва остановите обучение');
 exit;
end;
if obdii.FlagRewraiteTableOLT then exit;

///////////
 case Key of
'+',#97,#1092,#61: for i:=SG_AFR.Selection.Left to SG_AFR.Selection.Right do
     for j:=SG_AFR.Selection.Top to SG_AFR.Selection.Bottom do begin
     firmware.WriteDataAFR(i,j,true);
     end;

 '-',#100,#1074,#95: for i:=SG_AFR.Selection.Left to SG_AFR.Selection.Right do
      for j:=SG_AFR.Selection.Top to SG_AFR.Selection.Bottom do begin
      firmware.WriteDataAFR(i,j,false);
      end;
end;
//////////////
firmware.GetTable(SG_AFR,afr_data.Addr,256,14.7,afr_data.Сount,128);
J:=round(afr_data.RPM_count * afr_data.load_count);
setlength(obdii.TableOLT,j);
for i := afr_data.Addr to afr_data.Addr+j do
  obdii.TableOLT[i-afr_data.Addr]:=firmware.FFirmwareData[i];
  obdii.StartAddrTableOLT:=afr_data.Addr;
  obdii.FlagRewraiteTableOLT:=True;
end;




procedure TMainForm.SG_BCNDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
  var
  Y:integer;
  X:integer;
begin
 if FOBDIIConnected then begin
  if not educationthread.run then exit;
   X:= educationthread.WorkX_bcn;
   Y:= educationthread.WorkY_bcn;
 //----------------------
if (Acol > 0 ) and (Arow > 0) then begin
  if (Acol = X ) and (Arow = Y) then begin
   inc(rect.Left,-4);
   SG_bcn.Canvas.Brush.Color:=$009933;
   SG_bcn.Canvas.FillRect(Rect);
   SG_bcn.Canvas.TextOut(Rect.Left+2,Rect.Top+1,SG_bcn.Cells[Acol,Arow]);
  end;
  end;
 end;
end;



procedure TMainForm.SG_FAZADrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
  var
  x,y:integer;
begin
 if FOBDIIConnected then begin
  if not educationthread.run then exit;
   X:= educationthread.WorkX_faza;
   Y:= educationthread.WorkY_faza;
 //----------------------
if (Acol > 0 ) and (Arow > 0) then begin
  if (Acol = X ) and (Arow = Y) then begin
   inc(rect.Left,-4);
   SG_faza.Canvas.Brush.Color:=$009933;
   SG_faza.Canvas.FillRect(Rect);
   SG_faza.Canvas.TextOut(Rect.Left+2,Rect.Top+1,SG_faza.Cells[Acol,Arow]);
  end;
  end;
 end;
end;

procedure TMainForm.SG_hip_atDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
  var
  X:integer;
begin
rect.Left:=rect.Left-4;
 if FOBDIIConnected then begin
//----------------------------------------------------------------------------

  if not educationthread.run then exit;
  if not LoadFirmware then exit;
 // rect.Left:=rect.Left-4;
  if ( Acol > 0 ) and ( Arow = 2 )then begin

  if SG_hip_at.Cells[Acol,Arow] <>'' then begin

   if strtofloat(SG_hip_at.Cells[Acol,Arow]) > 2 then begin
    SG_hip_at.Canvas.Brush.Color:=RGB(255,0,0) end else
     begin
       if strtofloat(SG_hip_at.Cells[Acol,Arow]) < 0.5 then   SG_hip_at.Canvas.Brush.Color:=RGB(255,255,0) else
       SG_hip_at.Canvas.Brush.Color:=RGB(50,255,50);
    end;
  end;
   X:= educationthread.educat_data.rpm_rt_30;
   if ( Acol = X ) and ( Arow = 2 )then SG_hip_at.Canvas.Brush.Color:=RGB(0,255,100);

   SG_hip_at.Canvas.FillRect(Rect);
   SG_hip_at.Canvas.TextOut(Rect.Left+2,Rect.Top+1,SG_hip_at.Cells[Acol,Arow]);

  end;
 //-----------------------------------------------------
 end;
end;

procedure TMainForm.SG_hip_atKeyPress(Sender: TObject; var Key: Char);
var
i,j:integer;
begin
if not checkbox2.Checked then begin

if not self.FOBDIIConnected then  begin
  showmessage('Связь не установлена');
  exit;
end;
if not self.LoadFirmware then begin
  showmessage('Сперва загрузите прошивку');
  exit;
end;

if educationthread.Flag then begin
 showmessage('Сперва остановите обучение');
 exit;
end;
if obdii.FlagRewraiteTableOLT then exit;

end;
///////////
 case Key of
'+',#97,#1092,#61: for i:=SG_hip_at.Selection.Left to SG_hip_at.Selection.Right do
     for j:=SG_hip_at.Selection.Top to SG_hip_at.Selection.Bottom do begin
     firmware.FFirmwareData[hip_at.Addr+i-1]:=firmware.FFirmwareData[hip_at.Addr+i-1]+1;
     end;

 '-',#100,#1074,#95: for i:=SG_hip_at.Selection.Left to SG_hip_at.Selection.Right do
      for j:=SG_hip_at.Selection.Top to SG_hip_at.Selection.Bottom do begin
      firmware.FFirmwareData[hip_at.Addr+i-1]:=firmware.FFirmwareData[hip_at.Addr+i-1]-1;
      end;
 end;
 for i := 1 to 257 do  SG_hip_at.Cells[i,1]:=inttostr(firmware.FFirmwareData[hip_at.Addr+i-1]);

if not checkbox2.Checked then begin
 if obdii.FlagRewraiteTableOLT then exit;
 setlength(obdii.TableOLT,256);
 for i := hip_at.Addr to hip_at.Addr+255 do
  obdii.TableOLT[i-hip_at.Addr]:=firmware.FFirmwareData[i];
 obdii.StartAddrTableOLT:=hip_at.Addr;
 obdii.FlagRewraiteTableOLT:=True;
end;

end;

procedure TMainForm.SG_OLTDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
  var
  R,G,B,X,Y:integer;
  val:real;
begin
rect.Left:=rect.Left-4;
B:=0;
Y:=0;
x:=0;
R:=0;
G:=0;
  if ( Acol > 0 ) and ( Arow > 0 )then begin

    if SG_OLT.Cells[ACOL,AROW] <>'' then begin

     if StrToFloat(SG_OLT.Cells[ACOL,AROW]) >= firmware.avg_table then begin
      val:=StrToFloat(SG_OLT.Cells[ACOL,AROW]);
       if firmware.MAX_table <> firmware.avg_table then  begin
        R:=round( 50 + (val-firmware.avg_table)/(firmware.MAX_table-firmware.avg_table) * ( 255 - 50 ) );
        G:=round( 255+(VAL-firmware.avg_table)/(firmware.MAX_table-firmware.avg_table) *(-100) );
       end else begin
        r:=0;
        G:=255;
       end;
      end;

      if StrToFloat(SG_OLT.Cells[ACOL,AROW]) <= firmware.avg_table then begin
      val:=StrToFloat(SG_OLT.Cells[ACOL,AROW]);
      if firmware.MAX_table <> firmware.avg_table then
      R:=lo(round( 255 + (val-firmware.min_table)/(firmware.avg_table-firmware.min_table) * (-100)) )
      else r:=0;
      g:=255;
     // G:=round( 100+(VAL-min_table)/(firmware.avg_table-min_table) *(155) );
      end;
      if R < 0 then r:=0;
      if g < 0 then g:=0;
      if b < 0 then b:=0;

      if R > 255 then  r:=255;
      if G > 255 then  G:=255;
      if B > 255 then  b:=255;

      SG_OLT.Canvas.Brush.Color:=RGB(R,G,B);
      SG_OLT.Canvas.FillRect(Rect);
      SG_OLT.Canvas.TextOut(Rect.Left+2,Rect.Top+2,SG_OLT.Cells[Acol,Arow]);
    end;
  end;
//--------------------------------------------------------------------------
if (Acol >= SG_OLT.Selection.Left) And  (Acol <=SG_OLT.Selection.Right) and
( arow >= SG_OLT.Selection.Top) and (arow <= SG_OLT.Selection.Bottom) then begin
   SG_OLT.Canvas.Brush.Color:=RGB(200,240,255);
   SG_OLT.Canvas.FillRect(Rect);
   SG_OLT.Canvas.Font.Color:=Clblack;
   SG_OLT.Canvas.TextOut(Rect.Left+5,Rect.Top+3,SG_OLT.Cells[Acol,Arow]);
end;
//--------------------------------------------
if not educationthread.Run then  exit;
  if series_data.RPM_COUNT = 16 then X:=educationThread.educat_data.RPM_RT_16;
  if series_data.RPM_COUNT = 32 then X:=educationThread.educat_data.RPM_RT_32;
  if series_data.Load_Count = 16 then begin
    if series_data.Table_dad then  Y:=educationthread.educat_data.DAD_RT_16;
    if series_data.Table_Tps then  Y:=educationthread.educat_data.TPS_RT_16;
    if series_data.Table_BCN then  Y:=educationthread.educat_data.BCN_RT_16;

  end;
  if series_data.Load_Count = 32 then  begin
    if series_data.Table_dad then  Y:=educationthread.educat_data.DAD_RT_32;
    if series_data.Table_Tps then  Y:=educationthread.educat_data.TPS_RT_32;
    if series_data.Table_BCN then  Y:=educationthread.educat_data.BCN_RT_16;
  end;
  if (Acol = X ) and (Arow = Y) then begin
   SG_OLT.Canvas.Brush.Color:=$B03060;
   SG_OLT.Canvas.FillRect(Rect);
   SG_OLT.Canvas.TextOut(Rect.Left+2,Rect.Top+1,SG_OLT.Cells[Acol,Arow]);
  end;

 //----------------------------------------------------------------------------
end;

procedure TMainForm.SG_OLTKeyPress(Sender: TObject; var Key: Char);

 procedure writefirOlt(RT:integer;Val:integer);
 begin
  inc(firmware.FFirmwareData[series_data.addr + RT - 1],val);
  firmware.GetTable(SG_OLT,series_data.addr,series_data.delitel,series_data.mnozitel,(sg_OLT.ColCount-1)*(sg_olt.RowCount-1)-1,series_data.sum);
  series_data.value_count:=(sg_olt.ColCount-1)*(sg_olt.RowCount - 1);
if not checkbox2.Checked then    ReWraiTeOLT;
 end;

var
i,j,RT:integer;
S1,S2:real;
SUM:integer;
begin
if not checkbox2.Checked then begin

//---------------------------------------------------------------------------
 if not self.FOBDIIConnected then  begin
  showmessage('Связь не установлена');
  exit;
end;
if not self.LoadFirmware then begin
  showmessage('Сперва загрузите прошивку');
  exit;
end;

if educationthread.Flag then begin
 showmessage('Сперва остановите обучение');
 exit;
end;
if obdii.FlagRewraiteTableOLT then exit;

///////////
end;

if not SG_OLT.EditorMode then begin

 case Key of
'+',#97,#1092,#61: for i:=SG_OLT.Selection.Left to SG_OLT.Selection.Right do
     for j:=SG_OLT.Selection.Top to SG_OLT.Selection.Bottom do begin
     RT:=(J-1)*(SG_OLT.ColCount-1)+I;
     writefirOlt(RT,1);
     end;

 '-',#100,#1074,#95: for i:=SG_OLT.Selection.Left to SG_OLT.Selection.Right do
      for j:=SG_OLT.Selection.Top to SG_OLT.Selection.Bottom do begin
      RT:=(J-1)*(SG_OLT.ColCount-1)+I;
     writefirOlt(RT,-1);
      end;
end;
end;
 //-----------------
 //-------------------------------
if not CharInSet (Key, ['0'..'9', #8,#13,',']) then Key:=#0 else begin
sg_olt.Options:=SG_OLT.Options+[goEditing];
end;
if key = #13 then begin
  sg_olt.Options:=SG_OLT.Options-[goEditing];
  I:=SG_OLT.Selection.Left;
  j:=SG_OLT.Selection.Top;
  RT:=(J-1)*(SG_OLT.ColCount-1)+I;
  S1:=(firmware.FFirmwareData[series_data.addr + RT - 1]);//+series_data.sum)/series_data.delitel*series_data.mnozitel;
  if SG_OLT.cells[I,J]<>'' then
  S2:=round(StrToFloat(SG_OLT.cells[I,J])/series_data.mnozitel*series_data.delitel-series_data.sum)
  else S2:=S1;
  Sum:=round(S2-S1);
  writefirOlt(RT,sum);
 end;
//---------------------------------------------------------------------------
end;

procedure TMainForm.SG_PCNDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
  var
  Y:integer;
  X:integer;
begin
rect.Left:=rect.Left-4;
 //----------------------------------------------------------------------------
 if FOBDIIConnected then begin
 //--------- держит фокус во вкладке пцн ----------------
 if checkbox6.Checked then begin
 if RzPageControl1.ActivePageIndex = 1 then
  begin
   sg_pcn.Col:= educationthread.WorkX_PCN;
   sg_pcn.Row:= educationthread.WorkY_PCN;
   sg_pcn.SetFocus;
  end;
 end;
//---- end фокус -----------------------------------------
  if not educationthread.run then exit;
  if not LoadFirmware then exit;
 // rect.Left:=rect.Left-4;
   X:= educationthread.WorkX_PCN;
   Y:= educationthread.WorkY_PCN;

  if ( Acol > 0 ) and ( Arow > 0 )then begin
  //--- часть нормального коэфицента из модуля обучения
  if educationthread.ReadTableNormCoeff(Acol,Arow) then begin
   SG_PCN.Canvas.Brush.Color:=RGB(0,255,100);
   SG_PCN.Canvas.FillRect(Rect);
   SG_PCN.Canvas.TextOut(Rect.Left+2,Rect.Top+1,SG_PCN.Cells[Acol,Arow]);
  end;
  //---закраска таблицы коэфицента коррекции
  if sg_coeff.Cells[Acol,Arow]<>'' then begin//проверка наличия значения вообще
   if (StrToFloat(sg_coeff.Cells[Acol,Arow]) > 0.97) and (StrToFloat(sg_coeff.Cells[Acol,Arow]) < 1.03)  then begin
    SG_coeff.Canvas.Brush.Color:=RGB(0,255,100);
    SG_coeff.Canvas.FillRect(Rect);
    SG_coeff.Canvas.TextOut(Rect.Left+2,Rect.Top+1,SG_coeff.Cells[Acol,Arow]);
   end;
  end;
  end;

 if (Acol = X ) and (Arow = Y) then begin
  if educationthread.ReadTableNormCoeff(Acol,Arow) then
   SG_PCN.Canvas.Brush.Color:=RGB(140,0,0)
  else
   SG_PCN.Canvas.Brush.Color:=$009933;
   SG_PCN.Canvas.FillRect(Rect);
   SG_PCN.Canvas.TextOut(Rect.Left+2,Rect.Top+1,SG_PCN.Cells[Acol,Arow]);

   SG_coeff.Canvas.Brush.Color:=$009933;
   SG_coeff.Canvas.FillRect(Rect);
   SG_coeff.Canvas.TextOut(Rect.Left+2,Rect.Top+1,SG_coeff.Cells[Acol,Arow]);
  end;
 end;
{ //--------------------------------------------------------------------------
if (Acol >= SG_PCN.Selection.Left) And  (Acol <=SG_PCN.Selection.Right) and
  ( arow >= SG_PCN.Selection.Top) and (arow <= SG_PCN.Selection.Bottom) then
  begin
   SG_PCN.Canvas.Brush.Color:=RGB(200,240,255);
   SG_PCN.Canvas.t
   SG_PCN.Canvas.FillRect(Rect);
   SG_PCN.Canvas.TextOut(Rect.Left+5,Rect.Top+3,SG_PCN.Cells[Acol,Arow]);
end;
//--------------------------------------------  }
end;


procedure TMainForm.SG_PCNKeyPress(Sender: TObject; var Key: Char);
var
i,j:integer;
begin
if not checkbox2.Checked then begin

if not self.FOBDIIConnected then  begin
  showmessage('Связь не установлена');
  exit;
end;
if not self.LoadFirmware then begin
  showmessage('Сперва загрузите прошивку');
  exit;
end;

if educationthread.Flag then begin
 showmessage('Сперва остановите обучение');
 exit;
end;
if obdii.FlagRewraiteTableOLT then exit;

end;
///////////
 case Key of
'+',#97,#1092,#61: for i:=SG_PCN.Selection.Left to SG_PCN.Selection.Right do
     for j:=SG_PCN.Selection.Top to SG_PCN.Selection.Bottom do begin
     firmware.WriteDataPcn(i,j,true);
     end;

 '-',#100,#1074,#95: for i:=SG_PCN.Selection.Left to SG_PCN.Selection.Right do
      for j:=SG_PCN.Selection.Top to SG_PCN.Selection.Bottom do
       firmware.WriteDataPcn(i,j,false);

end;
//////////////
firmware.GetTable(SG_PCN,pcn_data.Addr,pcn_data.delitel,pcn_data.mnozitel,pcn_DATA.Сount,pcn_data.sum);
j:=0;
if (pcn_data.RPM_count = 32) and ( pcn_data.load_count = 32 ) then j:=1024;
if (pcn_data.RPM_count = 32) and ( pcn_data.load_count = 16 ) then j:=512;
if (pcn_data.RPM_count = 16) and ( pcn_data.load_count = 16 ) then j:=256;
if not checkbox2.Checked then begin

setlength(obdii.TableOLT,j);
for i := pcn_data.Addr to pcn_data.Addr+j do
  obdii.TableOLT[i-pcn_data.Addr]:=firmware.FFirmwareData[i];
  obdii.StartAddrTableOLT:=pcn_data.Addr;
  obdii.FlagRewraiteTableOLT:=True;
end;
end;

procedure TMainForm.SG_UOZDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
  var
  Y:integer;
  X:integer;
begin
 if FOBDIIConnected then begin
  if not educationthread.run then exit;
   X:= educationthread.WorkX_UOZ;
   Y:= educationthread.WorkY_uoz;
   INC(rect.Left,-4);
 //----------------------
if (Acol > 0 ) and (Arow > 0) then begin
 if educationThread.ReadCnock(Acol,Arow) then begin
   SG_uoz.Canvas.Brush.Color:=RGB(255,0,0);
   SG_uoz.Canvas.FillRect(Rect);
   SG_uoz.Canvas.TextOut(rect.Left+2,Rect.Top+1,SG_uoz.Cells[Acol,Arow]);
 end;
  end;
  if (Acol = X ) and (Arow = Y) then begin
   SG_uoz.Canvas.Brush.Color:=$009933;
   SG_uoz.Canvas.FillRect(Rect);
   SG_uoz.Canvas.TextOut(rect.Left+2,Rect.Top+1,SG_uoz.Cells[Acol,Arow]);
  end;
//---------------------------------
 end;
end;

procedure TMainForm.SG_UOZKeyPress(Sender: TObject; var Key: Char);
var
i,j:integer;
begin
if not self.FOBDIIConnected then  begin
  showmessage('Связь не установлена');
  exit;
end;
if not self.LoadFirmware then begin
  showmessage('Сперва загрузите прошивку');
  exit;
end;

if educationthread.Flag then begin
 showmessage('Сперва остановите обучение');
 exit;
end;
if obdii.FlagRewraiteTableOLT then exit;

///////////
 case Key of
'+',#97,#1092,#61: for i:=SG_uoz.Selection.Left to SG_uoz.Selection.Right do
     for j:=SG_uoz.Selection.Top to SG_uoz.Selection.Bottom do begin
     firmware.WriteDatauoz(i,j,true);
     end;

 '-',#100,#1074,#95: for i:=SG_uoz.Selection.Left to SG_uoz.Selection.Right do
      for j:=SG_uoz.Selection.Top to SG_uoz.Selection.Bottom do begin
      firmware.WriteDatauoz(i,j,false);
      end;
end;
//////////////
firmware.GetTable(SG_uoz,uoz_data.Addr,uoz_data.delitel,uoz_data.mnozitel,uoz_DATA.Сount,0);
J:=round(uoz_data.RPM_count * afr_data.load_count);
setlength(obdii.TableOLT,j);
for i := uoz_data.Addr to uoz_data.Addr+j do
  obdii.TableOLT[i-uoz_data.Addr]:=firmware.FFirmwareData[i];
  obdii.StartAddrTableOLT:=uoz_data.Addr;
  obdii.FlagRewraiteTableOLT:=True;
end;
procedure TMainForm.SpinButton1DownClick(Sender: TObject);
var
i:real;
begin
if panel18.Caption <> '' then begin
try
i:=StrToFloat(stringreplace((panel18.Caption),'.',',',[rfReplaceAll, rfIgnoreCase]));
except
i:=StrToFloat(stringreplace((panel18.Caption),',','.',[rfReplaceAll, rfIgnoreCase]));

end;
 //i:=StrToFloat(panel18.Caption);
 I:=I-0.1;
 if I < 0.1 then  i:=0.1;
 panel18.Caption:=FloatToStr(i);
end;
end;

procedure TMainForm.SpinButton1UpClick(Sender: TObject);
var
i:real;
begin
if panel18.Caption <> '' then begin
try
i:=StrToFloat(stringreplace((panel18.Caption),'.',',',[rfReplaceAll, rfIgnoreCase]));
except
i:=StrToFloat(stringreplace((panel18.Caption),',','.',[rfReplaceAll, rfIgnoreCase]));
end;
 I:=I+0.1;
 if I > 0.9 then  i:=0.9;
 panel18.Caption:=FloatToStr(i);
end;
end;

//
procedure Tmainform.Resizetab_OLT;
var
wi,he:integer;
wi_dir:integer;
wi_new:integer;
begin
wi:=mainform.TabSheet_OLT.Width;//ширина
he:=mainform.TabSheet_OLT.Height;//высота
wi_dir:=mainform.TreeView1.Width+mainform.TreeView1.Left+5;
wi_new:=wi-wi_dir;
panel2.Width:=wi_new;
//panel2.Height:=HE - label11.Font.Size - label10.Font.Size;
panel2.Left:=wi_dir;
panel_2D.Width:=wi_new;
panel_2D.Height:=he;
panel_2D.Left:=wi_dir;

 with mainform.SG_OLT do begin
  Width:=wi_new;
  Height:=panel2.Height;
  Left:=0;
  top:=0;
  DefaultColWidth:=round(wi_new/(colcount+2));
  DefaultRowHeight:=round(Height/(rowcount+2));
  font.Height:=DefaultRowHeight-4;
  font.Size:=DefaultColWidth div 4;
 end;

end;
procedure TMainForm.RPM1Click(Sender: TObject);
var
Le,Ri,Topi,butti,//Le_top,ri_but,
i,t:integer;
RT,RT_1,RT_2:integer;
mnoz:real;
da_1,da_2,da:byte;
begin
Le:=sg_pcn.Selection.Left;
Ri:=sg_pcn.Selection.Right;
Topi:=sg_pcn.Selection.Top;
butti:=sg_pcn.Selection.Bottom;
//Le_top:=sg_pcn.Selection.TopLeft.X;
//ri_but:=sg_pcn.Selection.BottomRight;
for i := Topi to butti  do
 for t := le to ri  do begin
 mnoz:=(t-le)/(ri-le);
 RT:=(i-1)*pcn_data.RPM_count+t-1;
 RT_1:=(i-1)*pcn_data.RPM_count+le-1;
 RT_2:=(i-1)*pcn_data.RPM_count+ri-1;
 da_1:=firmware.FFirmwareData[pcn_data.Addr+RT_1];
 da_2:=firmware.FFirmwareData[pcn_data.Addr+RT_2];
 DA:=round(da_1+(DA_2-DA_1)*mnoz);
 firmware.FFirmwareData[pcn_data.Addr+rt]:=da;
 firmware.GetTable(SG_PCN,PCN_DATA.Addr,pcn_data.delitel,pcn_data.mnozitel,pcn_data.Сount,pcn_data.sum);
end;
RevratePcn_olt;
end;
procedure Tmainform.InterTable_X(table: TStringGrid; addr: Integer);
var
I,t,rt,T1,T2,T3,rt1,rt3:integer;
mnoz:real;
begin
 for I := table.Selection.top to table.Selection.Bottom do
  for t := table.Selection.Left to table.Selection.Right do begin
   RT:=(I-1)*(table.ColCount-1)+T-1;
   rt1:=(I-1)*(table.ColCount-1)+table.Selection.Left-1;
   rt3:=(I-1)*(table.ColCount-1)+table.Selection.Right-1;
   T1:=firmware.FFirmwareData[addr+rt1];
   T3:=firmware.FFirmwareData[addr+rt3];
   mnoz:=(t-table.Selection.Left)/(table.Selection.Right-table.Selection.Left);
   T2:=round(T1+(T3-T1)*mnoz);
   firmware.FFirmwareData[addr+rt]:=T2;
  end;
end;
procedure Tmainform.InterTable_Y(table: TStringGrid; addr: Integer);
var
I,t,rt,T1,T2,T3,rt1,rt3:integer;
mnoz:real;
begin
 for I := table.Selection.left to table.Selection.Right do
  for t := table.Selection.top to table.Selection.Bottom do begin
   RT:= (T-1)*(Table.ColCount-1) + I - 1;

   RT1:=(table.Selection.top-1)*(Table.ColCount-1) + I - 1;
   RT3:=(table.Selection.Bottom-1)*(Table.ColCount-1) + I - 1;

   T1:=firmware.FFirmwareData[addr+rt1];
   T3:=firmware.FFirmwareData[addr+rt3];
   mnoz:=(t-table.Selection.Top)/(table.Selection.Bottom-table.Selection.Top);
   T2:=round(T1+(T3-T1)*mnoz);
   firmware.FFirmwareData[addr+rt]:=T2;
  end;
end;
procedure TMainForm.RPM2Click(Sender: TObject);
var
Le,Ri,
Topi,butti,//Le_top,//ri_but,
i,t:integer;
RT,RT_1,RT_2:integer;
mnoz:real;
da_1,da_2,da:byte;
begin
Le:=sg_uoz.Selection.Left;
Ri:=sg_uoz.Selection.Right;
Topi:=sg_uoz.Selection.Top;
butti:=sg_uoz.Selection.Bottom;
//Le_top:=sg_pcn.Selection.TopLeft.X;
//ri_but:=sg_pcn.Selection.BottomRight;
for i := Topi to butti  do
 for t := le to ri  do begin
 mnoz:=(t-le)/(ri-le);
 RT:=(i-1)*uoz_data.RPM_count+t-1;
 RT_1:=(i-1)*uoz_data.RPM_count+le-1;
 RT_2:=(i-1)*uoz_data.RPM_count+ri-1;
 da_1:=firmware.FFirmwareData[uoz_data.Addr+RT_1];
 da_2:=firmware.FFirmwareData[uoz_data.Addr+RT_2];
 DA:=round(da_1+(DA_2-DA_1)*mnoz);
 firmware.FFirmwareData[uoz_data.Addr+rt]:=da;
 firmware.GetTable(SG_uoz,uoz_data.Addr,2,1,uoz_DATA.Сount,0);
end;
RevraiteUoz_olt;
end;

procedure TMainForm.RzSpinEdit11Change(Sender: TObject);
var
plot:real;
CC_:real;
cc_new:integer;
begin
plot:=1;
if RadioButton5.Checked then  plot:=0.748;
if RadioButton6.Checked then  plot:=0.758;
if RadioButton7.Checked then  plot:=0.780;
CC_:=RzSpinEdit11.IntValue ;
CC_:=round(CC_* plot / 60 * 1000) / 1000;
RzSpinEdit12.Value:=CC_;
cc_new:=round(sqrt(RzSpinEdit13.Value/3)*RzSpinEdit11.IntValue);
label50.Caption:=inttostr(cc_new)+'cc';
CC_:=round(cc_new* plot / 60 * 1000) / 1000;
label51.Caption:=floattostr(CC_)+'мг/мс';
end;

procedure TMainForm.RzSpinEdit12Change(Sender: TObject);
var
plot:real;
CC_:real;
begin
plot:=1;
if RadioButton5.Checked then  plot:=0.748;
if RadioButton6.Checked then  plot:=0.758;
if RadioButton7.Checked then  plot:=0.780;
CC_:=RzSpinEdit12.Value ;
CC_:=round(CC_* 60 / plot) ;
//CC_:=round(CC_* plot / 60 * 1000) / 1000;
RzSpinEdit11.Value:=CC_;
end;

procedure TMainForm.RzSpinEdit1ButtonClick(Sender: TObject;
  Button: TSpinButtonType);
begin
SAVESET;
end;

procedure TMainForm.RzSpinEdit1Change(Sender: TObject);
begin
if educationThread.Run then
 educationThread.educat_data.education_Twat:=StrToInt(RZspinedit1.Text);
end;

procedure TMainForm.RzSpinEdit2Change(Sender: TObject);
begin
if educationThread.Run then begin
 educationThread.educat_data.education_tps:=StrToInt(RZspinedit2.Text);
 educationThread.educat_data.education_tps_hi:=StrToInt(RZspinedit8.Text);
end;
end;


procedure TMainForm.RzSpinEdit4Change(Sender: TObject);
begin
if educationThread.Run then
 educationThread.educat_data.SleepStacionar:=StrToInt(RZspinedit4.Text);

end;

procedure TMainForm.RzSpinEdit5Change(Sender: TObject);
begin
//SAVESET;
end;

procedure TMainForm.RzSpinEdit5Changing(Sender: TObject; NewValue: Extended;
  var AllowChange: Boolean);
begin
if (LoadFirmware) and (FOBDIIConnected) then begin
educationThread.educat_data.EducationCoeffLow:=Rzspinedit5.IntValue;
end;
end;

procedure TMainForm.RzSpinEdit6Changing(Sender: TObject; NewValue: Extended;
  var AllowChange: Boolean);
begin
if (LoadFirmware) and (FOBDIIConnected) then begin
educationThread.educat_data.TCOEFF:=Rzspinedit6.IntValue;
end;
end;

procedure TMainForm.RzSpinEdit7Change(Sender: TObject);
begin
if educationThread.Run then
 educationThread.FMaxEduCount:=StrToInt(RZspinedit7.Text);
end;

procedure TMainForm.RzSpinEdit9Change(Sender: TObject);
begin
if educationThread.Run then begin
 educationThread.educat_data.education_rpm_lo:=StrToInt(RZspinedit9.Text);
 educationThread.educat_data.education_rpm_hi:=StrToInt(RZspinedit10.Text);
end;
end;

procedure TMainForm.RzSpinEdit9Changing(Sender: TObject; NewValue: Extended;
  var AllowChange: Boolean);
begin
if educationThread.Run then begin
 educationThread.educat_data.education_rpm_lo:=StrToInt(RZspinedit9.Text);
 educationThread.educat_data.education_rpm_hi:=StrToInt(RZspinedit10.Text);
end;
end;

procedure Tmainform.ResizeFo;
begin
//-------
  SG_PC_GEN.Width:=PCN_GEN.Width;
  SG_PC_GEN.Height:=PCN_GEN.Height;
  SG_PC_GEN.DefaultColWidth:=SG_PC_GEN.Width div (SG_PC_GEN.ColCount+SG_PC_GEN.GridLineWidth);
  SG_PC_GEN.DefaultRowHeight:=SG_PC_GEN.height div (SG_PC_GEN.rowCount+SG_PC_GEN.GridLineWidth);
 //-----BCN
  SG_BCN.Width:=tabsheet_bcn.Width;
  sg_bcn.Height:=tabsheet_bcn.Height;
  SG_bcn.DefaultColWidth:=sg_bcn.Width div (sg_bcn.ColCount+sg_bcn.GridLineWidth);
  sg_bcn.DefaultRowHeight:=sg_bcn.height div (sg_bcn.rowCount+sg_bcn.GridLineWidth);
//-----PCN
  SG_pcn.Width:=tabsheet_pcn.Width;
  sg_pcn.Height:=tabsheet_pcn.Height;
  SG_pcn.DefaultColWidth:=sg_pcn.Width div (sg_pcn.ColCount+sg_pcn.GridLineWidth);
  sg_pcn.DefaultRowHeight:=sg_pcn.height div (sg_pcn.rowCount+sg_pcn.GridLineWidth);
  SG_COEFF.Width:=tabsheet_coeff.Width;
  SG_COEFF.Height:=tabsheet_coeff.Height;
  SG_COEFF.DefaultColWidth:=sg_coeff.Width div (SG_COEFF.ColCount+SG_COEFF.GridLineWidth);
  sg_COEFF.DefaultRowHeight:=SG_COEFF.height div (SG_COEFF.rowCount+SG_COEFF.GridLineWidth);
  //-----UOZ
  SG_UOZ.Width:=tabsheet_uoz.Width;
  sg_UOZ.Height:=tabsheet_Uoz.Height;
  SG_UOZ.DefaultColWidth:=sg_uoz.Width div (sg_uoz.ColCount+sg_uoz.GridLineWidth);
  sg_UOZ.DefaultRowHeight:=sg_uoz.height div (sg_uoz.rowCount+sg_uoz.GridLineWidth);
  //-----AFR
  SG_AFR.Width:=tabsheet_afr.Width;
  SG_AFR.Height:=tabsheet_afr.Height;
  SG_AFR.DefaultColWidth:=SG_AFR.Width div (SG_AFR.ColCount+SG_AFR.GridLineWidth);
  SG_AFR.DefaultRowHeight:=SG_AFR.height div (SG_AFR.rowCount+SG_AFR.GridLineWidth);
  //----- faza ----
  SG_FAZA.Width:=tabsheet_afr.Width;
  SG_FAZA.Height:=tabsheet_afr.Height;
  SG_FAZA.DefaultColWidth:=SG_FAZA.Width div (SG_FAZA.ColCount+SG_FAZA.GridLineWidth);
  SG_FAZA.DefaultRowHeight:=SG_FAZA.height div (SG_FAZA.rowCount+SG_FAZA.GridLineWidth);
  //----------------
  Resizetab_OLT;
end;
procedure TMainForm.Timer1Timer(Sender: TObject);
begin
//if FOBDIIConnected then
// if obdii.RunThread then BEGIN
  if obdii <> nil then   begin
  if not obdii.PortOpen then begin
   rzglyphstatus1.Caption:='Отключено';
   rzglyphstatus1.ImageIndex:=2;
   FOBDIIConnected:=False;
  end else begin
   rzglyphstatus1.Caption:='Порт открыт';
   rzglyphstatus1.ImageIndex:=0;
  end;
  if OBDII.Flag_outDiag then BEGIN
    disconnect;
    CONNECTECU ;
    Timer1.Enabled:=False;
    end;
 END;

end;

procedure TMainForm.Timer2Timer(Sender: TObject);
begin
inc(PowerValue,1);
label1.Caption:='Разгон =' + FloatToStr(PowerValue/100);
end;

procedure TMainForm.Timer3Timer(Sender: TObject);
begin
 if obdii.RunThread then  begin
 if TTimeZavis_OBD = obdii.TTTIIME then
  inc(TTimeZavis,1) else TTimeZavis:=0;

  label30.Caption:=IntToStr( TTimeZavis);
  TTimeZavis_OBD:= obdii.TTTIIME;
 end;

end;

procedure TMainForm.Timer4Timer(Sender: TObject);
begin
if Assigned(obdii) then begin
  if not OBDII.Suspended then
   inc(obdII.Time_T,1);
   if obdII.Time_T > 10000 then  obdII.Time_T:=0;
end;
end;

procedure TMainForm.TrackBar1Change(Sender: TObject);
begin
if trackbar1.Enabled = false then exit;
if obdii.FlagWriteIO then exit;

if obdii.IO_DATA[combobox4.ItemIndex].Status then begin
   if combobox4.ItemIndex = 0 then begin
   setlength(obdii.DATA_IO,3);
   obdii.DATA_IO[0]:=$49;
   obdii.DATA_IO[1]:=$07;
   obdii.DATA_IO[2]:=trackbar1.Position;
   if obdii.DATA_IO[2] <> obdii.IO_DATA[combobox4.ItemIndex].valid_value then
   OBDII.FlagWriteIO:=True;
   end;
   if combobox4.ItemIndex = 1 then begin
   setlength(obdii.DATA_IO,3);
   obdii.DATA_IO[0]:=$4A;
   obdii.DATA_IO[1]:=$07;
   obdii.DATA_IO[2]:=trackbar1.Position;
   if obdii.DATA_IO[2] <> obdii.IO_DATA[combobox4.ItemIndex].valid_value then
   OBDII.FlagWriteIO:=True;
   end;
   if combobox4.ItemIndex = 2 then begin
   setlength(obdii.DATA_IO,3);
   obdii.DATA_IO[0]:=$41;
   obdii.DATA_IO[1]:=$07;
   obdii.DATA_IO[2]:=trackbar1.Position;
   if obdii.DATA_IO[2] <> obdii.IO_DATA[combobox4.ItemIndex].valid_value then
   OBDII.FlagWriteIO:=True;
   end;


   if combobox4.ItemIndex = 11 then begin
   setlength(obdii.DATA_IO,3);
   obdii.DATA_IO[0]:=$4C;
   obdii.DATA_IO[1]:=$07;
   obdii.DATA_IO[2]:=trackbar1.Position;
   if obdii.DATA_IO[2] <> obdii.IO_DATA[combobox4.ItemIndex].valid_value then
   OBDII.FlagWriteIO:=True;
   end;

   if obdii.IO_DATA[combobox4.ItemIndex].ID = $49 then
    panel9.Caption:=FormatFloat('00.00',(obdii.IO_DATA[combobox4.ItemIndex].valid_value + 128 )*14.7/256) ;
   if obdii.IO_DATA[combobox4.ItemIndex].ID = $4A then
    panel9.Caption:=FloatToStr(obdii.IO_DATA[combobox4.ItemIndex].valid_value / 2);
   if obdii.IO_DATA[combobox4.ItemIndex].ID = $41 then
    panel9.Caption:=FloatToStr(obdii.IO_DATA[combobox4.ItemIndex].valid_value);
   if obdii.IO_DATA[combobox4.ItemIndex].ID = $4C then
    panel9.Caption:=FloatToStr(obdii.IO_DATA[combobox4.ItemIndex].valid_value);

end;
end;

procedure TMainForm.TreeView1Change(Sender: TObject; Node: TTreeNode);
var
flag_panel:Tpanel;
addr,addr_temp:int64;
addrCalib:int64;
ToX,ToY, n,t:integer;
S:String;
sum,sum_data,delitel,mnozitel:real;
LoadOcY,OC_X,nAMEocX:string;
Ys, Ye, Ymn, Ymx,StepX,StepY:double;
//tempAdr:integer;
minData:real;
ardata:array of real;
//StepY:real;
obr_mul:real;
Min_X,Max_X,Min_XX,MAX_XX:real;
STEP_X:real;
maska:byte;
//Ymn, Ymx:integer;
begin
 node:=self.TreeView1.Selected;
 sum_data:=0;
 obr_mul:=0;
 //StepX:=0;
   if Node.ImageIndex > 1 then Node.SelectedIndex := Node.ImageIndex;
  // Label1.Caption := ' Адрес в карте = ' + IntToHex(Integer( Node.Data ),4);
  // label2.Caption := ' Название калибровки = ' + node.Text;
  // label3.Caption := ' Тип калибровки = ' + inttostr( node.ImageIndex - 1 );
   //***** проверяется есть ли адрес для определения адреса калибровки
   if integer(node.Data) > 0 then  begin
    addr:= integer(node.Data);
    addr_temp:=addr;
    case node.ImageIndex - 1 of
////////////////////-------------------------  // график '2D' ****************
      1:begin
      {
       label4.Caption:=' Адрес калибровки = '+ IntToHex(D_Word(Addr+$49, true ),8);  //  адрес тарировки (заксорен).
       label5.Caption:=' Тип тарировки = ' + inttostr(mainform.data_map[addr + $45 + $178]);
       ToX := mainform.data_map[Addr+$45+$153] * $100 + mainform.data_map[Addr+$45+$152];
       label6.Caption:=' Число точек по оси Х = ' + inttostr(Tox);
       }
      mainform.Panel_2D.Visible:=True;
      mainform.Panel2.Visible:=False;
      mainform.Panel3.Visible:=false;
      mainform.Series1.Clear;
     S:=''; for n := Addr+1 to Addr+mainform.data_map[Addr] do S:=S + chr(mainform.data_map[n]);
     mainform.Chart1.Title.Text.Text := cp1252tocp1251(S);
     inc(Addr, $45);
     S:=''; for n := Addr to Addr+3 do S:=S + IntToHex(mainform.data_map[n],2);
     // mainform.edit43.Text:=cp1252tocp1251(S);      // 4 байта уникального ID для функции сравнения.
     addrcalib := D_Word(Addr+$4, true );                                  //  адрес тарировки (заксорен).
     S:=''; for n := Addr+$11 to Addr+$11-1+mainform.data_map[Addr+$10] do S:=S + chr(mainform.data_map[n]);
     // mainform.edit45.Text:=cp1252tocp1251(S);
     mainform.Chart1.BottomAxis.Title.Caption := cp1252tocp1251(S);  // до 32 байт - название оси X.
     S:=''; for n := Addr+$32 to Addr+$32-1+mainform.data_map[Addr+$31] do S:=S + chr(mainform.data_map[n]);
     // mainform.edit46.Text:=cp1252tocp1251(S);
     mainform.Chart1.LeftAxis.Title.Caption := cp1252tocp1251(S);    // до 32 байт название оси Y.
     S:=''; for n := Addr+$53 to Addr+$53-1+mainform.data_map[Addr+$52] do S:=S + chr(mainform.data_map[n]);
     S:=cp1252tocp1251(S);                        //  до ??? байт - ссылка на тарировку по другой таблце
     OC_X:=S;
     //----------------/////////////-*----------------*******----------
     toX := mainform.data_map[Addr+$153] * $100 + mainform.data_map[Addr+$152];
     S:= IntToStr(toX);                      // точек по оси X
     S:= FloatToStr(D_Double(Addr+$156));   // начало оси X
     S:= FloatToStr(D_Double(Addr+$15E));   // конец  оси X
     StepX := (D_Double(Addr+$15E) - D_Double(Addr+$156))/ (toX -1);
     mainform.Chart1.BottomAxis.Increment := StepX;             // шаг по оси X
     S := IntToHex(mainform.data_map[Addr+$155],2) + IntToHex(mainform.data_map[Addr+$154],2); // сдвиг и маска для характеристики
     if mainform.Chart1.BottomAxis.Minimum <= D_Double(Addr+$15E) then
      begin
       mainform.Chart1.BottomAxis.Maximum := D_Double(Addr+$15E);
       mainform.Chart1.BottomAxis.Minimum := D_Double(Addr+$156);
      end
     else
      begin
       mainform.Chart1.BottomAxis.Minimum := D_Double(Addr+$156);
       mainform.Chart1.BottomAxis.Maximum := D_Double(Addr+$15E);
      end;
     //mainform.Edit51.Text := FloatToStr(D_Double(Addr+$167));  //  ограничитель 1
     //mainform.Edit52.Text := FloatToStr(D_Double(Addr+$16F));  //  ограничитель 2
     //mainform.Edit53.Text := IntToStr(mainform.data_map[Addr+$178]);       //  тип тарировки
     case mainform.data_map[Addr+$178] of
     0: begin Ymn:=0; Ymx:=255; end;        // беззнаковый байт (0-255)
     1: begin Ymn:=-128; Ymx:=127; end;     // знаковый байт (-128 +127)
     2: begin Ymn:=0; Ymx:=65535; end;      // беззаковое слово, сначала младший потом старший.
     3: begin Ymn:=-32768; Ymx:=32767; end; // знаковое слово, сначала младший потом старший.
     4: begin Ymn:=0; Ymx:=65535; end;      // беззнаковое слово, сначала старший потом младший.
     5: begin Ymn:=-32768; Ymx:=32767; end; // знаковое слово, сначала старший потом младший.
     6: begin Ymn:=0; Ymx:=65535; end;      // беззнаковое слово. Младший mod 65535 cтарший...
     else begin Ymn:=0; Ymx:=255; end;      // беззнаковый байт (0-255)
     end;
     {
     mainform.Edit54.Text := FloatToStr(D_Double(Addr+$17C));  // делитель шага Y   - 2-й мультипликативный
     mainform.Edit55.Text := FloatToStr(D_Double(Addr+$184));  //                   - 2-й аддитивный
     mainform.Edit56.Text := FloatToStr(D_Double(Addr+$18C));  //                   - обратный мультипликативный
     mainform.Edit57.Text := FloatToStr(D_Double(Addr+$194));  // шаг по Y          - 1-й мультипликативный
     mainform.Edit58.Text := FloatToStr(D_Double(Addr+$19C));  // смещение по оси Y - 1-й аддитивный
     }
     delitel := D_Double(Addr+$17C);  // Делитель для шага
     sum := D_Double(Addr+$184);  // смещение ...
     OBR_MUL := D_Double(Addr+$18C);  //обратный мультипликативный
     mnozitel:= D_Double(Addr+$194);  // Шаг...
     sum_data := -D_Double(Addr+$19C); // смещение ...
     //--------------------------------------------------------------------------------------
      series_data.type_calib:=mainform.data_map[Addr+$178];
      series_data.value_count:=TOX;
      series_data.addr:=addrcalib;
      series_data.delitel:=delitel;
      series_data.sum:=sum;
      series_data.OBR_MUL:=OBR_MUL;
      series_data.mnozitel:=mnozitel;
      series_data.sum_data:=sum_data;

if ( mainform.data_map[Addr+$178] > 1 ) and ( mainform.data_map[Addr+$178] < 7) then
  series_data.value_count:=series_data.value_count*2;

     StepY:=D_Double(Addr+$194)/D_Double(Addr+$17C);
     Ys := (Ymn - D_Double(Addr+$19C)) * StepY - D_Double(Addr+$184);
     Ye := (Ymx - D_Double(Addr+$19C)) * StepY - D_Double(Addr+$184);
     if mainform.Chart1.LeftAxis.Minimum <= Ye then
      begin
       mainform.Chart1.LeftAxis.Maximum := Ye;
       mainform.Chart1.LeftAxis.Minimum := Ys;
      end
     else
      begin
       mainform.Chart1.LeftAxis.Minimum := Ys;
       mainform.Chart1.LeftAxis.Maximum := Ye;
      end;
     //for nc:=0 to 17 do mainform.Chart1.Series[nc].Clear;
     //for nc:=0 to 17 do mainform.Chart1.Series[nc].Active:=false;
     //mainform.Chart1.Series[0].Active:=true;
     //mainform.Chart1.Series[1].Active:=true;
     //m:=1;
     {
     //    S:='';
    s:=FloatToStr( firmware.ReadvalueData_1D(mainform.data_map[Addr+$31],addrcalib,OBR_MUL,delitel,mnozitel,sum,sum_data));

      Randomize;
      }
      //-------------------------------------------------------------------------
       mainform.Chart1.BottomAxis.Maximum:=tox;
       mainform.Chart1.BottomAxis.Minimum:=1;
      if OC_X = '!001-613C-40' then begin
      firmware.GetRPMAxis;
       if toX = 16 then begin
      // mainform.Chart1.BottomAxis.Maximum:=firmware.FRPMAxis[16];
      // mainform.Chart1.BottomAxis.Minimum:=firmware.FRPMAxis[1];
       end;
       if toX = 32 then begin
      // mainform.Chart1.BottomAxis.Maximum:=firmware.FRPMAxis_32[31];
      // mainform.Chart1.BottomAxis.Minimum:=firmware.FRPMAxis_32[1];
       end;
      end;
       series_data.type_calib:=mainform.data_map[Addr+$178];
     //-----------------------------------------------------------------------------
   if  OC_X = '!003-6064-6066' then begin
     firmware.GetGBCAxis;
    // mainform.Chart1.BottomAxis.Maximum:=firmware.FBCNAxis[16];
    // mainform.Chart1.BottomAxis.Minimum:=firmware.FBC Axis[1];
   end;
   SG_2d.ColCount:=tox;
     for n:= 1 to tox do                       // заполнение графика данными...
      begin
     if mainform.data_map[Addr+$178]> 1 then t:=2 else t:=1;

     S:='';
     s:=formatfloat('#0.#0', firmware.ReadvalueData_1D(mainform.data_map[Addr+$178],addrcalib+(n-1)*t,OBR_MUL,delitel,mnozitel,sum,sum_data));
     NAMEOCX:='';
     if oc_x = '!005-5F84' then  oc_x:='';
     if length(oc_X) > 8 then
     NAMEOCX:= firmware.ReadNameOC_X(oc_x,tox,n-1) else
     NAMEOCX:=floattostr(D_Double(Addr+$156) + (n-1) * StepX);
     mainform.Chart1.Series[0].AddXY(n, strToFloat(s),NAMEOCX);
     SG_2d.Cells[n-1,0]:=NAMEOCX;
     SG_2d.Cells[n-1,1]:=S;
   //  if OC_X = '!001-613C-40' then begin
     // if toX = 16 then  mainform.Chart1.Series[0].AddXY(firmware.FRPMAxis[n+1], strToFloat(s));
     // if toX = 32 then  mainform.Chart1.Series[0].AddXY(firmware.FRPMAxis_32[n+1], strToFloat(s));

  //   end;
   //  if OC_X = '!003-6064-6066' then mainform.Chart1.Series[0].AddXY(firmware.FBCNAxis[n+1], strToFloat(s));
  //   if not (OC_X = '!003-6064-6066' ) and not (OC_X = '!001-613C-40') then

     //  mainform.Chart1.Series[0].AddXY(mainform.Chart1.BottomAxis.Minimum + n * StepX, strToFloat(s));
     end;
      end;
/////////////////////********  // график '3D' ******************--------------------------------------
      2:begin
      //------------------------------
firmware.min_table:=10000;
firmware.max_table:=0;
      //-----------------------------
       panel2.Visible:=true;
       panel3.Visible:=false;
       Panel_2D.Visible:=False;
       //label4.Caption:=' Адрес калибровки = '+ IntToHex(D_Word(Addr+$49, true ),8);
       //label5.Caption:=' Тип тарировки = ' + inttostr(mainform.data_map[addr +$45+ $2AB]);
       firmware.Type_Table_ID:=mainform.data_map[addr +$45+ $2AB];
       inc(addr,$45);
       //-------------------------------------------------------------------------
     S:='';// for n := Addr to Addr+3 do S:=S + IntToHex(mainform.data_map[n],2);
     S:=IntToHex(mainform.data_map[Addr+3],2);
     S:=S + IntToHex(mainform.data_map[Addr+2],2);
     S:=S + IntToHex(mainform.data_map[Addr+1],2);
     S:=S + IntToHex(mainform.data_map[Addr],2);
     S:=cp1252tocp1251(S); // 4 байта уникального ID для функции сравнения.
     series_data.ID:=S;
     S:= IntToHex(D_Word(Addr+$4, true ),8);                             //  адрес тарировки (заксорен).
     S:=''; for n := Addr+$11 to Addr+$11-1+mainform.data_map[Addr+$10] do S:=S + chr(mainform.data_map[n]);

     S := cp1252tocp1251(S);  // до 32 байт - название оси X.
     S:=''; for n := Addr+$32 to Addr+$32-1+mainform.data_map[Addr+$31] do S:=S + chr(mainform.data_map[n]);

     S := cp1252tocp1251(S);    // до 32 байт название оси Y.
     S:=''; for n := Addr+$53 to Addr+$53-1+mainform.data_map[Addr+$52] do S:=S + chr(mainform.data_map[n]);
     S:=cp1252tocp1251(S);
     S:=''; for n := Addr+$74 to Addr+$74-1+mainform.data_map[Addr+$73] do S:=S + chr(mainform.data_map[n]);
     S:=cp1252tocp1251(S);                        //  до ??? байт - ссылка на тарировку по другой таблце для оси X
     S:=''; for n := Addr+$174 to Addr+$174-1+mainform.data_map[Addr+$173] do S:=S + chr(mainform.data_map[n]);
     S:=cp1252tocp1251(S);                        //  до ??? байт - ссылка на тарировку по другой таблце для оси Y
       //---------------------------------------------------------------------------
       addrCalib:=D_Word(Addr+$4, true );
       maska:=mainform.data_map[Addr+$4+$271];
       series_data.MASK:=maska;
       ToX := mainform.data_map[Addr+$274] * $100 + mainform.data_map[Addr+$273];


      ToY:=(mainform.data_map[Addr+$277]);
       S:='';
        for n := Addr+$11 to Addr+$11-1+mainform.data_map[Addr+$10] do
         S:=S + chr(mainform.data_map[n]);
          S:=cp1252tocp1251(S);
      // label8.Caption:=' Название оси Х = ' + S;
       S:='';
       for n := Addr+$53 to Addr+$53-1+mainform.data_map[Addr+$52] do
       S:=S + chr(mainform.data_map[n]);
       S:=cp1252tocp1251(S);

       //label9.Caption:=' Название оси Y = ' +cp1252tocp1251(S);
       //формат оси X тарировки
       S:='';
       for n := Addr+$74 to Addr+$74-1+mainform.data_map[Addr+$73] do
       S:=S + chr(mainform.data_map[n]);
       s:=cp1252tocp1251(S);
       nAMEocX:=s;
      // Label13.Caption:=' Тип Оси X = ' + S;
       //формат оси Y тарировки
       S:='';
       for n := Addr+$174 to Addr+$174-1+mainform.data_map[Addr+$173] do
        S:=S + chr(mainform.data_map[n]);

        s:=cp1252tocp1251(S);
        LoadOcY:=S;
        mnozitel := D_Double(Addr+$2C8);
        sum:=D_Double(Addr+$2D0);
        sum:=sum-sum-sum;
        delitel:=D_Double(Addr+$2B0);
        //------------------------------------------
      series_data.type_calib:=mainform.data_map[addr + $2AB];

      series_data.value_count:=TOX;
      series_data.addr:=addrcalib;
      series_data.delitel:=delitel;
      series_data.sum:=sum;
      series_data.OBR_MUL:=OBR_MUL;
      series_data.mnozitel:=mnozitel;
      series_data.sum_data:=sum_data;
        //-----------------------------------------
     S := FloatToStr(D_Double(Addr+$278));   // начало оси X
     MIN_XX:=StrToInt(S);
     S := FloatToStr(D_Double(Addr+$280));   // конец  оси X
     MAX_XX:=StrToInt(S);
     StepX := (D_Double(Addr+$280) - D_Double(Addr+$278))/ (toX - 1);
     S := FloatToStr(D_Double(Addr+$29A));   // начало оси Y
    // label11.Caption:='начало оси Y = ' + S;
     Min_X:=D_Double(Addr+$29A);
     S := FloatToStr(D_Double(Addr+$2A2));   // конец  оси Y
    // label12.Caption:='конец  оси Y = ' + s;
     Max_X:=D_Double(Addr+$2A2);
     //StepY:=D_Double(Addr+$2C8)/D_Double(Addr+$2B0);
     if TOX > 0 then
     STEP_X:=(Max_X-Min_X) / (TOX-1);
     //Form1.Chart1.BottomAxis.Increment := StepX;             // шаг по оси X
        //---------------------------------
       if mainform.MapName = 'j7esa_v0.4.1.j7' then begin
        if addr_temp = $F571 then LoadOcY := '!004-5EF2-5EF4' ;
       end;

  //---------------- 1 ищем адрес начала последовательности байт
  if (LoadOcY = '!004-5EF2-5EF4') or(LoadOcY = '!003-5EF2-5EF4') then begin

  for n := 0 to length(mainform.data_map) - 1 do begin
    if (mainform.data_map[n] = $4C) and (mainform.data_map[n+1] = $A5) and (mainform.data_map[n+2] = $A6) and (mainform.data_map[n+3] = $28) then  begin
     obr_mul:=(D_Double(n+$43 - $4 ));
     obr_mul  :=strtofloat( StringReplace(floattostr(obr_mul), ',', '',[rfReplaceAll, rfIgnoreCase]));
    // label10.Caption:=floattostr(obr_mul);
     firmware.GetDadAxis($5EF2,$5EF3,$5EF4,round(obr_mul));
     firmware.GetDadAxis_x32($5EF2,$5EF3,$5EF4,round(obr_mul));
     break;
    end;
   end;
  end;
  //---------------------------------------
   if LoadOcY = '!004-6064-6066' then firmware.GetGBCAxis;
        //----------------------------------
        if (LoadOcY = '!004-5EF2-5EF4') or (LoadOcY = '!003-5EF2-5EF4')  then begin
         series_data.Table_dad:=true;
         series_data.Table_Tps:=False;
         series_data.Table_BCN:=False;
        end;
        if (LoadOcY = '!006-7208')  then begin
         series_data.Table_dad:=false;
         series_data.Table_Tps:=true;
         series_data.Table_BCN:=False;
        end;
        if (LoadOcY = '!004-6064-6066') then begin
         series_data.Table_dad:=false;
         series_data.Table_Tps:=False;
         series_data.Table_BCN:=true;
        end;
 //------------------------------------------------------------
        sg_olt.ColCount:=tox+1;
        sg_olt.RowCount:=toy+1;
        series_data.RPM_COUNT:=TOX;
        series_data.Load_Count:=Toy;
        firmware.GetTable(SG_OLT,addrCalib,delitel,mnozitel,tox*toy-1,sum);
        for n := 1 to sg_olt.ColCount - 1 do begin
        if (nAMEocX = '!001-613C-40') or (nAMEocX = '!002-613C-40') or (nAMEocX = '!001-613C-30') or (nAMEocX = '!002-613C-30')
        then begin
         if sg_olt.ColCount = 17 then sg_olt.Cells[n,0]:=inttostr(firmware.FRPMAxis[n]);
         if sg_olt.ColCount = 33 then sg_olt.Cells[n,0]:=inttostr(firmware.FRPMAxis_32[n]);
         end else begin
           if sg_olt.ColCount = 17 then sg_olt.Cells[n,0]:=FloatToStr(MIN_XX+round((N-1)*stepX));
         end;
        end;
        for n := 1 to sg_olt.RowCount - 1 do begin
        ///***** ось на 16
          if sg_olt.RowCount = 17 then begin
          if not (LoadOcY = '!004-5EF2-5EF4') and
             not (LoadOcY = '!006-7208')      and
             not (LoadOcY = '!004-6064-6066') then
               if MIN_X<>0 then sg_olt.Cells[0,n]:=floattostr(min_X+round((n-1)*STEP_X));
           if LoadOcY = '!004-5EF2-5EF4' then sg_olt.Cells[0,n]:=IntToStr(firmware.FDADAxis[n]);
           if LoadOcY = '!006-7208'      then sg_olt.Cells[0,n]:=IntToStr(firmware.FThrottleAxis[n]);
           if LoadOcY = '!004-6064-6066' then sg_olt.Cells[0,n]:=IntToStr(firmware.FBCNAxis[n]);

          end;
          //**** ось на 32
          if sg_olt.rowCount = 33 then begin
           if MIN_X<>0 then sg_olt.Cells[0,n]:=floattostr(min_X+round((n-1)*STEP_X));
           if LoadOcY = '!004-5EF2-5EF4' then sg_olt.Cells[0,n]:=IntToStr(firmware.FdadAxis_32[n]);
           if LoadOcY = '!003-5EF2-5EF4' then sg_olt.Cells[0,n]:=IntToStr(firmware.FdadAxis_32[n]);
           if LoadOcY = '!006-7208'      then sg_olt.Cells[0,n]:=IntToStr(firmware.FThrottleAxis_32[n]);
           if LoadOcY = '!004-6064-6066' then sg_olt.Cells[0,n]:=IntToStr(firmware.FBCNAxis[n]);
          end;
        end;
        sg_olt.Visible:=true;
      end;
//------------------------------//********  // график '1D' ******************------------------
//--------------------------------------------------------------------------------------------
      3:begin
       panel2.Visible:=false;
       panel3.Visible:=true;
       Panel_2D.Visible:=False;
       S:=''; for n := Addr+1 to Addr+mainform.data_map[Addr] do S:=S + chr(mainform.data_map[n]);
       label15.Caption:=cp1252tocp1251(S);
      inc(addr,$45);
      //----------------------
      S:='';
      for n := Addr+$11 to Addr+$11-1 +mainform.data_map[Addr+$10] do S:=S+chr(mainform.data_map[n]);
	    label15.Caption :=label15.Caption+ ' ( ' +cp1252tocp1251(S)+' ) ';//форма измерения
      //-----------------
      //адрес тарировки
      addrCalib:=D_Word(Addr+$4, true );
      //обратный мультипликат
      S:=FloatToStr(D_Double(Addr+$43));

     case mainform.data_map[Addr+$31] of    // определение типа таритовки
     0: begin Ymn:=0; Ymx:=255; end;        // беззнаковый байт (0-255)
     1: begin Ymn:=-128; Ymx:=127; end;     // знаковый байт (-128 +127)
     2: begin Ymn:=0; Ymx:=65535; end;      // беззаковое слово, сначала младший потом старший.
     3: begin Ymn:=-32768; Ymx:=32767; end; // знаковое слово, сначала младший потом старший.
     4: begin Ymn:=0; Ymx:=65535; end;      // беззнаковое слово, сначала старший потом младший.
     5: begin Ymn:=-32768; Ymx:=32767; end; // знаковое слово, сначала старший потом младший.
     6: begin Ymn:=0; Ymx:=65535; end;      // беззнаковое слово. Младший mod 65535 cтарший...
      else begin Ymn:=0; Ymx:=255; end;     // беззнаковый байт (0-255)
     end;
     if D_Double(Addr+$43) = 0 then
      begin
       StepY:=D_Double(Addr+$4B)/D_Double(Addr+$33);
       min_x := (Ymn - D_Double(Addr+$53)) * StepY - D_Double(Addr+$3B);
       max_x := (Ymx - D_Double(Addr+$53)) * StepY - D_Double(Addr+$3B);
      end
     else
      begin
        min_x := 0;
		    max_x := D_Double(Addr+$43);
      end;
      panel4.Caption:=floattostr(max_x);
      panel6.Caption:=floattostr(min_x);
      s:=IntToHex(mainform.data_map[Addr+$64],2) + IntToHex(mainform.data_map[Addr+$63],2);
     delitel := D_Double(Addr+$33);  // Делитель для шага
     sum := D_Double(Addr+$3B);  // смещение ...
     OBR_MUL := D_Double(Addr+$43);  //обратный мультипликативный
     mnozitel:= D_Double(Addr+$4B);  // Шаг...
     sum_data := -D_Double(Addr+$53); // смещение ...
     series_data.addr:=addrcalib;
     series_data.type_calib:=mainform.data_map[Addr+$31];
     series_data.delitel:=delitel;
     series_data.sum:=sum;
     series_data.sum_data:=sum_data;
     series_data.OBR_MUL:=OBR_MUL;
     series_data.mnozitel:=mnozitel;
 //-------------- проверяем тип калибровки
     case mainform.data_map[Addr+$31] of
      0,1:begin
       series_data.value_count:=1;
      end;
     2,3,4,5:begin
       series_data.value_count:=2;
      end;
     end;
     //--------------------------------------------------------------------------------------
    S:='';
    s:=FloatToStr( firmware.ReadvalueData_1D(mainform.data_map[Addr+$31],addrcalib,OBR_MUL,delitel,mnozitel,sum,sum_data));
     panel5.Caption:=' ' + S;
      mainform.RzProgressBar2.Percent:=round((StrToFloat(s) - min_X)/(max_x-min_x)*100);
      end;
     //********   флаги   *********************
      4:begin
if not Assigned(flag_panel) then begin
  flag_panel:=Tpanel.Create(self);
end;
      end;
     //*********   иденты    **********************
      5:begin

      end;
     //****************************
    end;


   end;
   //*****
   mainform.Resizetab_OLT;
end;


procedure TMainForm.AFR1Click(Sender: TObject);
begin
afr_data.Addr:=series_data.addr;
afr_data.dad:=series_data.Table_dad;
afr_data.load_count:=series_data.Load_Count;
afr_data.TPS:=series_data.Table_Tps;
afr_data.RPM_count:=series_data.RPM_COUNT;
afr_data.bcn:=series_data.Table_bcn;
afr_data.Сount:=afr_data.load_count*afr_data.RPM_count - 1;
afr_data.mnozitel:=round(series_data.mnozitel);
firmware.GetTable(SG_AFR,afr_data.Addr,256,14.7,afr_data.Сount,128);
end;



procedure TMainForm.Button10Click(Sender: TObject);
var
Ini: TIniFile;
FileName: string;
begin
//определяем путь файла
  FileName := ExtractFilePath( Application.ExeName ) + 'Settings.ini';
    //создание обьекта
  Ini := TIniFile.Create( FileName );
  //strtofloat( StringReplace(floattostr(obr_mul), ',', '',[rfReplaceAll, rfIgnoreCase]));
  //запись данных
  ini.WriteFloat( 'Speed' , 'SP3' ,StrToFloat(panel10.Caption));
  SP3:=StrToFloat(panel10.Caption);
   //удаление обьекта
  Ini.Free;
end;

procedure TMainForm.Button11Click(Sender: TObject);
var
Ini: TIniFile;
FileName: string;
begin
//определяем путь файла
  FileName := ExtractFilePath( Application.ExeName ) + 'Settings.ini';
    //создание обьекта
  Ini := TIniFile.Create( FileName );
  //запись данных
  ini.WriteFloat( 'Speed' , 'SP4' ,StrToFloat(panel10.Caption));
  SP4:=StrToFloat(panel10.Caption);
   //удаление обьекта
  Ini.Free;
end;

procedure TMainForm.Button12Click(Sender: TObject);
var
Ini: TIniFile;
FileName: string;
begin
//определяем путь файла
  FileName := ExtractFilePath( Application.ExeName ) + 'Settings.ini';
    //создание обьекта
  Ini := TIniFile.Create( FileName );
  //запись данных
  ini.WriteFloat( 'Speed' , 'SP5' ,StrToFloat(panel10.Caption));
  SP5:=StrToFloat(panel10.Caption);
   //удаление обьекта
  Ini.Free;
end;

procedure TMainForm.Button13Click(Sender: TObject);
var
Ini: TIniFile;
FileName: string;
begin
//определяем путь файла
  FileName := ExtractFilePath( Application.ExeName ) + 'Settings.ini';
    //создание обьекта
  Ini := TIniFile.Create( FileName );
  //запись данных
  ini.WriteFloat( 'Speed' , 'SP6' ,StrToFloat(panel10.Caption));
  SP6:=StrToFloat(panel10.Caption);
   //удаление обьекта
  Ini.Free;
end;

procedure TMainForm.Button14Click(Sender: TObject);
var
 KMM1,KMM2,integr:real;
 JFRXX,JFRXX1,JFRXX2:integer;
begin
//JFRXX1 = JUFRXX + KMM1 * JUFRXX
//JFRXX2 = JFRXX1 + KMM2  * JFRXX1
//KMM1 = ( JFRXX1 - JUFRXX ) / JUFRXX
//KMM2 = ( JFRXX2 - JUFRXX1 ) / JUFRXX1
if edit6.Text <> '' then
  if edit7.Text <>'' then
   if edit8.Text <>'' then  begin
    JFRXX:=StrToInt(edit6.Text);
    JFRXX1:=StrToInt(edit7.Text);
    JFRXX2:=StrToInt(edit8.Text);
    KMM1:= ( JFRXX1 - JFRXX ) / JFRXX;
    KMM2:= ( JFRXX2 - JFRXX1 ) / JFRXX1;
    integr:=(JFRXX1 - JFRXX ) * 2 / 3;
    panel15.Caption:=FormatFloat('#0.##0', KMM1);
    panel16.Caption:=FormatFloat('#0.##0', KMM2);
    panel17.Caption:=FormatFloat('#0.##0', integr);
   end;

end;

procedure TMainForm.Button15Click(Sender: TObject);
var
da:integer;
i:integer;
addr:integer;
begin
da:=0;
addr:=strtoint('$' + edit13.Text);
 for I := 1 to length( edit11.Text) do
  da:=da+ord(edit11.Text[i]);
  da:=da xor addr  ;
  edit12.Text:=inttohex(da,8);
end;

procedure TMainForm.Button16Click(Sender: TObject);
begin
label42.Caption:=Floattostr(obdii.FsensorTPSVoltage);
end;

procedure TMainForm.Button17Click(Sender: TObject);
begin
label46.Caption:=floattostr(100/(obdii.FsensorTPSVoltage - strtofloat(label42.Caption)));
end;



procedure TMainForm.Button1Click(Sender: TObject);
var
S:string;
//I:integer;
begin
if not checkbox2.Checked then  begin

if not self.FOBDIIConnected then  begin
  showmessage('Связь не установлена');
  exit;
end;
if not self.LoadFirmware then begin
  showmessage('Сперва загрузите прошивку');
  exit;
end;

if educationthread.Flag then begin
 showmessage('Сперва остановите обучение');
 exit;
end;
if obdii.FlagRewraiteTableOLT then exit;
end;

 if series_data.value_count = 1 then begin
 if firmware.FFirmwareData[series_data.addr] < 255 then begin
  if RB1.Checked then
   inc(firmware.FFirmwareData[series_data.addr],1);
  if (RB2.Checked) and (firmware.FFirmwareData[series_data.addr] < 245) then
   inc(firmware.FFirmwareData[series_data.addr],10);
  if (RB3.Checked) and (firmware.FFirmwareData[series_data.addr] < 205) then
   inc(firmware.FFirmwareData[series_data.addr],50);
 end;
 end;

 if series_data.value_count = 2 then begin
  if firmware.FFirmwareData[series_data.addr + 1] < 255 then
  inc(firmware.FFirmwareData[series_data.addr + 1],1) else begin
    if firmware.FFirmwareData[series_data.addr] < 255 then begin
     inc(firmware.FFirmwareData[series_data.addr],1);
     firmware.FFirmwareData[series_data.addr + 1]:=0;
    end;
  end;
 end;
    S:='';
    s:=FloatToStr( firmware.ReadvalueData_1D(series_data.type_calib,series_data.addr,series_data.OBR_MUL,series_data.delitel,series_data.mnozitel,series_data.sum,series_data.sum_data));
    panel5.Caption:=' ' + S;
    if not checkbox2.Checked then
    ReWraiTeOLT;
end;

procedure TMainForm.Button2Click(Sender: TObject);
var
S:string;
begin
if not self.FOBDIIConnected then  begin
  showmessage('Связь не установлена');
  exit;
end;
if not self.LoadFirmware then begin
  showmessage('Сперва загрузите прошивку');
  exit;
end;

if educationthread.Flag then begin
 showmessage('Сперва остановите обучение');
 exit;
end;
if obdii.FlagRewraiteTableOLT then exit;

 if series_data.value_count = 1 then begin
 if firmware.FFirmwareData[series_data.addr] > 0 then begin
 if RB1.Checked then
   inc(firmware.FFirmwareData[series_data.addr],-1);
  if (RB2.Checked) and (firmware.FFirmwareData[series_data.addr] > 10) then
   inc(firmware.FFirmwareData[series_data.addr],-10);
  if (RB3.Checked) and (firmware.FFirmwareData[series_data.addr] > 50) then
   inc(firmware.FFirmwareData[series_data.addr],-50);
 end;
 end;

 if series_data.value_count = 2 then begin
  if firmware.FFirmwareData[series_data.addr + 1] > 0  then
  inc(firmware.FFirmwareData[series_data.addr + 1],- 1) else begin
    if firmware.FFirmwareData[series_data.addr] > 0 then begin
     inc(firmware.FFirmwareData[series_data.addr],-1);
     firmware.FFirmwareData[series_data.addr + 1]:=255;
    end;
  end;
 end;
    S:='';
    s:=FloatToStr( firmware.ReadvalueData_1D(series_data.type_calib,series_data.addr,series_data.OBR_MUL,series_data.delitel,series_data.mnozitel,series_data.sum,series_data.sum_data));
    panel5.Caption:=' ' + S;
    ReWraiTeOLT;
end;

procedure TMainForm.Button3Click(Sender: TObject);
begin
chart2.Series[0].Clear;
chart3.Series[0].Clear;

FstartPower:=true;
Fpower:=False;
PowerValue:=0;
MIN_RPM_VAL:=StrToInt(edit1.Text);//начало оборотов разгона
MAX_RPM_VAL:=StrToInt(edit2.Text);//конец оборотов разгона
button3.Enabled:=False;
end;

procedure TMainForm.Button4Click(Sender: TObject);
begin
obdii.DATA_IO[0]:=obdii.IO_DATA[combobox4.ItemIndex].ID;
obdii.DATA_IO[1]:=0;
OBDII.FlagWriteIO:=True;
if not obdii.IO_DATA[combobox4.ItemIndex].Status then
trackbar1.Enabled:=False;
button4.Enabled:=False;
button5.Enabled:=True;
end;

procedure TMainForm.Button5Click(Sender: TObject);
begin
setlength(obdii.DATA_IO,2);
obdii.DATA_IO[0]:=obdii.IO_DATA[combobox4.ItemIndex].ID;
obdii.DATA_IO[1]:=$01;
OBDII.FlagWriteIO:=True;
end;

procedure TMainForm.Button6Click(Sender: TObject);
var
i:integer;
begin
setlength(obdii.DATA_IO,2);
obdii.DATA_IO[0]:=obdii.IO_DATA[combobox5.ItemIndex + 3].ID;
obdii.DATA_IO[1]:=$01;
obdii.FlagWriteIO:=true;
if checkbox1.Checked then i:=100 else I:=1;
for I := 1 to I do
if obdii.IO_DATA[combobox5.ItemIndex + 3].Status then begin
  Application.ProcessMessages;
  setlength(obdii.DATA_IO,3);
  obdii.DATA_IO[0]:=obdii.IO_DATA[combobox5.ItemIndex + 3].ID;
  obdii.DATA_IO[1]:=$06;
  obdii.DATA_IO[2]:=$01;
  obdii.FlagWriteIO:=true;
  if not checkbox1.Checked then break;
end;
end;

procedure TMainForm.Button7Click(Sender: TObject);
begin
setlength(obdii.DATA_IO,3);
obdii.DATA_IO[0]:=obdii.IO_DATA[combobox5.ItemIndex + 3].ID;
obdii.DATA_IO[1]:=$06;
obdii.DATA_IO[2]:=$00;
obdii.FlagWriteIO:=true;
setlength(obdii.DATA_IO,2);
obdii.DATA_IO[0]:=obdii.IO_DATA[combobox5.ItemIndex + 3].ID;
obdii.DATA_IO[1]:=$00;
obdii.FlagWriteIO:=true;
end;


procedure TMainForm.Button8Click(Sender: TObject);
var
Ini: TIniFile;
FileName: string;
begin
//определяем путь файла
  FileName := ExtractFilePath( Application.ExeName ) + 'Settings.ini';
    //создание обьекта
  Ini := TIniFile.Create( FileName );
  //запись данных
  ini.WriteFloat( 'Speed' , 'SP1' ,StrToFloat(panel10.Caption));
  SP1:=StrToFloat(panel10.Caption);
   //удаление обьекта
  Ini.Free;
end;

procedure TMainForm.Button9Click(Sender: TObject);
var
Ini: TIniFile;
FileName: string;
begin
//определяем путь файла
  FileName := ExtractFilePath( Application.ExeName ) + 'Settings.ini';
    //создание обьекта
  Ini := TIniFile.Create( FileName );
  //запись данных
  ini.WriteFloat( 'Speed' , 'SP2' , StrToFloat(panel10.Caption));
  SP2:=StrToFloat(panel10.Caption);
   //удаление обьекта
  Ini.Free;
end;

procedure Tmainform.ReWraiTeOLT;
var
i:integer;
begin
setlength(obdii.TableOLT,series_data.value_count);
   for I := 1 to series_data.value_count do obdii.TableOLT[i-1]:=firmware.FFirmwareData[series_data.addr + i - 1];
    obdii.StartAddrTableOLT:=series_DATA.addr;
    obdii.FlagRewraiteTableOLT:=true;
end;

procedure TMainForm.Chart1ClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

if not self.FOBDIIConnected then  begin
  showmessage('Связь не установлена');
  exit;
end;
if not self.LoadFirmware then begin
  showmessage('Сперва загрузите прошивку');
  exit;
end;

if educationthread.Flag then begin
 showmessage('Сперва остановите обучение');
 exit;
end;
if obdii.FlagRewraiteTableOLT then exit;

 series_data.value_index := valueindex;//записываем номер точки
 series_data.edit_data := true;//вешаем флаг что нужно тянуть точку
end;

procedure TMainForm.Chart1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
tmpX,tmpY:Double;
begin
if series_data.edit_data then  begin
 chart1.Repaint;
 //for i:=0 to 2{ch.SeriesCount-1} do begin
  series1.GetCursorValues(tmpX,tmpY); // переводим координаты из позиции курсора
  if (tmpY >= chart1.LeftAxis.Minimum) and (tmpY <= chart1.LeftAxis.Maximum) then
  series_data.data_val:=tmpY;
  series1.YValue[series_data.value_index]:= tmpY;
end;
end;

procedure TMainForm.Chart1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  var
  i:integer;
begin
if not series_data.edit_data then exit;
  //вешаем флаг что точку не тянем
  series_data.edit_data := false;
  //записываем значение в прошивку
  firmware.WriteValueData_1D(series_data.type_calib,series_data.addr+series_data.value_index,series_data.OBR_MUL,series_data.delitel,
  series_data.mnozitel,series_data.sum,series_data.sum_data,series_data.data_val);
  //отображаем значение в графике из прошивки
  series1.YValue[series_data.value_index]:= firmware.ReadvalueData_1D(series_data.type_calib,series_data.addr+series_data.value_index,series_data.OBR_MUL,
  series_data.delitel,series_data.mnozitel,series_data.sum,series_data.sum_data);
     SG_2d.Cells[series_data.value_index,1]:=FormatFloat( '#0.#0',firmware.ReadvalueData_1D(series_data.type_calib,series_data.addr+series_data.value_index,series_data.OBR_MUL,
  series_data.delitel,series_data.mnozitel,series_data.sum,series_data.sum_data));
 setlength(obdii.TableOLT,series_data.value_count);
 obdii.StartAddrTableOLT:=series_data.addr;
 for i := 0 to series_data.value_count - 1 do
   obdii.TableOLT[i]:=firmware.FFirmwareData[series_data.addr + i];
   obdii.FlagRewraiteTableOLT:=true;
end;

procedure TMainForm.CheckBCNClick(Sender: TObject);
begin
if CheckBCN.Checked then
 educationThread.educat_data.education_BCN_ON:=true
else
 educationThread.educat_data.education_BCN_ON:=false;
end;

procedure TMainForm.CheckFAZAClick(Sender: TObject);
begin
if Checkfaza.Checked then
 educationThread.educat_data.education_faza_ON:=true
else
 educationThread.educat_data.education_faza_ON:=false;
end;

procedure TMainForm.CheckPCNClick(Sender: TObject);
begin
if CheckPCN.Checked then
 educationThread.educat_data.education_PCN_ON:=true
else
 educationThread.educat_data.education_PCN_ON:=false;
end;

procedure TMainForm.ComboBox4Change(Sender: TObject);
begin
trackbar1.Enabled:=false;
if obdii.IO_DATA[combobox4.ItemIndex].Status then  begin
Trackbar1.Position:=obdii.IO_DATA[combobox4.ItemIndex].valid_value;
trackbar1.Enabled:=True;
button4.Enabled:=True;
end else begin
trackbar1.Enabled:=false;
button4.Enabled:=False;
button5.Enabled:=True;
end;
   if obdii.IO_DATA[combobox4.ItemIndex].ID = $49 then
    panel9.Caption:=FormatFloat('00.00',(obdii.IO_DATA[combobox4.ItemIndex].valid_value + 128 )*14.7/256) ;
   if obdii.IO_DATA[combobox4.ItemIndex].ID = $4A then
    panel9.Caption:=FloatToStr(obdii.IO_DATA[combobox4.ItemIndex].valid_value / 2);
   if obdii.IO_DATA[combobox4.ItemIndex].ID = $41 then
    panel9.Caption:=FloatToStr(obdii.IO_DATA[combobox4.ItemIndex].valid_value);
   if obdii.IO_DATA[combobox4.ItemIndex].ID = $4C then
    panel9.Caption:=FloatToStr(obdii.IO_DATA[combobox4.ItemIndex].valid_value);
end;

//------------- уст связи с эбу ---------
function TmainForm.connectToEcu():boolean;
var
i:integer;
begin
result:=False;
//**** 1 проверка и создание обьекта, если не существует
if not Assigned(obdii) then
  OBDII := TOBDII.Create( FComPort, FBaudRate, FBaudRate2, FDelayRate, false, false, 30 ) else begin
    obdii.Create( FComPort, FBaudRate, FBaudRate2, FDelayRate, false, false, 30 );
  end;

  if OBDII.RunThread then  begin
   if LoadFirmware then
    obdii.DIAG_DATA:=firmware.ReadSwidFirmware;
    if obdii.DIAG_DATA = 'D107'  then obdii.DIAG_DATA:='FB9C';
    if obdii.DIAG_DATA = 'D20F'  then obdii.DIAG_DATA:='FB9C';
    if obdii.DIAG_DATA = 'F6FC'  then obdii.DIAG_DATA:='FB9C';
    if obdii.DIAG_DATA = '1C2E'  then obdii.DIAG_DATA:='FB9C';
    if obdii.DIAG_DATA = '1C2F'  then obdii.DIAG_DATA:='FB9C';
    if obdii.DIAG_DATA = '28A7'  then obdii.DIAG_DATA:='FB9C';
    if obdii.DIAG_DATA = '28B8'  then obdii.DIAG_DATA:='FB9C';
    if obdii.DIAG_DATA = '384A'  then obdii.DIAG_DATA:='FB9C';
    if obdii.DIAG_DATA = '140F'  then obdii.DIAG_DATA:='FB9C';
    if obdii.DIAG_DATA = '391F'  then obdii.DIAG_DATA:='FB9C';
    if self.RadioButton4.Checked then obdii.DIAG_DATA:='FB9C';

  if OBDII.ConnectToECU then begin
 if not checkbox2.Checked then
  if LoadFirmware then begin
   setlength(obdii.TableFirmwareOlt,length(firmware.FFirmwareWriteOlt));
   for i := 0 to length(firmware.FFirmwareWriteOlt) - 1 do
    obdii.TableFirmwareOlt[i] := firmware.FFirmwareWriteOlt[i];
   obdii.FlagWriteFirmware := true;
  end;

  OBDII.Flag:=True;
  LC1:=TLcThreat.create(FcomPortLc,LamSensor); //номер порта, тип шдк
  FOBDIIConnected := true;
  rzglyphstatus1.Caption:='Подключено';
  rzglyphstatus1.ImageIndex:=0;
  result:=True;
   exit;
  end else
   begin
    FOBDIIConnected:=false;
    result:=False;
    obdII.Flag:=False;
    exit;
 end;
end;
end;
procedure TMainForm.CTE1Click(Sender: TObject);
begin
SaveCTEtab(SG_OLT,'OLT',series_data.ID);
end;

procedure TMainForm.CTE2Click(Sender: TObject);
begin
SaveCTEtab(sg_pc_gen,'OLT',PC_GEN.ID_CTE);
end;

procedure Tmainform.disconnect;
begin
memo1.Lines.Add('Отключение связи');
if not FOBDIIConnected then exit;
if educationthread.Run then educationthread.ExitThread;
 if OBDII.Stop then begin
  FOBDIIConnected := false;
  rzglyphstatus1.Caption:='Отключено';
  rzglyphstatus1.ImageIndex:=2;
 // GlyphConnect1.ImageIndex:=14;
 end else Showmessage('Ошибка связи, Порт закрыт');
  if LC1.RunThread then begin
  lc1.ExitReadPort:=True;
  sleep(300);
  if lc1.lc then
  Lc1.stop;
  end;
end;
PROCEDURE TMAINFORM.CONNECTECU;
var
i:integer;
begin
 Series3.Clear;
 series4.Clear;
if not LoadSettings then exit;
if FOBDIIConnected then exit;
memo1.Lines.Add('Установка связи с ЭБУ....');
if not connectToEcu then begin
  showmessage('ERROR CONNECT');
  memo1.Lines.Add('Связь с эбу не установлена');
  exit;
end;
memo1.Lines.Add('Связь с эбу установлена!');
timer1.Enabled:=True;
EducationThread:=TeducationThread.Create(1);
faza_data.IntOpen:=self.Intake_Open;
faza_data.IntClose:=Self.Intake_close;
faza_data.EXOP:=self.exhaust_open;
faza_data.EXCL:=self.exhaust_close;
faza_data.BoolWriteInj:=InjWrite;
 combobox4.Clear;
 combobox5.Clear;
 for i := 0 to 2 do
 combobox4.Items.Add(obdii.IO_DATA[i].Name);
 combobox4.Items.Add(obdii.IO_DATA[11].Name);
 combobox4.ItemIndex:=0;
 for i := 3 to 10 do
 combobox5.Items.Add(obdii.IO_DATA[i].Name);
 combobox5.ItemIndex:=0;
//combobox1.Items.Add()
end;
function TMainForm.LoadSettings():boolean;
var
  FileName: string;
  //FRM: TFormSettings;
  Ini: TIniFile;
  SW:string;
begin
 if LoadFirmware then SW:=firmware.ReadSwidFirmware;
 FileName := ExtractFilePath( Application.ExeName ) + 'settings.ini';
  if not FileExists( FileName ) then begin
    Application.MessageBox( 'Файл настроек отсутствует', 'Загрузка настроек', MB_ICONINFORMATION + MB_OK );
    Exit(false);
  end;
    Ini := TIniFile.Create( FileName );
    FcomPortLc := ini.ReadString('LC_1','Port','COM2');
    FComPort   := Ini.ReadString ('OBDII','Port','COM1');
    FBaudRate  := Ini.ReadInteger('OBDII','BaudRate1nd',10400);
    FBaudRate2 := Ini.ReadInteger('OBDII','BaudRate2nd',10400);
    FDelayRate := Ini.ReadInteger('OBDII','DelayRate',200);
    Lamsensor  := Ini.ReadString('LC_1', 'LamSensor', 'LC_1');
    MapName    := ini.ReadString(SW,'MapName','ERROR');

    RZSPINEDIT1.Value:=Ini.ReadInteger('educate','TWAT',60);
    RZSPINEDIT2.Value:=Ini.ReadInteger('educate','TPS',1);
    RZSPINEDIT4.Value:=Ini.ReadInteger('educate','SLEEP',300);
    RZSPINEDIT5.Value:=Ini.ReadInteger('educate','TOCHNAYA',1);
    RZSPINEDIT6.Value:=Ini.ReadInteger('educate','RT_PERCENT',30);
    RZSPINEDIT7.Value:=Ini.ReadInteger('educate','COUNT',12);

    //if (firmware.FdadNaklon = 0) and (firmware.FdadSMeshenie = 0) then begin
     Naklo:=ini.ReadFloat('OBDII','NaklonDAD',50);
     SW:= ini.ReadString('OBDII','SmeshenieDAD','0');

     smeshen:=StrToFloat(stringreplace(SW,self.type_razdelitel_error,self.type_razdelitel_ok,[rfReplaceAll, rfIgnoreCase]));
   // end;
   Intake_Open := ini.ReadInteger('Faza','Intake Open',35);
   Intake_close := ini.ReadInteger('Faza','Intake Close',35);

   exhaust_open := ini.ReadInteger('Faza','exhaust Open',120);
   exhaust_close := ini.ReadInteger('Faza','exhaust Close',370);

   InjWrite:= ini.ReadBool('Faza','Send open(0)/close(1)',true);

   SP1:=ini.ReadFloat('Speed','SP1',4);
   SP2:=ini.ReadFloat('Speed','SP2',7);
   SP3:=ini.ReadFloat('Speed','SP3',12);
   SP4:=ini.ReadFloat('Speed','SP4',17);
   SP5:=ini.ReadFloat('Speed','SP5',20);
   SP6:=ini.ReadFloat('Speed','SP6',22);
 //--------------
    Exit(true);
end;


procedure TMainForm.RadioButton1Click(Sender: TObject);
begin
EducationThread.educat_data.education_BCN:=True;
end;

procedure TMainForm.RadioButton2Click(Sender: TObject);
begin
EducationThread.educat_data.education_BCN:=True;
end;

procedure TMainForm.RadioButton3Click(Sender: TObject);
begin
if OBDII.RunThread then
 obdii.DIAG_DATA:='';
end;

procedure TMainForm.RadioButton4Click(Sender: TObject);
begin
if obdii.RunThread then
OBDII.DIAG_DATA:='FB9C';
end;

procedure Tmainform.ReloadDiagData;
function gen_AT(min_rt:integer; RT:integer;MAX_rt:integer; val_min:integer;val_max:integer):integer;
begin
 result:=round(val_min+((rt-min_rt)/(max_rt-min_rt))*(val_max-val_min));
end;
var
i:integer;
uskor:integer;
avg_adc_knock :real;
t1,t2,t0:integer;
begin

try
timer4.Enabled:=False;
sleep(1);
 OBDII.Time_Diag:=STRTOFLOAT(FormatFloat('####.00',OBDII.Time_Diag+(OBDII.Time_T / 100)));
  OBDII.Time_T:=0;
  TIMER4.Enabled:=TRUE;
  if CHECKBOX4.Checked then obdii.FsensorFuelTimeCorrection_wbl:=true else
  obdii.FsensorFuelTimeCorrection_wbl:=false;

// отображаем диагностические данные с эбу
  panel_rpm.Caption:=floattostr(obdii.ReadDiagData(combobox2.ItemIndex));
  panel_tps.Caption:=floattostr(obdii.FsensorThrottlePosition);
  label44.Caption:=floattostr(obdii.FsensorThrottlePosition);
  panel_dad.Caption:=floattostr(obdii.FsensorPressure);
  Panel_twat.Caption:=floattostr(obdii.FsensorCoolantTemp);
  panel_tair.Caption:=floattostr(obdii.FsensorTAIR);
  panel_coeff.Caption:=floattostr(obdii.FsensorFuelTimeCorrection);
  panel_afr.Caption:=floattostr(obdii.FsensorAirFuelRatio);
  Panel_GBC.Caption:=floattoSTR(obdii.FsensorAirCycleRate);
  Panel_Inj.Caption:=floattostr(obdii.ReadDiagData(combobox3.ItemIndex));
  if obdii.FsensotKNOCkVoltage - obdii.Fsensor_AVG_ADC_KNOCK  > 1.3 then
  Panel_uoz.Color:=clred else   Panel_uoz.Color:=clblack;
  panel_uoz.Caption:=FloatToStr(obdii.FsensorSparkAngle);
  if obdii.FsensorFuelTimeLength <= rzspinedit3.IntValue / 10 then
  Panel_Inj.Color:=clred else Panel_Inj.Color:=clblack;
  RzStatusPane4.Caption:='ERROR: ' + IntToStr(obdii.fsensorErrorCount);
  label40.Caption:=FormatFloat('###.##',obdii.KGBC_PIN);
  //---------отображение по фазе впрыска-----------------------
  panel12.Caption:=FormatFloat('###.##',obdii.FsensorFuelTimeLength);
  panel13.Caption:=FormatFloat('###.##',obdii.FsensorFasaGRAD);
  panel14.Caption:=FormatFloat('###.##',obdii.FsensorGenFaza);
  //записываем положение рхх
  if obdii.FsensorThrottlePosition = 0 then
  sg_idle.Cells[obdii.fsensor_rpm_rt_32+2, 2]:=floattostr(obdii.FsensorIdleDoublePosition);
 // пишем ацп для построения графика
  hip_adc_series_table[obdii.fsensor_rpm_rt_32] := obdii.FsensotKNOCkVoltage;//ацп с дд для отображения графика
  //пишем значения ацп в табличку аттенюатора
  sg_hip_at.Cells[educationthread.educat_data.rpm_rt_30,2]:=FloatToStr(round(obdii.FsensotKNOCkVoltage*100)/100);
 //проверяем флаг настройки хипа
  if checkbox5.Checked then begin  //проверка флага настройки хипа
 //увеличиваем счётчик попадания
  inc(hip_[educationthread.educat_data.rpm_rt_30].cout_popad); //счётчик попаданий
 //присваиваем значение ацп в точке
  setlength( hip_[educationthread.educat_data.rpm_rt_30].
  hip_adc, length(hip_[educationthread.educat_data.rpm_rt_30].
  hip_adc)+1);
  hip_[educationthread.educat_data.rpm_rt_30].
  hip_adc[length(hip_[educationthread.educat_data.rpm_rt_30].
  hip_adc)-1]:=obdii.FsensotKNOCkVoltage;
//---------- перезапись усилителя хипа -------------------------
if hip_[educationthread.educat_data.rpm_rt_30].cout_popad >= SpinEdit2.Value then begin
  hip_[educationthread.educat_data.rpm_rt_30].cout_popad:=0;
avg_adc_knock:=0;
for i := 0 to length(hip_[educationthread.educat_data.rpm_rt_30].hip_adc)-1 do
avg_adc_knock:=avg_adc_knock+hip_[educationthread.educat_data.rpm_rt_30].hip_adc[i];
avg_adc_knock:=avg_adc_knock/length(hip_[educationthread.educat_data.rpm_rt_30].hip_adc);
//пишем попаданий с нормальным коэффициентом
if ( obdii.FsensotKNOCkVoltage > 1 ) and ( obdii.FsensotKNOCkVoltage < 2 ) then
inc(hip_[educationthread.educat_data.rpm_rt_30].count_popad_norm);
//чем выше аттенюатор, тем ниже ацп
//для увеличения ацп, нужно уменьшить аттенюатор
//old_perehod - TRUE ЗНАЧИТ ВЫСОКОЕ АЦП
//ЗДЕСЬ УВЕЛИЧИВАЕМ АТТЕНЮАТОР
  if obdii.FsensotKNOCkVoltage > 2 then  begin
   hip_[educationthread.educat_data.rpm_rt_30].count_popad_norm:=0;
  if not hip_[educationthread.educat_data.rpm_rt_30].old_perehod then begin
   dec(hip_[educationthread.educat_data.rpm_rt_30].increment_data);
   if hip_[educationthread.educat_data.rpm_rt_30].increment_data < 1 then
    hip_[educationthread.educat_data.rpm_rt_30].increment_data:=1;
  end;
  //если прошлое состояние было так же высокое, то увеличиваем значение изменения аттенюатора
  if hip_[educationthread.educat_data.rpm_rt_30].old_perehod then begin
   inc(hip_[educationthread.educat_data.rpm_rt_30].increment_data);
   if hip_[educationthread.educat_data.rpm_rt_30].increment_data > 10 then
    hip_[educationthread.educat_data.rpm_rt_30].increment_data:=10;
  end;
  hip_[educationthread.educat_data.rpm_rt_30].old_perehod:=true;  //говорим что высокое состояние
  hip_[educationthread.educat_data.rpm_rt_30].value_attenuator:=hip_[educationthread.educat_data.rpm_rt_30].value_attenuator+hip_[educationthread.educat_data.rpm_rt_30].increment_data;
  if hip_[educationthread.educat_data.rpm_rt_30].value_attenuator > 63 then
     hip_[educationthread.educat_data.rpm_rt_30].value_attenuator:=63;
  end;
//здесь нужно аттенюатор УМЕНЬШИТЬ
  if obdii.FsensotKNOCkVoltage < 1 then begin
  hip_[educationthread.educat_data.rpm_rt_30].count_popad_norm:=0;
   if hip_[educationthread.educat_data.rpm_rt_30].old_perehod then begin
    dec(hip_[educationthread.educat_data.rpm_rt_30].increment_data);
   if hip_[educationthread.educat_data.rpm_rt_30].increment_data < 1 then
    hip_[educationthread.educat_data.rpm_rt_30].increment_data:=1;
   end;
   if not hip_[educationthread.educat_data.rpm_rt_30].old_perehod then begin
    inc(hip_[educationthread.educat_data.rpm_rt_30].increment_data);
   if hip_[educationthread.educat_data.rpm_rt_30].increment_data > 10 then
    hip_[educationthread.educat_data.rpm_rt_30].increment_data:=10;
   end;

   hip_[educationthread.educat_data.rpm_rt_30].old_perehod := false;
   hip_[educationthread.educat_data.rpm_rt_30].value_attenuator:=hip_[educationthread.educat_data.rpm_rt_30].value_attenuator-hip_[educationthread.educat_data.rpm_rt_30].increment_data;
   if hip_[educationthread.educat_data.rpm_rt_30].value_attenuator < 1 then
     hip_[educationthread.educat_data.rpm_rt_30].value_attenuator:=1;
  end;

if not checkbox2.Checked then begin
 if obdii.FlagRewraiteTableOLT then exit;
 setlength(obdii.TableOLT,256);
 T1:=0;
 T2:=0;
 for i := 1 to 256 do begin
 //принять первый нормальный коэфф
 //принять второй нормальный коэфф
 if t1 = 0 then
  if hip_[i].count_popad_norm > 0 then t1:=i;
 if I > T1 then if T2 = 0 then if hip_[i].count_popad_norm > 0 then  t2:=i;
 if t1-t1 > 1 then begin
  for T0 := T1+1 to T2 - 1 do
  hip_[T0].value_attenuator:=gen_AT(T1,T0,T2,hip_[T1].value_attenuator,hip_[T2].value_attenuator);
  T1:=T2;
  T2:=0;
 end;
 firmware.FFirmwareData[i+hip_at.Addr - 1]:= hip_[i].value_attenuator;
 SG_hip_at.Cells[i,1]:=inttostr(firmware.FFirmwareData[hip_at.Addr+i-1]);
 obdii.TableOLT[i-1]:=firmware.FFirmwareData[i];
 end;
 SG_hip_at.Repaint;
 obdii.StartAddrTableOLT:=hip_at.Addr;
 obdii.FlagRewraiteTableOLT:=True;
end;

end;
//--------------------
   end;
///end расчёт усилителя дд
  //------------ отображение графига ацп дд -----------------------------------
{ if obdii.FsensorThrottlePosition > 20 then

 if series3.Count < 100 then begin
    Series3.AddXY(series3.Count+1,obdii.FsensotKNOCkVoltage,IntToStr(obdii.FsensorCrankshaftSpeed),clred);
    Series4.AddXY(series4.Count+1,obdii.Fsensor_AVG_ADC_KNOCK,IntToStr(series4.Count),clgreen);
    if chart4.Series[0].Count < 30 then  begin
    chart4.Series[0].AddXY(chart4.Series[0].Count+1,obdii.FsensorCrankshaftSpeed,IntToStr(chart4.Series[0].Count),clgreen);
    chart5.Series[0].AddXY(chart5.Series[0].Count+1,obdii.FsensorIdleDoublePosition,IntToStr(chart5.Series[0].Count),clgreen);
    chart6.Series[0].AddXY(chart6.Series[0].Count+1,obdii.FsensorSparkAngle,IntToStr(chart6.Series[0].Count),clgreen);
    end;
   //Fsensor_AVG_ADC_KNOCK
   end else begin

     for i := 0 to series3.Count - 1 do begin

      if I < series3.Count - 1  then begin
       series3.YValues[i]:=series3.YValues[i+1];
       series3.XValue[i]:= series3.XValue[i+1];
        end else begin
       series3.YValues[series3.Count - 1]:=obdii.FsensotKNOCkVoltage;
       series3.XValue[series3.Count - 1]:= obdii.FsensorCrankshaftSpeed;
       end;

      if I < series4.Count - 1  then
       series4.YValues[i]:=series4.YValues[i+1] else
       series4.YValues[series4.Count - 1]:=obdii.Fsensor_AVG_ADC_KNOCK;

      if i <= chart4.Series[0].Count then  begin

      if i < chart4.Series[0].Count then
       chart4.Series[0].YValues[i]:=chart4.Series[0].YValues[i+1] else
       chart4.Series[0].YValues[chart4.Series[0].Count - 1]:=obdii.FsensorCrankshaftSpeed;
      if i < chart5.Series[0].Count then
       chart5.Series[0].YValues[i]:=chart5.Series[0].YValues[i+1] else
       chart5.Series[0].YValues[chart5.Series[0].Count - 1]:=obdii.FsensorIdleDoublePosition;
      if i < chart6.Series[0].Count then
       chart6.Series[0].YValues[i]:=chart6.Series[0].YValues[i+1] else
       chart6.Series[0].YValues[chart6.Series[0].Count - 1]:=obdii.FsensorSparkAngle;

      end;

     end;

     series3.Repaint;
     series4.Repaint;
     chart4.Series[0].Repaint;
     chart5.Series[0].Repaint;
     chart6.Series[0].Repaint;
   end;
 }
//----------отображение номера передачи
if obdii.FsensorCarSpeed<>0 then begin
 panel10.Caption:=FormatFloat('##.##',obdii.FsensorCarSpeed*640/obdii.FsensorCrankshaftSpeed);

 if (obdii.FsensorCarSpeed*640/obdii.FsensorCrankshaftSpeed < SP1+(10*SP1/100)) and
 (obdii.FsensorCarSpeed*640/obdii.FsensorCrankshaftSpeed > SP1-(10*SP1/100)) then
 Panel11.Caption:='1';

 if (obdii.FsensorCarSpeed*640/obdii.FsensorCrankshaftSpeed < SP2+(10*SP2/100)) and
 (obdii.FsensorCarSpeed*640/obdii.FsensorCrankshaftSpeed > SP2-(10*SP2/100)) then
 Panel11.Caption:='2';

 if (obdii.FsensorCarSpeed*640/obdii.FsensorCrankshaftSpeed < SP3+(10*SP3/100)) and
 (obdii.FsensorCarSpeed*640/obdii.FsensorCrankshaftSpeed > SP3-(10*SP3/100)) then
 Panel11.Caption:='3';

 if (obdii.FsensorCarSpeed*640/obdii.FsensorCrankshaftSpeed < SP4+(10*SP4/100)) and
 (obdii.FsensorCarSpeed*640/obdii.FsensorCrankshaftSpeed > SP4-(10*SP4/100)) then
 Panel11.Caption:='4';

 if (obdii.FsensorCarSpeed*640/obdii.FsensorCrankshaftSpeed < SP5+(10*SP5/100)) and
 (obdii.FsensorCarSpeed*640/obdii.FsensorCrankshaftSpeed > SP5-(10*SP5/100)) then
 Panel11.Caption:='5';

 if (obdii.FsensorCarSpeed*640/obdii.FsensorCrankshaftSpeed < SP6+(10*SP6/100)) and
 (obdii.FsensorCarSpeed*640/obdii.FsensorCrankshaftSpeed > SP6-(10*SP6/100)) then
 Panel11.Caption:='6';
//-------------------------------------------------
 end else begin
  Panel10.Caption:='0';
  Panel11.Caption:='0';
end;


//----------------------------------------------------------------------------
  //if obdii.fsensorErrorCount > 0 then N9.Enabled:=true else N9.Enabled:=false;
  //---------- диагностика в новой вкладке
 panel7.Caption:=FloatToStr(obdii.ReadDiagData(ComboBox1.ItemIndex));
 panel8.Caption:=FloatToStr(obdii.uskor);
  // отобажаем данные с шдк
 if lc1.RunThread then begin
  panel_lc.Caption:=floattostr(lc1.AFR);
  if (lc1.AFR / OBDII.FsensorAirFuelRatio > 0.97) and (lc1.AFR / OBDII.FsensorAirFuelRatio <  1.03) then
   begin
    panel_lc.Color:=clgreen;
    panel_afr.Color:=clgreen;
   end else begin
    panel_lc.Color:=clblue;
    panel_afr.Color:=clblue;
   end;
  RzStatusPaneLC.Caption:=lc1.Message_LC1;
 end;
 if (educationthread.WorkX_PCN<>0) and (educationthread.WorkY_PCN<>0) then
 if not checkbox3.Checked then
 SG_coeff.Cells[educationthread.WorkX_PCN,educationthread.WorkY_PCN]:=FormatFloat('#0.##',obdii.FsensorFuelTimeCorrection) else
 SG_coeff.Cells[educationthread.WorkX_PCN,educationthread.WorkY_PCN]:=FormatFloat('#0.##',obdii.FsensorLamMdaVoltage_2);

 if (bcn_rt.RPM_RT <> educationthread.WorkX_bcn) or (bcn_rt.LOAD_RT <> educationthread.WorkY_bcn ) or (PCN_RT.RPM_RT <> educationthread.WorkX_PCN) or (pcn_rt.LOAD_RT <> educationthread.WorkY_PCN ) then
 begin
 SG_PCN.Repaint;
 SG_BCN.Repaint;
 SG_UOZ.Repaint;
 SG_AFR.Repaint;
 SG_OLT.Repaint;
 SG_FAZA.Repaint;
 sg_coeff.Repaint;
 PCN_RT.RPM_RT:=educationthread.WorkX_PCN;
 PCN_RT.LOAD_RT:=educationthread.WorkY_PCN;
 bcn_rt.RPM_RT:=educationthread.WorkX_bcn;
 bcn_rt.LOAD_RT:=educationthread.WorkY_bcn
 end;
 //запись разгона
 if FstartPower then begin
   if obdii.FsensorCrankshaftSpeed >= MIN_RPM_VAL then  begin
    Fpower:=True;
    Timer2.Enabled:=True;
    uskor:=round((obdii.FsensorCrankshaftSpeed - rpm_old) / (obdii.Time_Diag - InTimeOLD ) * 100);// div 1;// /100 ;
   // uskor:=uskor div 10;
    chart2.Series[0].AddXY(chart2.Series[0].Count+1,uskor/100,FloatToStr(obdii.FsensorCrankshaftSpeed));
    chart3.Series[0].AddXY(obdii.FsensorCrankshaftSpeed,obdii.FsensotKNOCkVoltage,'',clred);
   // label1.Caption:='Разгон =' + FloatToStr(PowerValue/100);
    if obdii.FsensorCrankshaftSpeed >= MAX_RPM_VAL then begin
     FstartPower:=False;
     Timer2.Enabled:=False;
    // label1.Caption:='Разгон =' + FloatToStr(PowerValue/100);
     button3.Enabled:=true;
    end;
   end else begin
    Fpower:=False;
    PowerValue:=0;
   end;
 end;
 RPM_OLD:=obdii.FsensorCrankshaftSpeed;
except
 memo1.Lines.Add('Возникла ошибка в перерисовке диагностических данных на форме');
end;

end;




procedure TMainForm.N10Click(Sender: TObject);
begin

{
if not self.FOBDIIConnected then  begin
  showmessage('Связь не установлена');
  exit;
end;
 }
if not self.LoadFirmware then begin
  showmessage('Сперва загрузите прошивку');
  exit;
end;
 {
if educationthread.Flag then begin
 showmessage('Сперва остановите обучение');
 exit;
end;
 }
//if obdii.FlagRewraiteTableOLT then exit;
if checkbox9.Checked then firmware.GeneratorUoz(true) else firmware.GeneratorUoz(false);
firmware.GetTable(SG_UOZ,uoz_data.Addr,uoz_data.delitel,uoz_data.mnozitel,uoz_data.Сount,0);
N12.Enabled:=True;
end;

procedure TMainForm.N11Click(Sender: TObject);
var
I:integer;
begin

if not self.FOBDIIConnected then  begin
  showmessage('Связь не установлена');
  exit;
end;
if not self.LoadFirmware then begin
  showmessage('Сперва загрузите прошивку');
  exit;
end;

if educationthread.Flag then begin
 showmessage('Сперва остановите обучение');
 exit;
end;
if obdii.FlagRewraiteTableOLT then exit;

 setlength(obdii.TableOLT,pcn_data.Сount + 1);
 for i := 0 to pcn_data.Сount do begin
  firmware.FFirmwareData[pcn_data.Addr + I]:=$80;
  obdii.TableOLT[i]:=$80;
 end;
  obdii.StartAddrTableOLT:=pcn_data.Addr;
  OBDii.FlagRewraiteTableOLT:=True;
  firmware.GetTable(SG_PCN,PCN_DATA.Addr,pcn_data.delitel,pcn_data.mnozitel,pcn_data.Сount,pcn_data.sum);
end;

procedure TMainForm.N12Click(Sender: TObject);
var
I:integer;
begin
if not self.FOBDIIConnected then  begin
  showmessage('Связь не установлена');
  exit;
end;

if not self.LoadFirmware then begin
  showmessage('Сперва загрузите прошивку');
  exit;
end;

if educationthread.Flag then begin
 showmessage('Сперва остановите обучение');
 exit;
end;

if obdii.FlagRewraiteTableOLT then exit;
setlength(obdii.TableOLT,uoz_data.Сount + 1);
for I := 0 to uoz_data.Сount do
 obdii.TableOLT[i]:=firmware.FFirmwareData[uoz_data.Addr + i];
 obdii.StartAddrTableOLT:=uoz_data.Addr;
 obdii.FlagRewraiteTableOLT:=true;
N12.Enabled:=False;
end;

procedure TMainForm.N13Click(Sender: TObject);
var
i:integer;
begin
if not self.FOBDIIConnected then  begin
  showmessage('Связь не установлена');
  exit;
end;

if not self.LoadFirmware then begin
  showmessage('Сперва загрузите прошивку');
  exit;
end;

if educationthread.Flag then begin
 showmessage('Сперва остановите обучение');
 exit;
end;

if obdii.FlagRewraiteTableOLT then exit;
if obdii.FlagWriteFirmware then begin
showmessage('Подождите, происходит запись памяти ОЛТ!');
exit;
end;

firmware.InterpolateTableBcn;
firmware.GetTable(SG_BCN,bcn_data.Addr,3,bcn_data.mnozitel,bcn_data.Сount,0);
setlength(obdii.TableOLT,0);
setlength(obdii.TableOLT,bcn_data.Сount + 1);
for i := 0 to bcn_data.Сount do
 obdii.TableOLT[i]:=firmware.FFirmwareData[bcn_data.Addr + i];
 obdii.StartAddrTableOLT:=bcn_data.Addr;
 obdii.FlagRewraiteTableOLT:=True;
end;

procedure TMainForm.N14Click(Sender: TObject);
begin
InterTable_X(SG_OLT,series_data.addr);
  firmware.GetTable(SG_OLT,series_data.addr,series_data.delitel,series_data.mnozitel,(sg_OLT.ColCount-1)*(sg_olt.RowCount-1)-1,series_data.sum);
  series_data.value_count:=(sg_olt.ColCount-1)*(sg_olt.RowCount - 1);
if not checkbox2.Checked then
  ReWraiTeOLT;
end;

procedure TMainForm.N15Click(Sender: TObject);
begin
 InterTable_Y(SG_OLT,series_data.addr);
 firmware.GetTable(SG_OLT,series_data.addr,series_data.delitel,series_data.mnozitel,(sg_OLT.ColCount-1)*(sg_olt.RowCount-1)-1,series_data.sum);
 series_data.value_count:=(sg_olt.ColCount-1)*(sg_olt.RowCount - 1);
if not checkbox2.Checked then ReWraiTeOLT;
end;

procedure TMainForm.N16Click(Sender: TObject);
var
i,t:integer;
begin
if assigned(educationThread)  then
  for i := 1 to 16 do
   for t := 1 to 16 do
    educationthread.educat_data.Table_Cnock[i,t]:=0;
end;

procedure TMainForm.N17Click(Sender: TObject);
begin
bcn_data.Addr:=series_data.addr;
bcn_data.dad:=series_data.Table_dad;
bcn_data.load_count:=series_data.Load_Count;
bcn_data.TPS:=series_data.Table_Tps;
bcn_data.RPM_count:=series_data.RPM_COUNT;
bcn_data.BCN:=series_data.Table_BCN;
bcn_data.Сount:=bcn_data.load_count*bcn_data.RPM_count - 1;
bcn_data.mnozitel:=round(series_data.mnozitel);
firmware.GetTable(SG_BCN,bcn_data.Addr,3,bcn_data.mnozitel,bcn_data.Сount,0);
end;

procedure TMainForm.N18Click(Sender: TObject);
begin
pcn_data.Addr:=series_data.addr;
pcn_data.dad:=series_data.Table_dad;
pcn_data.load_count:=series_data.Load_Count;
pcn_data.TPS:=series_data.Table_Tps;
pcn_data.RPM_count:=series_data.RPM_COUNT;
pcn_data.BCN:=series_data.Table_bcn;
pcn_data.Сount:=pcn_data.load_count*pcn_data.RPM_count - 1;
pcn_data.mnozitel:=round(series_data.mnozitel);
pcn_data.delitel:=round(series_data.delitel);
pcn_data.sum:=round(series_data.sum);
firmware.GetTable(SG_PCN,PCN_DATA.Addr,pcn_data.delitel,pcn_data.mnozitel,pcn_data.Сount,pcn_data.sum);
firmware.GetTable(SG_COEFF,PCN_DATA.Addr,128,1,pcn_data.Сount,0);
resizefo;
end;

procedure TMainForm.N19Click(Sender: TObject);
begin
uoz_data.Addr:=series_data.addr;
uoz_data.dad:=series_data.Table_dad;
uoz_data.load_count:=series_data.Load_Count;
uoz_data.TPS:=series_data.Table_Tps;
uoz_data.RPM_count:=series_data.RPM_COUNT;
uoz_data.bcn:=series_data.Table_bcn;
uoz_data.Сount:=uoz_data.load_count*uoz_data.RPM_count - 1;
uoz_data.mnozitel:=round(series_data.mnozitel);
uoz_data.delitel:=round(series_data.delitel);
firmware.GetTable(SG_UOZ,uoz_data.Addr,uoz_data.delitel,uoz_data.mnozitel,uoz_data.Сount,0);
end;

procedure TMainForm.N1Click(Sender: TObject);
BEGIN
CONNECTECU;
end;
procedure Tmainform.Reload_status(intake:integer; max:integer);
begin
if max > 0 then
mainform.RzProgressBar1.Percent:=round( (intake*100) div max) else
mainform.RzProgressBar1.Percent:=0;
Application.ProcessMessages;
end;

procedure TMainForm.N21Click(Sender: TObject);
var
i,t:integer;
begin
for  i := 1 to sg_coeff.ColCount do
   for t := 1 to sg_coeff.RowCount do
    sg_coeff.Cells[i,t]:='';
end;

procedure TMainForm.N22Click(Sender: TObject);
var
i:integer;
begin
 for i := sg_2d.Selection.Left to sg_2d.Selection.Right do begin
   firmware.FFirmwareData[series_data.addr+i]:=round(firmware.FFirmwareData[series_data.addr+sg_2d.Selection.Left]+
   (firmware.FFirmwareData[series_data.addr+sg_2d.Selection.Right]-firmware.FFirmwareData[series_data.addr+sg_2d.Selection.Left])*
   (i-sg_2d.Selection.Left)/(sg_2d.Selection.Right-sg_2d.Selection.Left));
 //перерисовка
 series_data.value_index:=i;
  series1.YValue[series_data.value_index]:= firmware.ReadvalueData_1D(series_data.type_calib,series_data.addr+series_data.value_index,series_data.OBR_MUL,
  series_data.delitel,series_data.mnozitel,series_data.sum,series_data.sum_data);
  SG_2d.Cells[i,1]:=FormatFloat( '#0.#0',firmware.ReadvalueData_1D(series_data.type_calib,series_data.addr+series_data.value_index,series_data.OBR_MUL,
  series_data.delitel,series_data.mnozitel,series_data.sum,series_data.sum_data));
 end;
 //записываем в эбу
 if FOBDIIConnected then begin
  setlength(obdii.TableOLT,series_data.value_count);
 obdii.StartAddrTableOLT:=series_data.addr;
 for i := 0 to series_data.value_count - 1 do
   obdii.TableOLT[i]:=firmware.FFirmwareData[series_data.addr + i];
   obdii.FlagRewraiteTableOLT:=true;
 end;
end;

procedure TMainForm.N23Click(Sender: TObject);
var
le,ri,topi,butti,i,t,RT,val:integer;
begin
Le:=sg_coeff.Selection.Left;
Ri:=sg_coeff.Selection.Right;
Topi:=sg_coeff.Selection.Top;
butti:=sg_coeff.Selection.Bottom;
for I := le to ri do
 for t := topi to butti do begin
  RT:=( t-1 )*pcn_data.load_count + i;
  val:=0;
  if sg_coeff.Cells[i,t] <> '' then   val:=round(strtofloat( sg_coeff.Cells[i,t] )*firmware.FFirmwareData[pcn_data.Addr+rt-1]);
  if val > 0 then  firmware.FFirmwareData[pcn_data.Addr+rt-1]:=val;
 end;
firmware.GetTable(SG_PCN,PCN_DATA.Addr,pcn_data.delitel,pcn_data.mnozitel,pcn_data.Сount,pcn_data.sum);
sg_pcn.Repaint;
RevratePcn_olt;
end;

procedure TMainForm.N2Click(Sender: TObject);
begin
disconnect;
end;

procedure TMainForm.N3Click(Sender: TObject);
var
  FRM: TFormSettings;
begin
  FRM := TFormSettings.Create( Self );
  FRM.ShowModal;
  self.LoadSettings;
end;

procedure TMainForm.N5Click(Sender: TObject);
begin
if (LoadFirmware) and (FOBDIIConnected) then begin
EducationThread.Start(ueducationthread.mCorrectinFilling);
self.RzGlyphStatus2.ImageIndex:=0;
N5.Enabled:=False;
n6.Enabled:=true;
educationThread.educat_data.education_Twat:=Rzspinedit1.IntValue;
educationThread.educat_data.education_tps:=Rzspinedit2.IntValue;
educationThread.educat_data.SleepStacionar:=Rzspinedit4.IntValue;
educationThread.FMaxEduCount:=RZspinedit7.IntValue;
educationThread.educat_data.EducationCoeffLow:=Rzspinedit5.IntValue;
educationThread.educat_data.TCOEFF:=Rzspinedit6.IntValue;

educationThread.educat_data.education_tps:=Rzspinedit2.IntValue;
educationThread.educat_data.education_tps_hi:=Rzspinedit8.IntValue;

educationThread.educat_data.education_rpm_lo:=Rzspinedit9.IntValue;
educationThread.educat_data.education_rpm_hi:=Rzspinedit10.IntValue;
if CheckBCN.Checked then
 educationThread.educat_data.education_BCN_ON:=true
else
 educationThread.educat_data.education_BCN_ON:=false;
if CheckPCN.Checked then
 educationThread.educat_data.education_PCN_ON:=true
else
 educationThread.educat_data.education_PCN_ON:=false;
if Checkfaza.Checked then
 educationThread.educat_data.education_faza_ON:=true
else
 educationThread.educat_data.education_faza_ON:=false;
 end else begin
  showmessage('Прошивка не Загружена или не установлена связь');
  self.RzGlyphStatus2.ImageIndex:=2;
 end;
end;

procedure TMainForm.N6Click(Sender: TObject);
begin
if educationthread.Run then begin
  if educationthread.Flag then
   educationthread.Flag:=false;
   //-----------
self.RzGlyphStatus2.ImageIndex:=2;
N5.Enabled:=True;
n6.Enabled:=False;
end;
end;

procedure TMainForm.N7Click(Sender: TObject);
var
I:Integer;
begin

if not self.LoadFirmware then begin
  showmessage('Сперва загрузите прошивку');
  exit;
end;

firmware.InterpolateTablePcn;
firmware.GetTable(SG_PCN,PCN_DATA.Addr,pcn_data.delitel,pcn_data.mnozitel,pcn_data.Сount,pcn_data.sum);;

if not self.FOBDIIConnected then  begin
  showmessage('Связь не установлена, перезапись ЭБУ не произойдёт!');
  exit;
end;

if educationthread.Flag then begin
 showmessage('Сперва остановите обучение');
 exit;
end;

if obdii.FlagRewraiteTableOLT then exit;
setlength(obdii.TableOLT,pcn_data.Сount + 1);
for i := pcn_data.Addr to pcn_data.Addr + pcn_data.Сount do
 obdii.TableOLT[i - pcn_data.Addr]:=firmware.FFirmwareData[i];
 obdii.StartAddrTableOLT:=pcn_data.Addr;
 obdii.FlagRewraiteTableOLT:=True;
end;

procedure TMainForm.N9Click(Sender: TObject);
begin
if FOBDIIConnected  then  begin
 obdii.Flag_Clear_Error:=True;
end;
end;
//-------------------------------------------------------------------------
procedure Tmainform.RevratePcn_olt;
var
i:integer;
begin
if not FOBDIIConnected then exit;
if obdii.FlagRewraiteTableOLT then exit;

setlength(obdii.TableOLT,pcn_data.Сount+1);
 for i := pcn_data.Addr to pcn_data.Addr+pcn_data.Сount + 1 do
  obdii.TableOLT[i-pcn_data.Addr]:=firmware.FFirmwareData[i];
  obdii.StartAddrTableOLT:=pcn_data.Addr;
  obdii.FlagRewraiteTableOLT:=True;
end;
//--------------------------------------------------------------------------
procedure TmainForm.RevraiteUoz_olt;
var
i:integer;
begin
if not FOBDIIConnected then exit;
setlength(obdii.TableOLT,uoz_data.Сount+1);
 for i := uoz_data.Addr to uoz_data.Addr+uoz_data.Сount + 1 do
  obdii.TableOLT[i-uoz_data.Addr]:=firmware.FFirmwareData[i];
  obdii.StartAddrTableOLT:=uoz_data.Addr;
  obdii.FlagRewraiteTableOLT:=True;
end;
procedure TmainForm.SaveCTEtab(TABLE: TStringGrid; NAME: string; ID: string);
var
i,t:integer;
Myfile:textfile;
begin
if savedialog1.Execute then begin
  AssignFile(Myfile,SaveDialog1.Filename);
  rewrite(myfile);
  Append(myfile);
   WriteLn(myFile,'['+ID+']');
   WriteLn(myFile,'Name = ' + NAME);
 for i := 1 to table.RowCount - 1 do
  for t := 1 to table.ColCount - 1 do
   WriteLn(myFile,'X'+IntToStr(T)+'Z'+IntToStr(I)+'='+TABLE.Cells[t,i]);
   closefile(myfile);
end;
end;
procedure Tmainform.Reload_IO;
begin
 if  obdii.IO_DATA[combobox4.ItemIndex].Status then begin
  trackbar1.Position:=obdii.IO_DATA[combobox4.ItemIndex].valid_value;
  trackbar1.Enabled:=True;
  button5.Enabled:=False;
  button4.Enabled:=true;
 end else begin
  trackbar1.Enabled:=false;
  button5.Enabled:=true;
  button4.Enabled:=false;
 end;
end;
PROCEDURE TMAINFORM.SAVESET;
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

  //создание обьекта
  Ini := TIniFile.Create( FileName );
  Ini.WriteInteger( 'educate', 'TWAT', RzSpinEdit1.IntValue );
  Ini.WriteInteger( 'educate', 'TPS', RzSpinEdit2.IntValue );
  Ini.WriteInteger( 'educate', 'SLEEP', RzSpinEdit4.IntValue );
  Ini.WriteInteger( 'educate', 'COUNT', RzSpinEdit7.IntValue );
  Ini.WriteInteger( 'educate', 'RT_PERCENT', RzSpinEdit6.IntValue );
  Ini.WriteInteger( 'educate', 'TOCHNAYA', RzSpinEdit5.IntValue );
  Ini.Free;
end;
end.
