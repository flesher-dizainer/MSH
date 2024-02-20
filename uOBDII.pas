unit uOBDII;

interface

uses
  Classes, Windows, Dialogs, SysUtils, Forms,uFirmware;

const
  sysDiag         = $F1;  // ����� ���������
  sysEngine       = $10;  // ����� ���
  sysByteClear    = $C0;  // ���� ��� �������� �������������� ������ ������ � OBD-���������
  SoftName        = '614';//---������ ���������----
//------- ���������� �� -----------------
  type
   TIOCONTROL = record
    Name:string;  //��� ����������
    ID:Byte;     //�� ���������� AFR($49)
    valid_value:integer;//������� ��������
    Status:boolean; //������ ����������, ��������� ��� ���
   end;
//-------- ����� ������ �� ��������� j7es ---------------------
  type
   TRec_RDBLI_J7ES = packed record
    Mode1,             //����� ������ ������ 1
    Mode2,             // ����� ������ ������ 2
    ErrCnt,            //����� �������������
    Err1,              //������� ������������� 1
    Err2,               //������� ������������� 2
    Err3,               //������� ������������� 3
    Err4,               //������� ������������� 4
    RPM_GBC_RT,         //�������� �����
    Twat,               //����
    ALF,                //����������� ������/�������
    DDSF,              // ����������� ��������� RCO
    THR,               //��������� ��������
    RPM40,             //������� ��� � ������������ �� 40
    RPM10: byte;      //�������� �������� ��������� �� �������� ����
    CycleTime: word;  //����� �����
    UFRXX,            //�������� ��������� ���
    SSM,              //������� ��������� ���
    COEFF,            //��������� ��������� ������� �������
    FAZA,              //���� �������
    UOZ,              //���
    KUOZ1,            // ��������� ��� �������� 1
    KUOZ2,
    KUOZ3,
    KUOZ4,
    ADCKNOCK,
    ADCMAF,
    ADCUBAT,
    ATIM,              // ��� RCO
    ADCTPS,
    ADCTWAT,
    ADCTAIR,
    ADCLAM1,            //��� ��
    DKState,            //����� ��������� ��
    SAS,                // �����-��������� (������� ��� �� �������� ��������)
    SPD,                //��������
    T_JUFRXX,           // �������� ������� ��
    Tair,               //����������� ������� �� ������
    ADCLAM: byte;       //��� ��
    DGTC_RICH,          // ���������� �� �������� ��������
    DGTC_LEAN,          // ��������� �� �������� ��������
    INJ,                 //������������ �������� �������
    AIR,                 //�������� ������ �������
    GBC,                 //�������� ����������
    FRH: word;           // ������� ������ �������
    //----����� �������� ����� ��������� ��� V1
    PRESS_RT,            //�������� ����� ��������
    Tcharge,             // ����������� ������
    TchargeCoeff,        // ����������� ��������� �� �� �������
    DUOZ,                // ����� ��������� ���
    LaunchFuelCutOff,    // ������� ���������� ������������� �� ������
    KGTC,                // ����������������� ��������� �������������
    coefficient_vibora_tcharge,//����������� ������ �������
    KnockFlags,
    MisFireFlags,
    KGBC_TPS,             //��� ��������
    KGBC_DAD,             // ��� ��� ���
    UOZ_TCORR,
    ALF_WBL,              // ALF � ��� ������������� � ��� �� ��� 75
    EGT,                  //���� �������� �� �� ��� ������
    JUFRXX,               // ������� �������� ��
    JFRXX1,               // ����� �������� 1 ����������� ������
    JFRXX2,               // ����� �������� 2 ����������� ������
    KINJ_AIRFREE,         // �����. ��������� ������� ������� �� ������ �������� �����-�������
    DUOZ_REGXX,           // �������� ��� ���������������� ����������� �������� ��
    DERR_RPM,             // ��������� ������ ��������
    DIUOZ,                // �������� ��� �� ������������ ����������� �������� ��
    DELAY_FUEL_CUTOFF,    // �������� ���������� �������������
    TLE_PIN_0_7,
    TLE_PIN_8_15,
    J7ES_EGT,        //����������� �� BOOST_ERROR. � ������ 075 ��� egt
    WGDC,                  //Wastegate Duty Cycle (WGDC)
    FAZA_J7,               //����
    UOZCORR_GTC,           //��������� ��� �� �������
    TIME_HIP9011,          //���������� ������� ����������� HIP9011
    number_shift,          //����� ��������
    TWAT_RT,
    RPM_RT,
    RPM_THR_RT,
    RAM_2A,                 //���������� ram_2a
    DELTA_RPM_XX,            // ������ ��������
    PXX_ZONE,                // ��������� ������� ���
    RAM_2D,                 //���������� RAM_2D
    StartFlags,


    UGB_RXX,
    DUOZ_LAUNCH,             // ������ ��� �� ������
    GBC_RT: byte;
    Knock,                   // ������� ���������
    FchargeGBC,              // �� ���
    FchargeGBCFin,           // ����������������� ��
    Press,                   // ��������
    DGTC_DadRich,            // ���������� �� ��������
    TARGET_BOOST: word;      //�������� �������
    avg_noise_hip:word;      //������� ������� ���� �� hip
    rpm_rt_32:byte;
  end;
//---------- ������ �� ������ -----------------
  type
 TDiagData = packed record
fSTOP,      //���� �������������� ���
fXX,        //���� ��������� ����
fPOW,      //���� ���������� ����������
fFUELOFF, //���� ���������� �������
fLAMREG,  //���� ���� ������������� �� ��
fDETZONE,//���� ��������� � ���� ���������
fADS,   //���� ���������� �������� ���������
fLEARN,//���� ���������� �������� �� ��

fXXPrev,//�������� ��� � ������� �����
fXXFix, //���������� ������ �� ��
fDET, //������� ����������� ���������
fLAM, //������� ��������� ��

fLAMRDY,//���� ���������� ��
fLAMHEAT : boolean;//������ ��

ADCLAM1,
ADCKNOCK,
ADCMAF,
ADCTWAT,
ADCTAIR,
ADCUBAT,
ADCLAM,
ADCTPS,
coefficient_vibora_tcharge : Double;
RPM_RT,
RPM_RT_16,
THR_RT_16,
RPM_THR_RT,
GBC_RT,
GBC_RT_16,
RPM_GBC_RT,
PRESS_RT,
TWAT_RT : integer;

KnockFlags,
MisFireFlags,
StartFlags,
PXX_ZONE,
DELAY_FUEL_CUTOFF,
TLE_PIN_0_7,
TLE_PIN_8_15,

THR,

RPM40,
RPM,
LaunchFuelCutOff,
JUFRXX,
JFRXX1,
JFRXX2,
DERR_RPM,
DELTA_RPM_XX ,

TWAT ,
TAIR,

SSM ,
UFRXX  : integer;

UOZ,
KUOZ1,
KUOZ2,
KUOZ3,
KUOZ4,
DUOZ,
UOZ_TCORR,
DUOZ_REGXX,
DIUOZ,
DUOZ_LAUNCH,

AIR,
GBC,
UGB_RXX,

Press,

TchargeCoeff,
Tcharge,
FchargeGBC,
FchargeGBCFin,
KGBC_TPS,
KGBC_DAD,

ALF ,
AFR,
AFR_WBL ,
KGBC_PIN,
KGTC,
COEFF,
DGTC_LEAN,
DGTC_RICH,
DGTC_DadRich,
KINJ_AIRFREE,
INJ,
FUSE,

TURBO_DYNAMICS,
WGDC           ,
TARGET_BOOST    ,
NS,
Faza,
SPD,
Knock : Double;
number_shift:integer;
ErrCnt :integer;
Errors :integer;
rpm_rt_32:integer;
  end;
//---------------------OLT v 1---------------------------------------------------------
type
TDiagDataOLT_v1 = packed record
fSTOP,      //���� �������������� ���
fXX,        //���� ��������� ����
fPOW,      //���� ���������� ����������
fFUELOFF, //���� ���������� �������
fLAMREG,  //���� ���� ������������� �� ��
fDETZONE,//���� ��������� � ���� ���������
fADS,   //���� ���������� �������� ���������
fLEARN,//���� ���������� �������� �� ��

fXXPrev,
fXXFix,
fDET, //������� ����������� ���������
fLAM:boolean; //������� ��������� ��

RPM_GBC_RT,//�������� ����� RPM-GBC 3D
TWAT :integer;//����������� ��
AFR:Double;//������ �����
RCO:Double;
THR,//��������
RPM40,//������� ��� �� 40
RPM,//������� ���

UFR_SSM,//---�������� ���
SSM   : integer;//--������� ���
coeff:Double;//��������� ��������� ������� �������
faza_INJ:integer;//���� �������

UOZ,  //���
KUOZ1, //��������� ��� 1�
KUOZ2,  //��������� ��� 2�
KUOZ3,  //��������� ��� 3�
KUOZ4,  //��������� ��� 4�
//��� ��������
ADCKNOCK, //��
ADCMAF,   //����
ADCUBAT,  //���
ADCRCO,   //RCO
ADCTPS,   //����
ADCTWAT,  //����
ADCTAIR,  //���
ADCLAM :Double;  // DK1
fLAMRDY,//���� ���������� ��
fLAMHEAT : boolean;//������ ��
SPD,//��������
UFR_XX:integer;//�������� ������� ��
TAIR:integer;//����������� �������
DGTC_LEAN,//����������� ��������� GTC ��� ����������
DGTC_RICH:Double;//����������� ��������� GTC ��� ���������
INJ:Double;//������������ �������� �������
AIR,//�������� ������ �������
GBC,//�������� ������ �������
FRM:Double; //������� ������ �������
Errors :integer; //���������� ������ ��������
AFR_LC : Double;//������ ����� � ���
COEFF_LC:Double;//��������� ��������� � ���
  end;

type
  TOBDII = class( TThread )
    private
      DCB:TDCB;
      hCOMPort:  THandle;     // COM-����
      FBaudRate: integer;     //�������� �����
      FPortName: string;      // ��� �����
      FopenPort:boolean;
      FStartWorkTime: TDateTime;
      FDiagnosticSession: boolean;//���� ��������� ��������
      FErrorList: TStringList;  // ������ ����� ������


      //procedure LOG( s: string );  // ��������� ������ � ���-����
      function OpenPort():boolean;
      procedure ClosePort(hcomport:Thandle);
      procedure WritePort( Data: array of byte );  // ������ � ����
      procedure ReadPort( out Data: array of byte; out Count: integer );  // ������ �� �����
      procedure SendPackage( TargetDevice: byte; SourceDevice: byte; DataType: byte ); overload;
      procedure SendPackage( TargetDevice: byte; SourceDevice: byte; DataType: byte; Data: array of byte; DataLength: byte ); overload;

     //procedure LoadECUList;

      function CalculateCRC( Package: array of byte ): byte;
    //  function IsOBDPackage( Package: array of byte ): boolean;
      function CheckCRC( Package: array of byte; Count: integer ): boolean;
      function WorkWithData( Package: array of byte; Count: integer ): boolean;
    //  procedure WorkWithError( ErrorID: byte; ResponseCode: byte );

     procedure StartCommunication;
      function StartDiagnosticSession: boolean;
      function stopDiagnosticSession : boolean;//���������� �����������
      function stopCommunication : boolean; //��������� �����
      function TesterPresent:boolean; //������ �� �����
     // procedure ReadDataEcu;//������ ������ ������ �������� ���
      procedure ReadDataEcuOLT;//������ ������ ������ ��� ���
    //  procedure ReadVolt;//������ ������ ���
      procedure ReadErrorECU;//������ ������ ���
      procedure ClearError;//����� ������ ���

     // function GetErrors: boolean;
      procedure ParseData_RDBLI_J7ES(var Data: array of byte);
      procedure ParseData_OLT_v1(data:array of byte);
      procedure ParseDataDiag;
      procedure ParseDataDiag_OLT_V1;
      function ReadErrorCount(data:byte):integer;
      function ConvertBoolToInt(data:boolean):string;
    protected
      procedure Execute; override;
    public
    IO_DATA:Array[0..11] of TIOCONTROL ;//������ ���������� ��
     oldtime:Double;
    // newtime:Double;
     oldRPM:integer;
    // NewRPM:integer;
     uskor:Double;
    LogTimeName:string;
    T_ime:Double;
    StartDiagSession :boolean;//���� ������������ ��������
    TesterPres:boolean;//���� �����������
    OBD_ERROR:TStringList;//������
   // OLT_TAB : TableOLT;//�������� ������ ��� ������� ���
    //sysSendingDelay: integer;  // �������� ����� �������/�������
    sleepTimeRead: integer;    //�������� ����������
    SleepTimeWrite:integer;    //�������� ������
    SleepTimeWrite_2:integer;  //�������� �������� ������, ��� ������������ �� ��� ��������
    //SleepCountData:integer;    //����� ����� ������ � �����
    FCommunication: boolean;//���� ������������� ����� � ���
    FlagWriteIsNew:boolean;//����, ������������ ������ �������, ��� ������ ��������� � �����
    FlagIsNew: boolean;//���� ����������� ������
    Flag_Volt: boolean;//���� ��������� ���
    Flag_Error:boolean;//���� ���������� ������
    Flag_Clear_Error:boolean;//���� ������ ������
    Flag_Read_Error:boolean;//���� ���������� ����� ������
    Flag_Disconnect:boolean;//���� ���������� �����������
    ErrorRead:integer;//������ ������ ��� ��� ��� �� �������� ���������� �������� ��������
    Flag_outDiag:boolean;//���� ��� ���������� �����������
    //�����
    //����� ������ ������ �����
    flag_O2_heater:integer;//������ �����
    flag_O2_gotov:integer;//����� ������
    //�������� ����� ������ ������ 1(3-� ����)
    flag_endine_run :integer;//������� ���������� ���������
    flag_XX :integer;//������� ��������� ����
    flag_pow :integer;//������� ��������� �� ��������
    flag_fuelOFF:integer;//������� ���������� ������ �������
    flag_zone_O2:integer;//������� ���� ������������� �� ������� ���������
    flag_zona_knock:integer;//������� ��������� � ���� ���������
    flag_produv_adsorber:integer;//������� ���������� �������� ���������
    flag_save_O2:integer;//������� ���������� ����������� �������� �� ������� ���������
    //�������� ����� ������ ������ 2.(4-� ����)
    flAG_xx_old:integer;//������� ������� ��������� ���� � ������� ����� ����������
    flag_block_exit_xx:integer;//���������� ���������� ������ �� ������ ��������� ����
    flag_zona_knock_old:integer;//������� ��������� � ���� ��������� � ������� ����� ����������
    flag_produv_adsorb_old:integer;//������� ������� �������� ��������� � ������� ����� ����������
    flag_knock:integer;//������� ����������� ���������
    flag_O2_old:integer;//������� �������� ��������� ������� ���������
    flag_o2_new:integer;//������� �������� ��������� ������� ���������
                     /////��� ��������///////
   volt_knock : Double;//������ ���������
   volt_TWAT  : Double;//������ ����������� ������
   volt_AIR   : Double;//������ ������� �������
   volt_AKB   : Double;//���������� ���
   volt_O2    : Double;//���������� ������� ���������
   volt_TPS   : Double;//���������� �������
       // ��������� ��������
      FLambda:                  boolean; // ���� ������������ �������� ��������� (� ��� ��� ������ ���)
      FAdsorber:                boolean; //	���� ������������ ����������
      Fxx:                      string;
      FlagXX:integer;                      //���� ������� ��������� ����
      Fsensor_rpm_gbc_3d:             integer;//����� ������� ����������
      FsensorCoolantTemp:             Double;//����������� ���
      FsensorAirFuelRatio:            Double; //������ �����
      FsensorRCO:                     Double;//RCO
      FsensorThrottlePosition:        Double;//��������� ��������
      FsensorCrankshaftSpeed:         Integer;//������� �������� ���������
      FsensorCrankshaftIdleSpeed:     Double;//������� ��������� ����
      FsensorTimeCicle:               integer;//����������������� ����� �����
      FsensorIdleWantPosition:        Double;//�������� ��������� ���
      FsensorIdleDoublePosition:        Double;//������� ��������� ���
      FsensorFuelTimeCorrection:      Double;//��������� ��������
      FsensorFuelTimeCorrection_LC:   boolean;//���� ��� ��������� �� ���
      FsensorFuelTimeCorrection_wbl: boolean;
      FsensorFazaIngection:           Double;//���� �������
      FsensorSparkAngle:              Double;//���
      FsensorSparkAngle_correct_1:    Double;//��������� ��� �������� 1   /2
      FsensorSparkAngle_correct_2:    Double;//��������� ��� �������� 2   /2
      FsensorSparkAngle_correct_3:    Double;//��������� ��� �������� 3   /2
      FsensorSparkAngle_correct_4:    Double;//��������� ��� �������� 4   /2
      FsensotKNOCkVoltage:            Double;//��� ������� ���������
      FsensorDmrvVoltage:             Double;//��� ����
      FsensorVoltage:                 Double;//���������� ���
      FsensorRCOVoltage:              Double;//��� RCO
      FsensorTPSVoltage              :Double;//��� ��������
      FsensorTWATvoltage:             Double;//��� ����
      FsensorTAIRvoltage:             Double;//��� ���
      FsensorLambdaVoltage:           Double;//��������� ��� ��

      FsensorCarSpeed:                Double;//�������� ����
      fsensorErrorCount:              integer;//���������� ������
      FsensorCrankshaftIdleWantSpeed: Double;//�������� ������� ��������� ����
      FsensorTAIR:                    Double;//����������� �� ������
      FsensorLamMdaVoltage_2:         Double;//��� ��

      FsensorCoeffCorrGTC_HI:         Double;//����������� ��������� GTC ��� ����������(2 �����) / 256
      FsensorCoeffCorrGTC_LO:         Double;//����������� ��������� GTC ��� ���������(2 �����) / 256
      FsensorFuelTimeLength:          Double;//������������ ������� �������
      FsensorAirWeightRate:           Double;//�������� ������ �������
      FsensorAirCycleRate:            Double;//�������� ������ �������
      FsensorFuelTimeRate:            Double;//������� ������ �������

      FsensorRPM_RT:                  integer;//����� ��������
      FsensorDAD_RT:                  integer;//����� ��������
      FsensorPressure:                integer;//�������� �� �������� ����������

      FsensorPressure_PCN:            Double;//�������� �� �� ��������
      FsensorTPS_PCN:                 Double;//�������� �� �� ��������
      kgbc_pin:                       double;//�������� �� �� ��� ������

      Fsensor_ADC_KNOCK:              array [1..50] of Double;
      Fsensor_AVG_ADC_KNOCK:          Double;//������� �������� ���������� ������� ���������

      FsensorFlagLambdaStatus:        Double;//���� ��������� �����
      FsensorAirTimeRate:             Double;
      FsensorFasaGRAD:                integer;//���� ������������ �������
      FsensorGenFaza:                 integer;//��������������� ���� �������
      fsensor_rpm_rt_32:byte;
      //FsensorRamCoeffCorr:            byte;//���� ���������� ���������
      FsensorFuelWayRate:             Double;
      FzoneDK:                        boolean; //���� ������ �� ��
      FLam:                           Double; // ��������� �k(����� ��� ������)
      FlamOld:                        integer;//������� ��������� �����
      Flam_Log:                       integer;//������� � ����� ��������� ����� ���������
      InjDuty:                        Double; //�������� �������� %
      pcn_gen,new_pcn:Double;//-- ��� � ��������������� ����� ���
      fsensor_wbl,
      FSENSOREGT:real; //����������� ������������ ����� J7ES
      number_shift:integer;//����� ��������
      DIAG_DATA:string;//swid �������� ��� �����������
      Flag: boolean;
     TTTIIME:integer;
      Time_T:integer;
      Time_Diag:double;
      FcorrLC1:Double;//��������� ��������� �� ���
      FdadNaklon:Double;//������ ���
      FdadSMeshenie:Double;//�������� ���
      FlagOLT: boolean;//���� ��������� ���
      Flag_OLT_DAD:boolean;//���� ����������� ��� �� ������� ���

      FlagSwitchToRam:boolean;//���� ������������ ������
      FlagSnKey:boolean;//���� ���������� ���������
      SnKey: array of byte;//��������� ��������
      KeyHash: array of byte;//��������������� ������� ��� ���(240 ����)
      FlagOKIO:boolean;//���� ����������� ��������� IO
      DATA_IO:array of byte;
      FlagWriteFirmware:boolean;//���� ��������� ������ �������� ��������
      FlagWriteIO:boolean;//���� ������� IO
      StartAddrTableOLT:integer;//����� ������ ������������ �������
      SatartAddrBCN:integer;//����� ������� ���
      SatartAddrfaza:integer;//����� ������� ����
      FlagRewraiteTableOLT:boolean;//���� ���������� ������������ ������� � ���
      FlagRewraiteTableBCN:boolean;//���� ���������� ���
      FlagRewraiteTableFAZA:boolean;//���� ���������� faza

      outPackCount:integer;//������������ �����
      TableFirmwareOlt: array of byte;//������ �������� ��� ������ � ���
      TableOLT: array of byte;//������� ��� ������������ ���������� ���
      TableBCN: array of byte;//������� ��� ���������� ���
      TableFAZA: array of byte;//������� ���������� ���� �������
      LicenseError:boolean;//---- ���� ������������ ��� �������� �� ��������
      Flag_indicator:integer;
      NewLog:boolean;
      LogName:string;
      class var RunThread: boolean;
      constructor Create( Port: string; BaudRate: integer; BAudRate2:integer; SendingDelay: integer; RTS, DRT: boolean; BufferSize: integer );
      destructor  Destroy;override;
      function    Stop : boolean;//��������� ���� ������
      function    ConnectToECU: boolean;
      procedure   GetECUComplectation;
      procedure   SaveLogJ7ES(S:String );
      procedure   SaveLog_OLT_V1(S:String);
      procedure   SaveLogConnect(S:String);
      function    ReadDiagData(ID:integer):Double;
      Procedure   SwitchToRam;//������������ ������
      procedure   ReadKeyHash;//������ ��������� � �������� �������� ��� ���
      function    convertSnKey(data:array of byte):string;
      Procedure   WriTeDataOLT(Data : Array of byte; StartAddrXram:Integer);//������ ������� � ���(����� ������� ����� ������ ���������)
      procedure   WriteTableClearO2;///������� ������ �������� �� ��
      property PortOpen:boolean read FopenPort;

  end;
  var
  PRec_RDBLI_J7ES : TRec_RDBLI_J7ES;
  Prec_diag_OLTv1 : TRec_RDBLI_J7ES;
  DiagData : TDiagData;
  DiagDataOLT_v1:TDiagDataOLT_v1;

implementation
uses
main;
//------------------------------------------------------------------------------
// ����������� ������
constructor TOBDII.Create( Port: string; BaudRate: integer; BAudRate2:integer; SendingDelay: integer; RTS: Boolean; DRT: Boolean; BufferSize: Integer );
var
  DCB: TDCB;
begin
//------ ���������� ���������� �� ------
 IO_DATA[0].Name:='AFR';
 IO_DATA[0].ID:=$49;
 IO_DATA[0].Status:=False;

 IO_DATA[1].Name:='UOZ';
 IO_DATA[1].ID:=$4A;
 IO_DATA[1].Status:=False;

 IO_DATA[2].Name:='RXX';
 IO_DATA[2].ID:=$41;
 IO_DATA[2].Status:=false;

 IO_DATA[3].Name:='�������� 1';
 IO_DATA[3].ID:=$01;
 IO_DATA[3].Status:=false;

 IO_DATA[4].Name:='�������� 2';
 IO_DATA[4].ID:=$02;
 IO_DATA[4].Status:=false;

 IO_DATA[5].Name:='�������� 3';
 IO_DATA[5].ID:=$03;
 IO_DATA[5].Status:=false;

 IO_DATA[6].Name:='�������� 4';
 IO_DATA[6].ID:=$04;
 IO_DATA[6].Status:=false;

 IO_DATA[7].Name:='��������� 1-4';
 IO_DATA[7].ID:=$05;
 IO_DATA[7].Status:=false;

 IO_DATA[8].Name:='��������� 2-3';
 IO_DATA[8].ID:=$06;
 IO_DATA[8].Status:=false;

 IO_DATA[9].Name:='��������� �����';
 IO_DATA[9].ID:=$09;
 IO_DATA[9].Status:=false;

 IO_DATA[10].Name:='���������� ��� ���';
 IO_DATA[10].ID:=$0A;
 IO_DATA[10].Status:=false;

 IO_DATA[11].Name:='FAZA';
 IO_DATA[11].ID:=$4C;
 IO_DATA[11].Status:=False;
//--------------------------------------
NewLog:=False;
LogTimeName:=FormatDateTime('yy/mm/dd_hh/mm', now);
T_ime:=StrToFloat(stringreplace(FormatDateTime('hh:mm:ss,zzz', now),':','',[rfReplaceAll, rfIgnoreCase]));
//LogTimeName  := StringReplace(LogTimeName, ':', '_',[rfReplaceAll, rfIgnoreCase]);
FlagSwitchToRam:=False;
FlagSnKey:=False;
Flag_outDiag:=fALSE;
Flag_indicator:=0;
CreateDir('Logs');
 //BaudRate - �������� �� ������� ����� �������������
 //BAudRate2 - �������� ��������� �����
  inherited Create( true );
  // ���������� ���� ������ ������
  RunThread := false;
  OBD_ERROR:=TStringList.Create;
  ErrorRead:=0;
  FPortName:=Port;
  FBaudRate := BaudRate;
  SleepTimeWrite_2:=SendingDelay;
//------------------------------------------ �������� ����� ---------------------
  //��������� ����
  hCOMPort := CreateFile( PChar( Port ), Generic_Read + Generic_Write, 0 , nil, Open_Existing, File_Attribute_Normal, 0 );
  // ��������� ���������� ������ ��� �������
  if hCOMPort = Invalid_Handle_Value then begin
    Application.MessageBox(PChar( '������ �������� ����� ' + Port ), '������',
                                  MB_ICONWARNING + MB_OK );
    //TODO: ���������� ������ �������� �����
    Exit;
  end;
  // ���������� ��������� �����
  GetCommState( hCOMPort, DCB );
  DCB.BaudRate := BaudRate2;  //10400;
  DCB.ByteSize := 8;
  DCB.Parity   := NOPARITY;
  DCB.StopBits := ONESTOPBIT;
  // �������� ��������� �����
  if not SetCommState( hCOMPort, DCB ) then begin
   closehandle(hComPort);
   Exit;
  end;

  //������� ������ �����
if not PurgeComm(hCOMPort,PURGE_TXCLEAR or PURGE_RXCLEAR)then begin
 closehandle(hComPort);
 exit;
end;
  // �������������� ����������
  FCommunication := false;
  FDiagnosticSession  := false;
  FErrorList := TStringList.Create;
  //LoadECUList;

  // ���������� ���� ������ ������
  FStartWorkTime := Now;
  RunThread := true;
  resume;
  FopenPort:=True;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// ���������� ������
destructor TOBDII.Destroy;
begin
  CloseHandle( hCOMPort );
  //FErrorList.Free;
 // inherited Destroy;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// ��������� ������ ������
function TOBDII.Stop : boolean;
begin
result:=False;
try
  RunThread := false;
  Flag:=False;
  WaitFor;
 //if not FopenPort then exit(true);

  stopDiagnosticSession;
  stopCommunication;
  CloseHandle( hCOMPort );
  FopenPort:=False;
  hCOMPort:=0;
  result:=true;
except
mainform.Memo1.Lines.Add('�������������� ������ � OBDII.stop');
end;
end;
//------------------------------------------------------------------------------

function Tobdii.OpenPort():boolean;
var
DCB:TDCB;
begin
//------------------------------------------ �������� ����� ---------------------
 FopenPort:=False;
  //��������� ����
  hCOMPort := CreateFile( PChar( FPortName ), Generic_Read + Generic_Write, 0 , nil, Open_Existing, File_Attribute_Normal, 0 );
  // ��������� ���������� ������ ��� �������
  if hCOMPort = Invalid_Handle_Value then begin
   Result:=False;
   Exit;
  end;
  // ���������� ��������� �����
  GetCommState( hCOMPort, DCB );
  DCB.BaudRate := FBaudRate;  //10400;
  DCB.ByteSize := 8;
  DCB.Parity   := NOPARITY;
  DCB.StopBits := ONESTOPBIT;
  // �������� ��������� �����
  if not SetCommState( hCOMPort, DCB ) then Exit(false);
  //������� ������ �����
  if not PurgeComm(hCOMPort,PURGE_TXCLEAR or PURGE_RXCLEAR) then exit(false);
  FopenPort :=true ;
  exit(true);
//------------------------------- ������ �� ���� -------------------
end;


procedure TOBDII.ClosePort(hcomport: Thandle);
begin
  if not FopenPort then  exit;
  closehandle(hcomport);
  FopenPort :=false ;
end;

//------------------------------------------------------------------------------
// ������ � ����
procedure TOBDII.WritePort( Data: array of Byte );
var
  Size, NumberOfBytesWritten: Cardinal;
  s: string;
  i: integer;
begin
i:=0;
//������� � �������� �����
  if not PurgeComm(hCOMPort,PURGE_TXCLEAR or PURGE_RXCLEAR) then begin
    for i := 1 to 10 do begin
     sleep(100);
     ClosePort(hCOMPort);
    if OpenPort then break;
    end;
 end;
 if (i = 10) and ( not FopenPort ) then begin
 mainform.Memo1.Lines.Add('�� ������� �������� ���� � �������������!');
  exit;
 end;
S:='������: ';
  // ���������� ������
  sleep( SleepTimeWrite );
  Size := Length( Data );
  outPackCount:=size;//����������� ����������� ������
if not  WriteFile( hCOMPort, Data, length(data), NumberOfBytesWritten, nil ) then
mainform.Memo1.Lines.Add('�� ������� ��������� � ����!');
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// ������ �� �����
procedure TOBDII.ReadPort( out Data: array of byte; out Count: integer );
var
  Errors, Size, NumberOfBytesReaded: Cardinal;
  COMStat: TCOMStat;
  TimeOutRead,i:integer;//������� ������
  Diag_DATA:array of byte; //����� �������� ����� �����������
  Heater_data: array[0..255] of byte;//������ ����, ����������� ������ ���������.
  dlina:Cardinal;//������ ���������
  ReadPa:boolean;//���� ���������� ������
  Count_pack:byte;//���������� �������, ��� ���� ���� ��������� ����
 begin
 Count:=0;
 Count_pack:=0;
 TimeOutRead:=0;
 Errors:=0;
 dlina:=0;
if not FopenPort then exit;

repeat
sleep(1);
inc(TimeOutRead,1);
 if not ClearCommError( hCOMPort, Errors, @COMStat ) then begin
  Showmessage('������ ������� ����� �� ������ ������ 1 !');
  ClosePort(hCOMPort);
  if not OpenPort then  Showmessage('�� ������� ������ ������� ����!!!');
  exit;
 end;
  Size := COMStat.cbInQue;
  //������ ������ ����, ��� ����������� ����� ���������. 4 ��� 3 �����
  if Size > 0 then begin
     TimeOutRead:=0;
     ReadFile( hCOMPort, Heater_data, 1, NumberOfBytesReaded, nil);
     setlength(Diag_DATA,length(Diag_DATA) + 1);
     Diag_DATA[length(Diag_DATA)-1]:=Heater_data[0];
     //-----------�������� �����---------------------------
     if Heater_data[0] xor $80 > 0 then begin
     //����� ������� �������� ���������, ����� ������ = ��������� ����� ����� ���������� ����������
      dlina:=Heater_data[0] xor $80;
      inc(dlina,3);
       //SaveLogConnect('������ ��������� ������');
     end;
    //------------ ������� �����, ���������� ��������� ����� ��� �� 3 ���� -------------------
    if Heater_data[0] = $80 then begin
     //4-� ���� ������ ������(� ��� �������� 3, ������ 3-� ����)
     // SaveLogConnect('����� �������, ������ ��� 3 �����');
    Errors:=0;
    repeat
    sleep(1);
    inc(TimeOutRead,1);
      if not ClearCommError( hCOMPort, Errors, @COMStat ) then begin
       Showmessage('������ ������� ����� �� ������ ������ 2 !');
       exit;
      end;
      Size := COMStat.cbInQue;
    until (Size >= 3) or (TimeOutRead > 1000) ;
      //------------
      if Size >= 3 then begin
       TimeOutRead:=0;
        ReadFile( hCOMPort, Heater_data, 3, NumberOfBytesReaded, nil);
        for I := 0 to 2 do begin
         setlength(Diag_DATA,length(Diag_DATA) + 1);
         Diag_DATA[length(Diag_DATA)-1]:=Heater_data[i];
        end;
      end;
      //-------------
      dlina:=Heater_data[2];
      inc(dlina,1);
  end;
    //--------- ���� ������� ������ ----------------
    Errors:=0;
  repeat
  sleep(1);
   inc(TimeOutRead,1);
   ReadPa:=False;
   if not ClearCommError( hCOMPort, Errors, @COMStat ) then begin
    Showmessage('������ ������� ����� �� ������ ������ 3 !');
    exit;
   end;
   Size := COMStat.cbInQue;
   if SIZE >=dlina then begin
    TimeOutRead:=0;
    ReadFile( hCOMPort, Heater_data, dlina, NumberOfBytesReaded, nil);
    for i := 0 to dlina - 1 do begin
     setlength(Diag_DATA,length(Diag_DATA) + 1);
     Diag_DATA[length(Diag_DATA)-1]:=Heater_data[i];
    end;
    inc(Count_pack,1);
    ReadPa:=True;
   end;
  until (TimeOutRead > 1000) or (ReadPa) ;
  end;
until (Count_pack = 2) or (TimeOutRead > 1000) ;
Count:=length(Diag_DATA);
for I := 0 to length(Diag_DATA) - 1 do data[i]:=Diag_DATA[i];

end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// ������ ����������� ����� ( CRC )
function TOBDII.CalculateCRC( Package: array of Byte ): byte;
var
  b: byte;
  i,CRC: integer;
begin
  // �������� �������� ����������� �����
  CRC := $00;

  // � �������� ����������� ����� ������������ ������� 8-������ ����� ���� ����
  for i := 0 to Length( Package ) - 1 do begin
    b := Package[ i ];
    CRC := CRC + b;
  end;

  // ���������� �������� CRC
  Exit(lo( CRC) );
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// ��������� �������������� ������ � OBD-II
{
function TOBDII.IsOBDPackage( Package: array of Byte ): boolean;
var
  Fmt, ControlBits: byte;
begin
  // ��������� ������ ���� ������ ������, ������� �������� ���������� � ������� ���������
  Fmt := Package[ 0 ];
  // �������� ��������� 6 ��� ����� Fmt
  ControlBits := Fmt and sysByteClear;
  // ��������� �������������� ������ � ��������� KWP
  if ControlBits = $80 then
    Exit( true )
  else
    Exit( false );
end;
}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// �������� ����������� �����
function TOBDII.CheckCRC( Package: array of byte; Count: integer ): boolean;
var
   CRCInData, b: byte;
  i,CalcCRC: integer;
begin
  // �������� ����������� ����� �������� � ��������� ����� ������. ��������� ���
  CRCInData := Package[ Count - 1 ];

  // �������� �������� ��������� ����������� �����
  CalcCRC := $00;

  // ������� ����������� ����� ������
  for i := 0 to Count - 2 do begin
    b := Package[ i ];
    CalcCRC := CalcCRC + b;
  end;

  // ��������� ��������� �� ����������� ����� � ���������� ��������
  if lo( CalcCRC )= CRCInData then Exit( true ) else Exit( false );
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// ��������� ������
function TOBDII.WorkWithData( Package: array of Byte; Count: Integer ): boolean;
const
  sysECUIndByte = $5A;
  //--------------------- ������������� ���� -----------
  procedure genFaz;
  begin
  try
   if FsensorCrankshaftSpeed > 0 then begin

    FsensorFasaGRAD:=round( FsensorFuelTimeLength * 720 /(60000/FsensorCrankshaftSpeed*2));
 end;
 //���� �������� ������ - ���� �������� ������� = ����� ������ ��� ����������
 if not faza_data.BoolWriteInj then  //�������� ������
  if FsensorFasaGRAD >= (faza_data.IntClose - faza_data.EXCL - 10) then
   FsensorGenFaza:= faza_data.IntClose  - FsensorFasaGRAD
    else
     FsensorGenFaza:= faza_data.EXCL;
 if faza_data.BoolWriteInj then FsensorGenFaza:= faza_data.IntOpen  - FsensorFasaGRAD ;
 if FsensorGenFaza <= 0 then inc(FsensorGenFaza,710);
    except
    mainform.Memo1.Lines.Add('�������� ������ � ������� FsensorGenFaza' ) ;
  end;
  end;
  //-----------------------------------------------------
var
  Fmt, Tgt, Sld: byte;
  Data: array of byte;
 // SomeData: array of Char;
  CRCPackage: array of byte;
  s: string;
  i: integer;
  num:byte;
  //----------------
  Lic1,lic2:array of byte;
    a: cardinal;
  b: byte;
  f: THandle;
  namefi:string;
begin
 result:=true;

    if not CheckCRC( Package, Count ) then begin
    result:=False;
    exit;
    end;
    SetLength( CRCPackage, 0 );
    Fmt := Package[ 0 ];
    Tgt := Package[ 1 ];

    // ��������� �������� ������
    if Tgt <> sysDiag then Exit( false );



    // ��������� ��� ������ (3 ��� 4 ����� � ���������)
    if Fmt = $80 then begin
      Sld := Package[ 4 ];
      for i := 5 to Count - 2 do begin
        SetLength( Data, Length( Data ) + 1 );
        Data[ i - 5 ] := Package[ i ];
      end;
    end  else begin
      Sld := Package[ 3 ];
      for i := 4 to Count - 2 do begin
        SetLength( Data, Length( Data ) + 1 );
        Data[ i - 4 ] := Package[ i ];
      end;
    end;

    case Sld of



      $7D:begin
       // log('WriteMemo (OK)');

      end;

      $11: begin

      end;
      // StartCommunication ( STC )
      $C1: begin
        //SaveLogConnect('<-  StartCommunication (OK)');
             FCommunication := true;
            // LOG('StartCommunication (OK)');
             SleepTimeWrite:=150;//�������� ����� ��������� � ����
             sleepTimeRead:=100;//�������� ����� �������
           end;
      // StopCommunication ( SPC )
      $C2: begin
     // SaveLogConnect('<-  StopCommunication (OK)');
             FCommunication := false;
            // LOG('StopCommunication (OK)');
           end;
      // StartDiagnosticSession ( STDS )
      $50: begin
    //  SaveLogConnect('<-  StartDiagnosticSession (OK)');
             FDiagnosticSession := true;
             StartDiagSession:=True;
            // LOG('StartDiagnosticSession(OK)');
           end;
      // StopDiagnosticSession ( SPDS )
      $60: begin
     // SaveLogConnect('<-  StopDiagnosticSession (OK)');
      FDiagnosticSession := false;
      GetCommState( hCOMPort, DCB );
      DCB.BaudRate := 10400;  //10400;
      DCB.ByteSize := 8;
      DCB.Parity   := NOPARITY;
      DCB.StopBits := ONESTOPBIT;
      SetCommState( hCOMPort, DCB );
            // LOG('StopDiagnosticSession (OK)');
           end;
      // ECUReset ( ER )
      $51: begin

           end;
      // ClearDiagnosticInformation ( CDI )
      $54: begin
          Flag_Clear_Error:=false;
          Flag_Read_Error:=true;
          //LOG('ClearDiagnosticInformation (OK)');
         end;
      // 	ReadDiagnosticTroubleCodesByStatus ( RDTCBS )
      $58: begin
     // self.SaveLogConnect('<- ReadDiagnosticTroubleCodesByStatus (OK)');
    //  LOG('ReadDiagnosticTroubleCodesByStatus (OK)');
            Flag_Read_Error:=False;
            obd_error.Clear;
            case data[0] of
             $01:begin
             s:='P'+inttohex(data[1],2)+inttohex(data[2],2);
             OBD_ERROR.Add(s) ;
             end;
             $02:begin
             s:='P'+inttohex(data[1],2)+inttohex(data[2],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[4],2)+inttohex(data[5],2);
             OBD_ERROR.Add(s) ;
             end;
             $03:begin
             s:='P'+inttohex(data[1],2)+inttohex(data[2],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[4],2)+inttohex(data[5],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[7],2)+inttohex(data[8],2);
             OBD_ERROR.Add(s) ;
             end;
             $04:begin
             s:='P'+inttohex(data[1],2)+inttohex(data[2],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[4],2)+inttohex(data[5],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[7],2)+inttohex(data[8],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[10],2)+inttohex(data[11],2);
             OBD_ERROR.Add(s) ;
             end;
             $05:begin
             s:='P'+inttohex(data[1],2)+inttohex(data[2],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[4],2)+inttohex(data[5],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[7],2)+inttohex(data[8],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[10],2)+inttohex(data[11],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[13],2)+inttohex(data[14],2);
             OBD_ERROR.Add(s) ;
             end;
             $06:begin
             s:='P'+inttohex(data[1],2)+inttohex(data[2],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[4],2)+inttohex(data[5],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[7],2)+inttohex(data[8],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[10],2)+inttohex(data[11],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[13],2)+inttohex(data[14],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[16],2)+inttohex(data[17],2);
             OBD_ERROR.Add(s) ;
             end;
             $07:begin
             s:='P'+inttohex(data[1],2)+inttohex(data[2],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[4],2)+inttohex(data[5],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[7],2)+inttohex(data[8],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[10],2)+inttohex(data[11],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[13],2)+inttohex(data[14],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[16],2)+inttohex(data[17],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[19],2)+inttohex(data[20],2);
             OBD_ERROR.Add(s) ;
             end;
             $08:begin
             s:='P'+inttohex(data[1],2)+inttohex(data[2],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[4],2)+inttohex(data[5],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[7],2)+inttohex(data[8],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[10],2)+inttohex(data[11],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[13],2)+inttohex(data[14],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[16],2)+inttohex(data[17],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[19],2)+inttohex(data[20],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[22],2)+inttohex(data[23],2);
             OBD_ERROR.Add(s) ;
             end;
             $09:begin
             s:='P'+inttohex(data[1],2)+inttohex(data[2],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[4],2)+inttohex(data[5],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[7],2)+inttohex(data[8],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[10],2)+inttohex(data[11],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[13],2)+inttohex(data[14],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[16],2)+inttohex(data[17],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[19],2)+inttohex(data[20],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[22],2)+inttohex(data[23],2);
             OBD_ERROR.Add(s) ;
             s:='P'+inttohex(data[25],2)+inttohex(data[26],2);
             OBD_ERROR.Add(s) ;
             end;
            end;
           end;
      //	ReadEcuIdentification ( REI )
      $5A: begin

           end;
      // 	ReadDataByLocalIdentifier ( RDBLI )
      $61: begin
///-------------����� ����� �� ��� ���������---------------------------------
             //��������������� ������ ��� ���������
             if ( Fmt = $80 ) and ( Data[ 0 ] = $0F ) then begin
               SleepTimeWrite:=SleepTimeWrite_2;
               try
                if length(data) > 0 then
                 if inttostr(data[1])<>'' then begin
                  //������� ���������� ���������
                  if data[1] and $1 = $1 then flag_endine_run :=0 else flag_endine_run :=1 ;
                 // ������� ��������� ����
                 if data[1] and $2 = $2 then  flag_XX:=1 else flag_XX:=0;
                 //������� ��������� �� ��������
                 if data[1] and $4 = $4 then  flag_pow:=1 else  flag_pow:=0;
                 //������� ���������� ������ �������
                 if data[1] and $8 = $8 then flag_fuelOFF:=1 else flag_fuelOFF:=0;
                 //������� ���� ������������� �� ������� ���������
                 if data[1] and $10 = $10 then FzoneDK :=true else FzoneDK :=false;
                 if data[1] and $10 = $10 then flag_zone_O2 :=1 else flag_zone_O2 :=0;
                  //������� ��������� � ���� ���������
                 if data[1] and $20 = $20 then flag_zona_knock:=1 else flag_zona_knock:=0;
                  //������� ���������� �������� ���������
                  if data[1] and $40 = $40 then flag_produv_adsorber:=1 else flag_produv_adsorber:=0;
                  //������� ���������� ����������� �������� �� ������� ���������
                  if data[1] and $80 = $80 then flag_save_O2 :=1 else  flag_save_O2:=0;
                end;
                //����� ������ ������ 2
                if length(data) > 1 then
                if inttostr(data[2])<>'' then begin
                 //������� ������� ��������� ���� � ������� ����� ����������
                 if data[2] and $2 = $2 then flAG_xx_old:=1 else flAG_xx_old:=0;
                 //���������� ���������� ������ �� ������ ��������� ����
                 if data[2] and $4 = $4 then flag_block_exit_xx:=1 else flag_block_exit_xx:=0;
                 //������� ��������� � ���� ��������� � ������� ����� ����������
                 if data[2] and $8 = $8 then flag_zona_knock_old:=1 else flag_zona_knock_old:=0;
                 //������� ������� �������� ��������� � ������� ����� ����������
                 if data[2] and $10 = $10 then flag_produv_adsorb_old:=1 else flag_produv_adsorb_old:=0;
                 //������� ����������� ���������
                 if data[2] and $20 = $20 then flag_knock:=1 else flag_knock:=0;
                 //������� �������� ��������� ������� ���������
                 if data[2] and $40 = $40 then FlamOLD:=1 else FlamOLD:=0;
                 //������� �������� ��������� ������� ���������
                 if data[2] and $80 = $80 then Flam:=1 else Flam:=0;
                 //�������� �������� ��������� �����
                end;
              if inttostr(data[8]) <>'' then Fsensor_rpm_gbc_3d         :=data[8];//rpm/gbc/3d
              if inttostr(data[9]) <>'' then FsensorCoolantTemp         := Data[ 9 ] - 40;//����������� ��
              if inttostr(data[10])<>'' then FsensorAirFuelRatio        := 14.7 * ( Data[ 10 ] + 128 ) / 256;//������ �����
              if inttostr(data[11])<>'' then FsensorRCO                 :=data[11]/256;//rco
              if inttostr(data[12])<>'' then FsensorThrottlePosition    := Data[ 12 ];//��������� ��������
              //if inttostr(data[13])<>'' then FsensorCrankshaftSpeed     := Data[ 13 ] * 40;//�������� �������� ���������
              if inttostr(data[14])<>'' then FsensorCrankshaftIdleSpeed := Data[ 14 ] * 10;//�������� �������� ��������� �� ��
              if inttostr(data[15])<>'' then FsensorTimeCicle :=StrToInt( '$' +StringReplace( ( IntToHex( Data[16],2 ) + IntToHex( Data[15],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) );
               if FsensorTimeCicle > 0 then FsensorCrankshaftSpeed:=5000000 div FsensorTimeCicle else FsensorCrankshaftSpeed:=0;

              if inttostr(data[17])<>'' then FsensorIdleWantPosition    := Data[ 17 ];//�������� ��������� ���
              if inttostr(data[18])<>'' then FsensorIdleDoublePosition    := Data[ 18 ];//������� ��������� ���
              if not FsensorFuelTimeCorrection_LC then
              if inttostr(data[19])<>'' then FsensorFuelTimeCorrection  := strtofloat(formatfloat('##0.##',( Data[ 19 ] + 128 ) / 256));//��������� ��������� ������� �������
             // if inttostr(data[19])<>'' then OLT_TAB.COEFFCORR_OLT := round((data[19] + 128) / 256 * 128);//��������� ��������� ��� ������� �������� �� ��� ���������������
             // if inttostr(data[19])<>'' then FsensorRamCoeffCorr :=round(( data[19]+128)/256*128);
              if inttostr(data[20])<>'' then FsensorFazaIngection       :=data[20]*3;
              if inttostr(data[21])<>'' then begin

              if data[21] and $80 = $80 then begin
                FsensorSparkAngle:= strtofloat('-'+floattostr((256 - Data[ 21 ]) / 2));//���
              end else

              FsensorSparkAngle          := Data[ 21 ] / 2;//���

              end;
              if inttostr(data[22])<>'' then FsensorSparkAngle_correct_1:=data[22]/2;
              if inttostr(data[23])<>'' then FsensorSparkAngle_correct_2:=data[23]/2;
              if inttostr(data[24])<>'' then FsensorSparkAngle_correct_3:=data[24]/2;
              if inttostr(data[25])<>'' then FsensorSparkAngle_correct_4:=data[25]/2;

              if inttostr(data[26])<>'' then FsensotKNOCkVoltage        := ( data [ 26 ] * 5 ) / 256;//��� ������� ���������
              if inttostr(data[27])<>'' then FsensorDmrvVoltage         := (DATA[ 27 ] * 5) / 256;//��� ����(������ ������� �������)
               //	N=0.287*E*5.0/256 [�] ���������� ���
              if inttostr(data[28])<>'' then FsensorVoltage             :=  Data[ 28 ]*0.093  ;//���������� ���
              if inttostr(data[29])<>'' then FsensorRCOVoltage          := data[29]*5/256;
              if inttostr(data[30])<>'' then FsensorTPSVoltage          := data[30]*5/256;
              if inttostr(data[31])<>'' then FsensorTWATvoltage          := data[31]*5/256;
              if inttostr(data[32])<>'' then FsensorTAIRvoltage          := data[32]*5/256;
              if inttostr(data[33])<>'' then FsensorLambdaVoltage       := ( Data[ 33 ] / 256 ) * 1.25;//��� ������� ���������
              if inttostr(data[34])<>'' then FsensorFlagLambdaStatus    := Data[ 34 ];//���� ��������� ������� ���������
              if inttostr(data[34])<>'' then begin
                if data[34] and $1 = $1 then self.flag_O2_gotov :=1 else flag_O2_gotov:=0;//���������� ��
                if data[34] and $2 = $2 then self.flag_O2_heater :=1 else flag_O2_heater:=0;//������ ��
              end;
              if inttostr(data[36])<>'' then FsensorCarSpeed            := Data[ 36 ];//�������� ����������
              if inttostr(data[37])<>'' then FsensorCrankshaftIdleWantSpeed := Data[ 37 ] * 10;//�������� ������� ��
              if inttostr(data[38])<>'' then FsensorTAIR                :=Data[38]-40;
              if inttostr(data[39])<>'' then FsensorLamMdaVoltage_2      := ( Data[ 39 ] / 256 ) * 1.25;
              if inttostr(data[40])<>'' then FsensorCoeffCorrGTC_HI:=StrToInt( '$' +StringReplace( ( IntToHex( Data[41],2 ) + IntToHex( Data[40],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) )/256;
              if inttostr(data[42])<>'' then FsensorCoeffCorrGTC_LO:=StrToInt( '$' +StringReplace( ( IntToHex( Data[43],2 ) + IntToHex( Data[42],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) )/256;



             // if inttostr(data[47])<>'' then SELF.FsensorFuelTimeLength:=DATA[47]/125 ELSE FsensorFuelTimeLength:=1;

               // ����� �������
                 FsensorFuelTimeLength := StrToInt( '$' +StringReplace( ( IntToHex( Data[45],2 ) + IntToHex( Data[44],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) ) / 125;

               //�������� ������ ������� (��/���)
                 FsensorAirWeightRate := StrToInt( '$' +StringReplace( ( IntToHex( Data[47],2 ) + IntToHex( Data[46],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) ) / 10;
               // �������� ������ ������� (��/����)
                 FsensorAirCycleRate := StrToInt( '$' +StringReplace( ( IntToHex( Data[49],2 ) + IntToHex( Data[48],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) ) / 6;
                 //������� ������
                 FsensorFuelTimeRate:=StrToInt( '$' +StringReplace( ( IntToHex( Data[51],2 ) + IntToHex( Data[50],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) ) / 50;
                 //dad
                 if mainform.LoadFirmware then
                 FsensorPressure:=round( (FsensorDmrvVoltage + firmware.FdadSMeshenie)* firmware.FdadNaklon);//�������� �� �������� ����������
//-------------------------------------

                 if (self.FsensorFuelTimeLength > 0) and (FsensorCrankshaftSpeed > 0)  then
                 InjDuty:=(FsensorFuelTimeLength/(60/FsensorCrankshaftSpeed*1000)*100)/2;

genFaz;
synchronize(mainform.ReloadDiagData);
ParseData_OLT_v1(data);
ParseDataDiag_OLT_V1;

    if lc1.RunThread then begin
     try
     if lc1.lc then  begin
      FsensorFuelTimeCorrection_LC:=true;
      if FsensorAirFuelRatio > 0 then
      FsensorFuelTimeCorrection:=lc1.AFR/FsensorAirFuelRatio;
      lc1.lc:=false;
     end else begin
      if FsensorFuelTimeCorrection_LC then begin
        FlagIsNew:=false;
       // FsensorFuelTimeCorrection:=1;
      end;
     end;
    except
    mainform.Memo1.Lines.Add('������ � ����������� ��������� � ���');
    end;
    end;
  FlagIsNew := true;
  except
  mainform.Memo1.Lines.Add('�������� ������ � ������� ������ ���_1');
  end;
             end;//����� ������ ��� ���������
/////////����������� �������� J7ES/////////
 if ( Fmt = $80 ) and ( Data[ 0 ] = $0D ) then begin
 if length(data) < 101 then exit;

 SleepTimeWrite:=SleepTimeWrite_2;
 try
 ParseData_RDBLI_J7ES(data);
  except
 mainform.Memo1.Lines.Add('�������� ������ � ParseData_RDBLI_J7ES(data)');
 end;
 try
 ParseDataDiag;
 except
 mainform.Memo1.Lines.Add('�������� ������ � ParseDataDiag');
 end;
 try
                  if inttostr(data[1])<>'' then begin
                  //������� ���������� ���������
                  if data[1] and $1 = $1 then flag_endine_run :=0 else flag_endine_run :=1 ;
                 // ������� ��������� ����
                 if data[1] and $2 = $2 then  flag_XX:=1 else flag_XX:=0;
                 //������� ��������� �� ��������
                 if data[1] and $4 = $4 then  flag_pow:=1 else  flag_pow:=0;
                 //������� ���������� ������ �������
                 if data[1] and $8 = $8 then flag_fuelOFF:=1 else flag_fuelOFF:=0;
                 //������� ���� ������������� �� ������� ���������
                 if data[1] and $10 = $10 then FzoneDK :=true else FzoneDK :=false;
                 if data[1] and $10 = $10 then flag_zone_O2 :=1 else flag_zone_O2 :=0;
                  //������� ��������� � ���� ���������
                 if data[1] and $20 = $20 then flag_zona_knock:=1 else flag_zona_knock:=0;
                  //������� ���������� �������� ���������
                  if data[1] and $40 = $40 then flag_produv_adsorber:=1 else flag_produv_adsorber:=0;
                  //������� ���������� ����������� �������� �� ������� ���������
                  if data[1] and $80 = $80 then flag_save_O2 :=1 else  flag_save_O2:=0;
                end;
                //����� ������ ������ 2
                if inttostr(data[2])<>'' then begin
                 //������� ������� ��������� ���� � ������� ����� ����������
                 if data[2] and $2 = $2 then flAG_xx_old:=1 else flAG_xx_old:=0;
                 //���������� ���������� ������ �� ������ ��������� ����
                 if data[2] and $4 = $4 then flag_block_exit_xx:=1 else flag_block_exit_xx:=0;
                 //������� ��������� � ���� ��������� � ������� ����� ����������
                 if data[2] and $8 = $8 then flag_zona_knock_old:=1 else flag_zona_knock_old:=0;
                 //������� ������� �������� ��������� � ������� ����� ����������
                 if data[2] and $10 = $10 then flag_produv_adsorb_old:=1 else flag_produv_adsorb_old:=0;
                 //������� ����������� ���������
                 if data[2] and $20 = $20 then flag_knock:=1 else flag_knock:=0;
                 //������� �������� ��������� ������� ���������
                 if data[2] and $40 = $40 then FlamOLD:=1 else FlamOLD:=0;
                 //������� �������� ��������� ������� ���������
                 if data[2] and $80 = $80 then Flam:=1 else Flam:=0;
                 //�������� �������� ��������� �����

                end;
              if inttostr(data[8]) <>'' then Fsensor_rpm_gbc_3d         :=data[8];//rpm/gbc/3d
              if inttostr(data[9]) <>'' then FsensorCoolantTemp         := Data[ 9 ] - 40;//����������� ��
              if inttostr(data[10])<>'' then FsensorAirFuelRatio        := 14.7 * ( Data[ 10 ] + 128 ) / 256;//������ �����
              if inttostr(data[11])<>'' then FsensorRCO                 :=data[11]/256;//rco
              if inttostr(data[12])<>'' then FsensorThrottlePosition    := Data[ 12 ];//��������� ��������
              //if inttostr(data[13])<>'' then FsensorCrankshaftSpeed     := Data[ 13 ] * 40;//�������� �������� ���������
              if inttostr(data[14])<>'' then FsensorCrankshaftIdleSpeed := Data[ 14 ] * 10;//�������� �������� ��������� �� ��
              if inttostr(data[15])<>'' then FsensorTimeCicle :=StrToInt( '$' +StringReplace( ( IntToHex( Data[16],2 ) + IntToHex( Data[15],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) );
              if FsensorTimeCicle > 0 then  FsensorCrankshaftSpeed:= 5000000 div FsensorTimeCicle else FsensorCrankshaftSpeed:=0;

              if inttostr(data[17])<>'' then FsensorIdleWantPosition    := Data[ 17 ];//�������� ��������� ���
              if inttostr(data[18])<>'' then FsensorIdleDoublePosition    := Data[ 18 ];//������� ��������� ���
              if not FsensorFuelTimeCorrection_LC then
              if FsensorFuelTimeCorrection_wbl then  FsensorFuelTimeCorrection:=fsensor_wbl/self.FsensorAirFuelRatio
               else
              if inttostr(data[19])<>'' then FsensorFuelTimeCorrection  := strtofloat(formatfloat('##0.##',( Data[ 19 ] + 128 ) / 256));//��������� ��������� ������� �������

             // if inttostr(data[19])<>'' then OLT_TAB.COEFFCORR_OLT := round((data[19] + 128) / 256 * 128);//��������� ��������� ��� ������� �������� �� ��� ���������������
             // if inttostr(data[19])<>'' then FsensorRamCoeffCorr :=round(( data[19]+128)/256*128);
              if inttostr(data[20])<>'' then FsensorFazaIngection       :=data[20]*3;
              if inttostr(data[21])<>'' then begin

              if data[21] and $80 = $80 then begin
                FsensorSparkAngle:= strtofloat('-'+floattostr((256 - Data[ 21 ]) / 2));//���
              end else
              FsensorSparkAngle          := Data[ 21 ] / 2;//���

              end;
              if inttostr(data[22])<>'' then FsensorSparkAngle_correct_1:=data[22]/2;
              if inttostr(data[23])<>'' then FsensorSparkAngle_correct_2:=data[23]/2;
              if inttostr(data[24])<>'' then FsensorSparkAngle_correct_3:=data[24]/2;
              if inttostr(data[25])<>'' then FsensorSparkAngle_correct_4:=data[25]/2;

              if inttostr(data[26])<>'' then FsensotKNOCkVoltage        := ( data [ 26 ] * 5 ) / 256;//��� ������� ���������
              if inttostr(data[27])<>'' then FsensorDmrvVoltage         := (DATA[ 27 ] * 5) / 256;//��� ����(������ ������� �������)
               //	N=0.287*E*5.0/256 [�] ���������� ���
              if inttostr(data[28])<>'' then FsensorVoltage             :=  Data[ 28 ]*0.093  ;//���������� ���
              if inttostr(data[29])<>'' then FsensorRCOVoltage          := data[29]*5/256;
              if inttostr(data[30])<>'' then FsensorTPSVoltage          := data[30]*5/256;
              if inttostr(data[31])<>'' then FsensorTWATvoltage          := data[31]*5/256;
              if inttostr(data[32])<>'' then FsensorTAIRvoltage          := data[32]*5/256;
              if inttostr(data[33])<>'' then FsensorLambdaVoltage       := ( Data[ 33 ] / 256 ) * 1.25;//��� ������� ���������
              if inttostr(data[34])<>'' then FsensorFlagLambdaStatus    := Data[ 34 ];//���� ��������� ������� ���������
              if inttostr(data[34])<>'' then begin
                if data[34] and $1 = $1 then self.flag_O2_gotov :=1 else flag_O2_gotov:=0;//���������� ��
                if data[34] and $2 = $2 then self.flag_O2_heater :=1 else flag_O2_heater:=0;//������ ��
              end;
              if inttostr(data[36])<>'' then FsensorCarSpeed            := Data[ 36 ];//�������� ����������
              if inttostr(data[37])<>'' then FsensorCrankshaftIdleWantSpeed := Data[ 37 ] * 10;//�������� ������� ��
              if inttostr(data[38])<>'' then FsensorTAIR                :=Data[38]-40;
              if inttostr(data[39])<>'' then FsensorLamMdaVoltage_2      := ( Data[ 39 ] / 256 ) * 1.25;
              if inttostr(data[40])<>'' then FsensorCoeffCorrGTC_HI:=StrToInt( '$' +StringReplace( ( IntToHex( Data[41],2 ) + IntToHex( Data[40],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) )/256;
              if inttostr(data[42])<>'' then FsensorCoeffCorrGTC_LO:=StrToInt( '$' +StringReplace( ( IntToHex( Data[43],2 ) + IntToHex( Data[42],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) )/256;



             // if inttostr(data[47])<>'' then SELF.FsensorFuelTimeLength:=DATA[47]/125 ELSE FsensorFuelTimeLength:=1;

               // ����� �������
                 FsensorFuelTimeLength := StrToInt( '$' +StringReplace( ( IntToHex( Data[45],2 ) + IntToHex( Data[44],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) ) / 125;

               //�������� ������ ������� (��/���)
                 FsensorAirWeightRate := StrToInt( '$' +StringReplace( ( IntToHex( Data[47],2 ) + IntToHex( Data[46],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) ) / 10;
               // �������� ������ ������� (��/����)
                 FsensorAirCycleRate := StrToInt( '$' +StringReplace( ( IntToHex( Data[49],2 ) + IntToHex( Data[48],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) ) / 6;
                 //������� ������
                 FsensorFuelTimeRate:=StrToInt( '$' +StringReplace( ( IntToHex( Data[51],2 ) + IntToHex( Data[50],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) ) / 50;
                 //dad_RT [52] - ����� �������� �� ���
               if length(data)>=53 then
                if inttostr(data[52])<>'' then FsensorDAD_RT:=data[52];
                 //rpm_rt data[76] - ����� �� ��������
                //pressure data[94,95]
                FsensorFazaIngection:=data[76]*6;
                if length(data)>=94 then
                 FsensorPressure:= round( (data[95]*256+data[94])/100) ;
               // if mainform.LoadFirmware then
               //  FsensorPressure:=round( (FsensorDmrvVoltage + firmware.FdadSMeshenie)* firmware.FdadNaklon);//�������� �� �������� ����������
                   ///�������� �� �� �������� data[60]
                if length(data)>=59 then begin

                 if inttostr(data[60])<>'' then   FsensorPressure_PCN:=data[60]/128;
                 //�������� �� �� �������� data[59]
                 if inttostr(data[59])<>'' then  FsensorTPS_PCN:=data[59]/128;
                  if length(data)>62 then  self.fsensor_wbl:=14.7 * ( Data[ 62 ] + 128 ) / 256;

                 end;
                  {  62 wbl
                  FsensorFasaGRAD:=round( FsensorFuelTimeLength * (FsensorCrankshaftSpeed /120000*720));
                 if FsensorAirWeightRate > 80 then
                  FsensorGenFaza:= 810 - FsensorFasaGRAD else
                  FsensorGenFaza:= 660 - FsensorFasaGRAD;
                  }

                 if (self.FsensorFuelTimeLength > 0) and (FsensorCrankshaftSpeed > 0)  then
                 InjDuty:=(FsensorFuelTimeLength/(60/FsensorCrankshaftSpeed*1000)*100)/2;
 if lc1.RunThread then begin
  if lc1.lc then  begin
   FsensorFuelTimeCorrection_LC:=true;
   FsensorFuelTimeCorrection:=lc1.AFR/FsensorAirFuelRatio;
   lc1.lc:=false;
  end else begin
   if FsensorFuelTimeCorrection_LC then begin
   FlagIsNew:=false;
   FsensorFuelTimeCorrection:=1;
   end;
  end;
 end;
 genFaz;
 mainform.ReloadDiagData;
 FlagIsNew := true;
 ErrorRead:=0;
 except
 mainform.Memo1.Lines.Add('�������� ������ � ������� ������ J7ES Length(data) = '+Inttostr(length(data)));
 end;
 end;

           end;
      // 	ReadMemoryByAddress ( RMBA ) keynhash+
      $63: begin
      //���������� �������� ����� �� ���
     // log('ReadKeyHash (OK)');
      num:=0;
       for i := 0 to 7 do begin
        setlength(snkey,i+1);
        snkey[i]:=lo(data[i] - (3 * num + 165));
	      num:=data[i];
       end;
      num:=0;
      setlength(KeyHash,240);
      setlength(lic1,240);

      namefi:=ExtractFilePath(Application.ExeName)+'license.bin';
        // ��������� ������� �����
  if FileExists( ExtractFilePath(Application.ExeName)+'license.bin' ) then begin
     f := CreateFile( PChar( namefi ), Generic_Read, 0, nil, Open_Existing, File_Attribute_Normal, 0 );
       for i := 1 to 240 do begin
      ReadFile( f, b, SizeOf( b ), a, nil );
      lic1[ i-1  ] := b;
    end;
    CloseHandle( f );
  end;
  namefi:=ExtractFilePath(Application.ExeName)+'license2.bin';
   if FileExists( namefi ) then begin
   setlength(lic2,240);
     f := CreateFile( PChar( namefi ), Generic_Read, 0, nil, Open_Existing, File_Attribute_Normal, 0 );
       for i := 1 to 240 do begin
      ReadFile( f, b, SizeOf( b ), a, nil );
      lic2[ i-1  ] := b;
    end;
    CloseHandle( f );
  end;

      for i := 0 to 239 do begin
       KeyHash[i]:=lo(snKey[i mod 8] + (3 * num + 165));
       //if KeyHash[i] <> lic1[i] then LicenseError:=true else LicenseError:=False;
       num:=KeyHash[i];
      end;
  if length(lic1) = 240 then
    for i := 0 to 239 do
     if lic1[i] <> KeyHash[i] then begin
       LicenseError:=true;
       break;
        end
         else
          LicenseError:=False;

 if LicenseError = true then
  if length(lic2) = 240 then
    for i := 0 to 239 do
     if lic2[i] <> KeyHash[i] then begin
      LicenseError:=true;
      break;
      end else LicenseError:=False;


       //if LicenseError then showmessage('Error Licensi');
      // LicenseError:=false;
      // LicenseError:=False;
       FlagSnKey:=TRUE;
           end;
      // 	InputOutputControlByLocalIdentifier ( IOCBLI )
      $70: begin
      //log('SwitchToRam (OK)');
     if data[0] = $49 then begin
      if data[1] = $01 then IO_DATA[0].Status:=true;
      if data[1] = $00 then self.IO_DATA[0].Status:=false;
     IO_DATA[0].valid_value:=data[2];
     FlagOKIO:=true;
     end;

     if  data[0] = $4A then begin
      if data[1] = $01 then IO_DATA[1].Status:=true;
      if data[1] = $00 then IO_DATA[1].Status:=false;
      IO_DATA[1].valid_value:=data[2];
      FlagOKIO:=true;
     end;

     if  data[0] = $41 then begin
      if data[1] = $01 then IO_DATA[2].Status:=true;
      if data[1] = $00 then self.IO_DATA[2].Status:=false;
      IO_DATA[2].valid_value:=data[2];
      FlagOKIO:=true;
     end;

     if data[0] = $01 then begin
       if data[1] = $01 then io_data[3].Status:=true;
       if data[1] = $00 then io_data[3].Status:=False;
       FlagOKIO:=true;
     end;

     if data[0] = $02 then begin
       if data[1] = $01 then io_data[4].Status:=true;
       if data[1] = $00 then io_data[4].Status:=False;
       FlagOKIO:=true;
     end;

     if data[0] = $03 then begin
       if data[1] = $01 then io_data[5].Status:=true;
       if data[1] = $00 then io_data[5].Status:=False;
       FlagOKIO:=true;
     end;

      if data[0] = $04 then begin
       if data[1] = $01 then io_data[6].Status:=true;
       if data[1] = $00 then io_data[6].Status:=False;
       FlagOKIO:=true;
     end;

     if data[0] = $05 then begin
       if data[1] = $01 then io_data[7].Status:=true;
       if data[1] = $00 then io_data[7].Status:=False;
       FlagOKIO:=true;
     end;

     if data[0] = $06 then begin
       if data[1] = $01 then io_data[8].Status:=true;
       if data[1] = $00 then io_data[8].Status:=False;
       FlagOKIO:=true;
     end;

     if data[0] = $09 then begin
       if data[1] = $01 then io_data[9].Status:=true;
       if data[1] = $00 then io_data[9].Status:=False;
       FlagOKIO:=true;
     end;

     if data[0] = $0A then begin
       if data[1] = $01 then io_data[10].Status:=true;
       if data[1] = $00 then io_data[10].Status:=False;
       FlagOKIO:=true;
     end;
        //data[1] ��� ��� ��������� ��������������
        //data[2] ��� ��� � ����� �������� ���������, �������� ������� �����
            FlagSwitchToRam:=true;
           end;
      // 	WriteDataByLocalIdentifier ( WDBLI )
      $7B: begin

           end;
      // TesterPresent ( TP )
      $7E: begin
           TesterPres:=true;
           end;
      // ��������� ������������� �������
      $7F: begin
      //log('ERROR');
             WorkWithData( Data[ 0 ], Data[ 1 ] );
             if obdii.Flag_Clear_Error then obdii.Flag_Clear_Error:=False;

           end;
    end;
{  end else begin
    Exit( false );
  end; }
end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// ������������ ������ � �������� � ����
procedure TOBDII.SendPackage( TargetDevice: Byte; SourceDevice: Byte; DataType: Byte );
var
  Data: array of byte;
begin
  SetLength( Data, 0 );
  SendPackage( TargetDevice, SourceDevice, DataType, Data, 0 );
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// ������������ ������ � �������� � ����
procedure TOBDII.SendPackage( TargetDevice: Byte; SourceDevice: Byte; DataType: Byte; Data: array of Byte; DataLength: Byte );


  //----------------------------------------------------------------------------
  // �������� ���
  procedure CheckECHO( OutPackage: array of byte; InPackage: array of byte; InCount: integer; out Package: array of byte; out Count: integer );
  var
    RepFlag: boolean;
   // StartCount: integer;
    i: integer;
  begin
   RepFlag:=False;
    try
    for i := 0 to Length( OutPackage ) - 1 do begin
      if OutPackage[ i ] <> InPackage[ i ] then begin
        RepFlag := false;
        Break;
      end else begin
        if i = Length( OutPackage ) - 1 then RepFlag := true;
      end;
    end;

    if RepFlag = true then begin
      for i := Length( OutPackage ) to InCount do begin
        Package[ i - Length( OutPackage ) ] := InPackage[ i ];
      end;
      Count := InCount - Length( OutPackage );
    end else begin
      for i := 0 to InCount do begin
        Package[ i ] := InPackage[ i ];
        Count := InCount;
      end;
    end;
    except
    showmessage('��������� ������ � �������� ��� ��������');
    end;
  end;
  //----------------------------------------------------------------------------


var
  Fmt, Tgt, Src, Len, Sld, CS: byte;
  Package, OutPackage, InPackage: array of byte;
  InCount, Count: integer;
  i: integer;
  s:string;
 // SendCountPack:integer;
begin
if length(data) <=6 then begin
 fmt:= $80 or (length(data)+1);
 Tgt := TargetDevice;
 Src := SourceDevice;
 Sld := DataType;
 setlength(OutPackage,4);
 OutPackage[ 0 ] := Fmt;
 OutPackage[ 1 ] := Tgt;
 OutPackage[ 2 ] := Src;
 OutPackage[ 3 ] := Sld;
end else begin
 Fmt := $80;
 Tgt := TargetDevice;
 Src := SourceDevice;
 Len := DataLength;
 Sld := DataType;
 setlength(OutPackage,5);
 OutPackage[ 0 ] := Fmt;
 OutPackage[ 1 ] := Tgt;
 OutPackage[ 2 ] := Src;
 OutPackage[ 3 ] := Len;
 OutPackage[ 4 ] := Sld;
end;
    // ��������� ���� �� ������
 if Length( Data ) > 0 then begin
  for i := 0 to Length( Data ) - 1 do begin
   SetLength( OutPackage, Length( OutPackage ) + 1 );
   OutPackage[length(OutPackage) - 1] := Data[ i ];
  end;
 end;
 //��������� ����������
    CS := CalculateCRC( OutPackage );
    SetLength( OutPackage, Length( OutPackage ) + 1 );
    OutPackage[ Length( OutPackage ) - 1 ] := CS;
  // ���������� ������ � ����
  WritePort( OutPackage );
  s:='������  ->  ';
   for i := 0 to length ( OutPackage ) - 1 do s:=S+' '+inttohex( OutPackage[i], 2);
  // SaveLogConnect(s);
  // �������� ������ ������
  SetLength( InPackage, 2048 );
  // ��������� ����� �� �����
  ReadPort( InPackage, InCount );
  // ��������� ���
  SetLength( Package, 2048 );
  if (InCount = 0) or (InCount = length(OutPackage)) then begin
   inc(ErrorRead,1);
   mainform.Memo1.Lines.Add('��� ������ ��� = ' + IntToStr(ErrorRead));

   if ErrorRead > 10 then begin
    Flag_outDiag:=true;
    mainform.Memo1.Lines.Add('������ ���� ������ �����!');
    ErrorRead:=0;
   exit;
   //Application.ProcessMessages;
   end;

  end;
CheckECHO( OutPackage, InPackage, InCount, Package, Count );
  s:='�����   <-  ';
   for i := 0 to Count do s:=S+' '+inttohex( Package[i], 2);
   SaveLogConnect(s);
  // ��������� �������� ������
  FlagWriteIsNew:=True;
  WorkWithData( Package, Count );
  FlagWriteIsNew:=False;
end;
//------------------------------------------------------------------------------
//--������ ��� ���
procedure TOBDII.ReadKeyHash;
var
 Data : array of Byte;
begin
//������ �� ������ ������ - 85 10 F1 23 00 00 C0 10 79.
 SetLength( Data, 4 );
  Data[ 0 ] := $00;
  data[ 1 ] := $00;
  data[ 2 ] := $C0;
  data[ 3 ] := $10;
SendPackage( sysEngine, sysDiag, $23, Data, 0 );
end;
//--------��������������� ��������� ��� �����������
function Tobdii.convertSnKey(data: array of Byte):string;
var
i:integer;
begin
result:='';
if length(data) = 0 then exit('');
  for i := 0 to length(data)-1 do
  result:=result+inttohex(data[i],2);
end;
/////-----------------------------------------------
//���������� ������� � ���
Procedure TobdII.WriTeDataOLT(Data: array of Byte; StartAddrXram: Integer);
var
i,s,r,f:integer;
DataPack:array of byte;
SizePack:integer;
begin
F:=0;
SizePack:=0;
//s - ���������� ������ ��� ��������
//r - ���� �����
//���������� ���������� ������ ��� �������� � ����
 s:=length(data) div 96;
 if (length(data) mod 96) > 0 then s:= s + 1;

 //���� �����
for r := 1 to s do begin
mainform.Reload_status(r,s);
//����������� ������� ������
 if (length(data) mod 96) > 0 then begin
   if R < S then SizePack:=96;
   if S = R then SizePack:=length(data)-((s-1)*96);
  end else begin
   SizePack:=length(data) div s;
  end;
//����� ����� ��������� ���������� ������
SetLength(DataPack,SizePack+4);
  DataPack[0]:=$00;
  DataPack[1]:=hi(StartAddrXram);// div 256;
  DataPack[2]:=lo(StartAddrXram);
  DataPack[3]:=SizePack;
   for i := 0 to SizePack - 1 do
    DataPack[i+4]:=Data[i+f] xor keyHash[i];
    StartAddrXram:=StartAddrXram + SizePack;
    F:=F+SizePack;
    if Flag_outDiag then BEGIN
     BREAK;
     EXIT;
    END;

    SendPackage( sysEngine, sysDiag, $3d, DataPack, SizePack + 5 );
end;//����� ������
mainform.Reload_status(0,0);
end;
//----------------------------------------------------
//��������� ��������
procedure tobdii.WriteTableClearO2;
var
i,s,startAddr:integer;
data: array of byte;
//a,b:byte;
begin
startAddr:=$FD00;
setlength(data,68);

 for i := 1 to 4 do begin
  data[0]:=$00;
  data[1]:=startaddr div 256;
  data[2]:=startaddr;
  data[3]:=$40;
   for s := 0 to 63 do begin
    data[s+4]:=$80;
   end;
   inc( startaddr, 64);//:=startAddr+64;
    sleep(1);
    SendPackage( sysEngine, sysDiag, $3d, Data, $45 );
 end;
end;

//������������ ������ swith to ram
procedure TOBDII.SwitchToRam;
var
 Data : array of Byte;
begin
//������ �� ������ ������ - 85 10 F1 23 00 00 C0 10 79.
//0x84, 0x10, 0xF1, 0x30, 0x0F, 0x06, 0x01, 0xCB
 SetLength( Data, 3 );
  Data[ 0 ] := $0F;
  data[ 1 ] := $06;
  data[ 2 ] := $01;
 SendPackage( sysEngine, sysDiag, $30, Data, 0 );
end;

//------------------------------------------------------------------------------
// ��������� ���������� � ������������
function TOBDII.ConnectToECU: boolean;
begin
  StartCommunication;//������������� ���
  if not (FCommunication) then begin
   stop;
   result:=False;
   exit;
  end;

  if not StartDiagnosticSession then begin
   stop;
   exit(false);//��������� �������� �����
  end;
  if not TesterPresent then begin
   stop;
   exit(false);
   end;

  if (FlagOLT) and (FCommunication) then
  begin
   SwitchToRam;//������������ ������
  if not FlagSwitchToRam then  SwitchToRam;
  if not FlagSwitchToRam then  SwitchToRam;
  if not FlagSwitchToRam then  SwitchToRam;
  if (FlagSwitchToRam) and (FlagOLT) then ReadKeyHash;//������ ��� ���
  if not FlagSnKey then readKeyHash;
  if not FlagSnKey then readKeyHash;

  end;
  if ( FCommunication ) and ( FDiagnosticSession ) then Exit( true ) else begin
  stop;
   Exit( false );
  end;
end;
//---------------------------------------------------------------------------------
procedure TOBDII.GetECUComplectation;
var
 // Data: array of byte;
  i:integer;
begin
//--- ������������ ������
   if not FlagSwitchToRam  then SwitchToRam;
  //������ ���������
   if (not FlagSnKey) and (FlagSwitchToRam) then
    begin
     readKeyHash;
    mainform.RzStatusPane1.Caption:='Sn: '+convertSnKey(snkey);
    end;

//������ �������� � ���
   if (FlagWriteFirmware = true) and (FlagSnKey) then begin
     WriTeDataOLT(TableFirmwareOlt,$5F00);
     FlagWriteFirmware:=false;
   end;
//--- ���������� ������
   if FlagRewraiteTableOLT then begin
    if LicenseError then begin
     FlagRewraiteTableOLT:=false;
     Showmessage('��� ��������, ���������� �� �����!');
     exit;
    end;
     WriTeDataOLT(TableOLT,StartAddrTableOLT);//���������� ������������ ������� ���
     FlagRewraiteTableOLT:=False;
   end;
   //���������� ���
if FlagRewraiteTableBCN then  begin
  if SatartAddrBCN > 0 then WriTeDataOLT(TableBCN,SatartAddrBCN);
  FlagRewraiteTableBCN:=fALSE;
end;
 //���������� ����
 if FlagRewraiteTableFAZA then  begin
  if SatartAddrfaza > 0 then WriTeDataOLT(TableFAZA,SatartAddrfaza);
  FlagRewraiteTableFAZA:=fALSE;
end;
 if FlagWriteIO then begin
 FlagOKIO:=False;
 for I := 1 to 5 do begin
 if FlagOKIO then  break;
 SendPackage( sysEngine, sysDiag, $30, Data_IO, 0 );
 end;
 FlagWriteIO:=False;
 if self.FlagOKIO then mainform.Reload_IO;
 end;
//������ ��������������� ������
   if (FlagSnKey) and (FlagSwitchToRam) then ReadDataEcuOLT;
//�������� ������
   if Flag_Clear_Error then ClearError;
//���������� ����� ������
   if Flag_Read_Error then ReadErrorECU;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// TesterPresent
function TOBDII.TesterPresent:boolean;
var
  Data: array of byte;
begin
  SetLength( Data, 1 );
  Data[ 0 ] := $01;
  SendPackage( sysEngine, sysDiag, $3E, Data, 0 );
  if TesterPres then exit(true) else exit(false);

end;

///------������ ��� ������
Procedure Tobdii.ReadDataEcuOLT;
var
Data: array of byte;
begin
setlength(data,1);
if (DIAG_DATA = 'FB9C') or (DIAG_DATA = 'D0F1')  then begin
 data[0]:=$0D;
end
else begin
 data[0]:=$0F;
end;
SendPackage( sysEngine, sysDiag, $21, Data, 0 );
end;

//----������ ����� ������
procedure tobdii.ReadErrorECU;
var
Data: array of byte;
begin
setlength(data,3);
   data[0]:=$00;
   data[1]:=$00;
   data[2]:=$00;
   SendPackage( sysEngine, sysDiag, $18, Data, 0 );
end;

procedure tobdii.ClearError;
var
data:array of byte;
begin
setlength(data,2);
   data[0]:=$00;
   data[1]:=$00;
    SendPackage( sysEngine, sysDiag, $14, Data, 0 );
end;
//------------------------------------------------------------------------------
//���������� ���� J7ES
procedure TOBDII.SaveLogJ7ES(S: string);
var
{$LongStrings ON }
LogFile:textfile;
filename:string;
F:string;
PUt:string;
begin
  fileName :='Logs\'+LogTimeName+'.csv';
 PUt:= ExtractFileDir(application.exename );
   if not FileExists(fileName) then begin
    AssignFile(LogFile,fileName);
    Rewrite(LogFile);
F:='Time, ���� ��������� ���, ���� ��������� ����, ���� ����������� ����������, ���� ���������� �������������, ���� ���� ������������� �� ��, ���� ��������� � ���� ���������, �������� ���������, ���������� �� ��������, '
+'fXXPrev, fXXFix, ���� ����������� ���������, ��������� ��, ���� ���������� ��, ������ ��, ��� ��, ��� ����, ��� ����, '
+'��� ���, ��� ���, ��� ��1, ��� ��, ��� ����, RPM_RT, RPM_RT_16, THR_RT_16, RPM_THR_RT, '
+'GBC_RT, GBC_RT_16, RPM_GBC_RT, PRESS_RT, TWAT_RT, ����������� ���������, �������� �������������, '
+'StartFlags, PXX_ZONE, DELAY_FUEL_CUTOFF, TLE_PIN_0_7, TLE_PIN_8_15,  THR, RPM40, '
+'RPM, LaunchFuelCutOff, JUFRXX, JFRXX1, JFRXX2, DERR_RPM, DELTA_RPM_XX, TWAT, TAIR, '
+'SSM, UFRXX, UOZ, KUOZ1, KUOZ2, KUOZ3, KUOZ4, DUOZ, UOZ_TCORR, DUOZ_REGXX, DIUOZ, '
+'DUOZ_LAUNCH,  �������� ������ �������, �������� ����������, UGB_RXX, ��������, ����-� ��������� �� �� ��, Tcharge, FchargeGBC, FchargeGBCFin, '
+'���_TPS, '
+'���_���, ALF, AFR,  AFR_WBL, KGBC_PIN, KGTC, COEFF, DGTC_LEAN, DGTC_RICH, DGTC_DadRich, '
+'KINJ_AIRFREE, INJ, INJ_DUTY, EGT, WGDC, TARGET_BOOST, Faza, �������� ����, '
+'Knock, ErrCnt, Errors, LC_COEFF, ������ ���� �������, LC_AFR, PCN_GEN, NEW_PCN_GEN, ADCKNOCK_AVG, FAZA_INJ_GEN, '
+'lc_EGT, ��������� ��, RPM_RT_32, TRT_RT_32, DAD_RT_32, �-� ������ �������, ������� ������� ���� ���, ����� ������������, ����� ��������';
    WriteLn(Logfile,f);
    CloseFile(LogFile);
   end;// else fileName:=fileName+'.'+'1.csv';

   AssignFile(LogFile,fileName);
   Append(LogFile);
   WriteLn(LogFile, S);
   CloseFile(LogFile);

end;
//-----------���������� ���� OLT v1-------------------------------------------------------------
procedure Tobdii.SaveLog_OLT_V1(S: string);
var
LogFile:textfile;
filename:string;
F:string;
i:integer;
begin
i:=0;
try
 if not NewLog then begin
  repeat
   fileName :='OLT_V1_'+IntToStr(i)+'.csv';
   Inc(i,1);
  until not FileExists('Logs\'+fileName) ;
  NewLog:=true;//�������� ��� �� ����� ����� ���� ���������
  LogName:=fileName;//����������� ��� �����, ������
end;
  FileName:=LogName;
  if not FileExists('Logs\'+fileName) then begin
  // AssignFile(LogFile,fileName);
   AssignFile(LogFile,'Logs\' +  fileName);
  Rewrite(LogFile);
F:='TIME, ���� ��������� ���, �������� ���, ���������� ����������,'
+' ���������� �������, ���� ������������� ��, ���� ���������, �������� ���������, ���������� �������� �� ��, fXXPrev,'
+' fXXFix, ����������� ���������, ������� ��������� ��, �������� ����� RPM_GBC_RT, TWAT, AFR, RCO, ��������� ��������, RPM40, '
+'RPM, �������� ��������� ���, ������� ��������� ���, coeff, faza_INJ, UOZ, KUOZ1, KUOZ2, KUOZ3, KUOZ4, '
+'ADCKNOCK, ADCMAF, ADCUBAT, ADCRCO, ADCTPS, ADCTWAT, ADCTAIR, ADCLAM, fLAMRDY, '
+'fLAMHEAT, ��������, �������� ������� ��������� ����, TAIR, DGTC_LEAN,'
+' DGTC_RICH, ����� �������, �������� ������ �������, �������� ������ �������, '
+'FRM, Errors, ��������, AFR_LC, COEFF_LC, ������ ���� �������, LC_AFR, ���, ���_NEW,'
+' ADCKNOCK_AVG, '
+'FAZA_INJ_GEN, �������� ��������, EGT, ��������� ��(��/���), RPM_RT_32, TRT_RT_32, DAD_RT_32, '
+'RPM_RT_16, TRT_RT_16, DAD_RT_16, ����� ������������';
    WriteLn(Logfile,f);
    CloseFile(LogFile);
   end;// else fileName:=fileName+'.'+'1.csv';
     //if not FileExists('Logs\'+fileName) then begin
  // AssignFile(LogFile,fileName);

   AssignFile(LogFile,'Logs\' +  fileName);
   Append(LogFile);
   WriteLn(LogFile, S);
   CloseFile(LogFile);
except
  mainform.Memo1.Lines.Add('������ � ���������� ���� ���_1');
end;
end;
//���������� ���� �����

procedure Tobdii.SaveLogConnect(S: string);
var
LogFile:textfile;
filename:string;
begin
{
  fileName :='LogConnect '+LogTimeName+'.log';
  if not FileExists('Logs\'+fileName) then begin
  AssignFile(LogFile,'Logs\' +  fileName);
  Rewrite(LogFile);
  WriteLn(Logfile,s);
  CloseFile(LogFile);
  end else begin
   AssignFile(LogFile,'Logs\' + fileName);
   Append(LogFile);
   WriteLn(LogFile, s);
   CloseFile(LogFile);
  end;
  }
end;
function TOBDII.ReadDiagData(ID: Integer):Double;
begin
result:=0;
{RPM
TPS
DAD
GBC
AFR

UOZ
COEFF
INJ
TWAT
TAIR
SSM}
 case ID of
 0:begin
 result:=Round(FsensorCrankshaftSpeed);
 end;
 //----------------------------
 1:begin
  result:=Round(FsensorThrottlePosition);
 end;
 //----------------------------
 2:begin
  result:=Round(self.FsensorPressure);
 end;
 //------------------------------
 3:begin
 result:=Round(self.FsensorAirCycleRate);
 end;
 //----------------------
 4:begin
 result:=FsensorAirFuelRatio;
 end;
 //-----------------------
 5:begin
 result:=FsensorSparkAngle;
 end;
 //-----------------------
 6:begin
 result:=self.FsensorFuelTimeCorrection;
 end;
 //-------------------------
 7:begin
 result:=StrToFloat(FormatFloat('#0.#',FsensorFuelTimeLength));
 //result:=self.FsensorFuelTimeLength;
 end;
 //--------------------------
 8:begin
 result:=round(FsensorCoolantTemp);
 end;
 //-----------------------------
 9:begin
 result:=round(self.FsensorTAIR);
 end;
 //---------------------------
 10:begin
 result:=round(self.FsensorIdleDoublePosition);
 end;
 //-------- ��� �� -----------
 11:begin
 result:=self.FsensotKNOCkVoltage ;
 end;
 //------- ��� ����/���
 12:begin
  result:=self.FsensorDmrvVoltage  ;
 end;
 //---------- ��� ��������
 13:begin
   result:=self.FsensorTPSVoltage;
 end;
 //---------- ��� ��
 14:begin
  result:=self.FsensorLamMdaVoltage_2;
 end;
 //----------- �������� ����
 15:begin
  result:=self.FsensorCarSpeed;
 end;
 //---------- ����� �������
 16:begin
  result:=self.FsensorFuelTimeLength;
 end;
 //------ �������� ������ �������
 17:begin
   result:=self.FsensorAirWeightRate;
 end;
 18:begin
   //------�_������---------
   result:=Round(DiagData.Tcharge);
 end;
 19:begin
 //���
   result:=StrToFloat(FormatFloat('#0.#',FsensorVoltage));
 end;
 20:begin
   //--- �������� �������� ---------
   Result:=round(InjDuty);
 end;
 21:begin
   //afr_wbl
   result:=obdii.fsensor_wbl;
 end;
 22:begin
   //faza
    result:=obdii.FsensorFazaIngection;
 end;
 23:BEGIN
   //EGT
  result:=obdii.FSENSOREGT;
 END;
 24:begin
   //����� ��������
   result:=obdii.number_shift;
 end;
 end;
end;
// StartCommunication. ��������� ���������� � ���(������������� �����)
procedure TOBDII.StartCommunication;
var
S:String;
begin
SleepTimeWrite:=200;
sleepTimeRead:=30;
S:='StartCommunication';
  SendPackage( sysEngine, sysDiag, $81 );
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// ������ ��������������� ������ (��������� �������� �����)
function TOBDII.StartDiagnosticSession: boolean;
var
  Data: array of byte;
  DCB : TDCB;
 // speed: integer;
begin
result:=False;
  SetLength( Data, 2 );
  Data[ 0 ] := $81;
  case FBaudRate of
    10400: Data[ 1 ] := $0A;
    38400: Data[ 1 ] := $26;
    57600: Data[ 1 ] := $39;
  end;

  SendPackage( sysEngine, sysDiag, $10, Data, 0 );

 if StartDiagSession then begin
  GetCommState( hCOMPort, DCB );
  DCB.BaudRate := FBaudRate;  //10400;
  DCB.ByteSize := 8;
  DCB.Parity   := NOPARITY;
  DCB.StopBits := ONESTOPBIT;
  // �������� ��������� �����
  if not SetCommState( hCOMPort, DCB ) then begin
    //TODO: ���������� ������ ����������� ���������� �����
    Exit(False);
  end else exit(true);
 end;

end;
//------------------------------------------------------------------------------
function TobdII.stopDiagnosticSession : boolean;//���������� �����������
begin
SendPackage( sysEngine, sysDiag, $20 );
if FDiagnosticSession then begin
 exit(false);
 end else exit(true);
end;

function tobdii.stopCommunication : boolean;//���������� �����
var
DCB:TDCB;
begin
  GetCommState( hCOMPort, DCB );
  DCB.BaudRate := 10400;
  DCB.ByteSize := 8;
  DCB.Parity   := NOPARITY;
  DCB.StopBits := ONESTOPBIT;
  SetCommState( hCOMPort, DCB );
 SendPackage( sysEngine, sysDiag, $82 );
 if FCommunication  then exit(false) else exit(true);
end;
//������ ������
 procedure Tobdii.ParseData_RDBLI_J7ES(var Data: array of Byte);
 begin
 PRec_RDBLI_j7ES.Mode1:=data[1];
 PRec_RDBLI_j7ES.Mode2:=data[2];
 PRec_RDBLI_j7ES.ErrCnt:=data[3];
 PRec_RDBLI_j7ES.Err1:=data[4];
 PRec_RDBLI_j7ES.Err2:=data[5];
 PRec_RDBLI_j7ES.Err3:=data[6];
 PRec_RDBLI_j7ES.Err4:=data[7];
 PRec_RDBLI_j7ES.RPM_GBC_RT:=data[8];
 PRec_RDBLI_j7ES.Twat:=data[9];
 PRec_RDBLI_j7ES.ALF:=data[10];
 PRec_RDBLI_j7ES.DDSF:=data[11];
 PRec_RDBLI_j7ES.THR:=data[12];
 PRec_RDBLI_j7ES.RPM40:=data[13];
 PRec_RDBLI_j7ES.RPM10:=data[14];
 PRec_RDBLI_j7ES.CycleTime:=data[15]+data[16]*256;
 PRec_RDBLI_j7ES.UFRXX:=data[17];
 PRec_RDBLI_j7ES.SSM:=data[18];
 PRec_RDBLI_j7ES.COEFF:=data[19];
 PRec_RDBLI_j7ES.FAZA:=data[20];
 if length( data ) < 21 then exit;
 PRec_RDBLI_j7ES.UOZ:=data[21];
 if length( data ) < 22 then exit;
 PRec_RDBLI_j7ES.KUOZ1:=data[22];
 if length( data ) < 23 then exit;
 PRec_RDBLI_j7ES.KUOZ2:=data[23];
 if length( data ) < 24 then exit;
 PRec_RDBLI_j7ES.KUOZ3:=data[24];
 if length( data ) < 25 then exit;
 PRec_RDBLI_j7ES.KUOZ4:=data[25];
 if length( data ) < 26 then exit;
 PRec_RDBLI_j7ES.ADCKNOCK:=data[26];
 if length( data ) < 27 then exit;
 PRec_RDBLI_j7ES.ADCMAF:=data[27];
 if length( data ) < 28 then exit;
 PRec_RDBLI_j7ES.ADCUBAT:=data[28];
 if length( data ) < 29 then exit;
 PRec_RDBLI_j7ES.ATIM:=data[29];
 PRec_RDBLI_j7ES.ADCTPS:=data[30];
 PRec_RDBLI_j7ES.ADCTWAT:=data[31];
 PRec_RDBLI_j7ES.ADCTAIR:=data[32];
 PRec_RDBLI_j7ES.ADCLAM1:=data[33];
 PRec_RDBLI_j7ES.DKState:=data[34];
 PRec_RDBLI_j7ES.SAS:=data[35];
 PRec_RDBLI_j7ES.SPD:=data[36];
 PRec_RDBLI_j7ES.T_JUFRXX:=data[37];
 PRec_RDBLI_j7ES.Tair:=data[38];
 PRec_RDBLI_j7ES.ADCLAM:=data[39];
 if length( data ) < 41 then exit;
 PRec_RDBLI_j7ES.DGTC_RICH:=data[40]+data[41]*256;
 PRec_RDBLI_j7ES.DGTC_LEAN:=data[42]+data[43]*256;
 PRec_RDBLI_j7ES.INJ:=data[44]+data[45]*256;
 PRec_RDBLI_j7ES.AIR:=data[46]+data[47]*256;
 PRec_RDBLI_j7ES.GBC:=data[48]+data[49]*256;
 PRec_RDBLI_j7ES.FRH:=data[50]+data[51]*256;
 //����� ��� v1
 if length( data ) < 52 then exit;
 PRec_RDBLI_j7ES.PRESS_RT:=data[52];
 PRec_RDBLI_j7ES.Tcharge:=data[53];
 PRec_RDBLI_j7ES.TchargeCoeff:=data[54];
 PRec_RDBLI_j7ES.DUOZ:=data[55];
 PRec_RDBLI_j7ES.LaunchFuelCutOff:=data[56];
 PRec_RDBLI_j7ES.KGTC:=data[57];
 if length( data ) < 58 then exit;
 PRec_RDBLI_j7ES.coefficient_vibora_tcharge:=data[58];
 PRec_RDBLI_j7ES.KGBC_TPS:=data[59];
 PRec_RDBLI_j7ES.KGBC_DAD:=data[60];
 if length( data ) < 61 then exit;
 PRec_RDBLI_j7ES.UOZ_TCORR:=data[61];
 PRec_RDBLI_j7ES.ALF_WBL:=data[62];
 PRec_RDBLI_j7ES.EGT:=data[63];
 PRec_RDBLI_j7ES.JUFRXX:=data[64];
 PRec_RDBLI_j7ES.JFRXX1:=data[65];
 PRec_RDBLI_j7ES.JFRXX2:=data[66];
 PRec_RDBLI_j7ES.KINJ_AIRFREE:=data[67];
 PRec_RDBLI_j7ES.DUOZ_REGXX:=data[68];
 PRec_RDBLI_j7ES.DERR_RPM:=data[69];
 PRec_RDBLI_j7ES.DIUOZ:=data[70];
 PRec_RDBLI_j7ES.DELAY_FUEL_CUTOFF:=data[71];
 PRec_RDBLI_j7ES.TLE_PIN_0_7:=data[72];
 PRec_RDBLI_j7ES.TLE_PIN_8_15:=data[73];
 PRec_RDBLI_j7ES.J7ES_EGT:=data[74];
 PRec_RDBLI_j7ES.WGDC:=data[75];
 PRec_RDBLI_j7ES.FAZA_J7:=data[76];
 PRec_RDBLI_j7ES.UOZCORR_GTC:=data[77];
 PRec_RDBLI_j7ES.TIME_HIP9011:=data[78];
 PRec_RDBLI_j7ES.number_shift:=data[78];

 PRec_RDBLI_j7ES.TWAT_RT:=data[79];
 PRec_RDBLI_j7ES.RPM_RT:=data[80];
 fsensor_rpm_rt_32:=((data[80]+4) shr 4 ) and $1F;
 PRec_RDBLI_j7ES.RPM_THR_RT:=data[81];
 PRec_RDBLI_j7ES.RAM_2A:=data[82];
 PRec_RDBLI_j7ES.DELTA_RPM_XX:=data[83];
 PRec_RDBLI_j7ES.PXX_ZONE:=data[84];
 PRec_RDBLI_j7ES.RAM_2D:=data[85];
 PRec_RDBLI_j7ES.StartFlags:=0;
 PRec_RDBLI_j7ES.UGB_RXX:=0;
 PRec_RDBLI_j7ES.DUOZ_LAUNCH :=data[86];
 PRec_RDBLI_j7ES.GBC_RT:=data[87];
 PRec_RDBLI_j7ES.Knock:=data[89]*256+data[88];
 if length( data ) < 91 then exit;
 PRec_RDBLI_j7ES.FchargeGBC:=StrToInt( '$' +StringReplace( ( IntToHex( Data[91],2 ) + IntToHex( Data[90],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) );
 PRec_RDBLI_j7ES.FchargeGBCFin:=StrToInt( '$' +StringReplace( ( IntToHex( Data[93],2 ) + IntToHex( Data[92],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) );
 PRec_RDBLI_j7ES.Press:=StrToInt( '$' +StringReplace( ( IntToHex( Data[95],2 ) + IntToHex( Data[94],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) );
 PRec_RDBLI_j7ES.DGTC_DadRich:= StrToInt( '$' +StringReplace( ( IntToHex( Data[97],2 ) + IntToHex( Data[96],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) );
 PRec_RDBLI_j7ES.TARGET_BOOST:=StrToInt( '$' +StringReplace( ( IntToHex( Data[99],2 ) + IntToHex( Data[98],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) );
 PRec_RDBLI_j7ES.avg_noise_hip:=StrToInt( '$' +StringReplace( ( IntToHex( Data[101],2 ) + IntToHex( Data[100],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) );
 end;

 procedure Tobdii.ParseData_OLT_v1(data: array of Byte);
 begin
 try
 Prec_diag_OLTv1.Mode1:=data[1];
 Prec_diag_OLTv1.Mode2:=data[2];
 Prec_diag_OLTv1.ErrCnt:=data[3];
 Prec_diag_OLTv1.Err1:=data[4];
 Prec_diag_OLTv1.Err2:=data[5];
 Prec_diag_OLTv1.Err3:=data[6];
 Prec_diag_OLTv1.Err4:=data[7];
 Prec_diag_OLTv1.RPM_GBC_RT:=data[8];
 Prec_diag_OLTv1.Twat:=data[9];
 Prec_diag_OLTv1.ALF:=data[10];
 Prec_diag_OLTv1.DDSF:=data[11];
 Prec_diag_OLTv1.THR:=data[12];
 Prec_diag_OLTv1.RPM40:=data[13];
 Prec_diag_OLTv1.RPM10:=data[14];
 Prec_diag_OLTv1.CycleTime:=StrToInt( '$' +StringReplace( ( IntToHex( Data[16],2 ) + IntToHex( Data[15],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) );
 Prec_diag_OLTv1.UFRXX:=data[17];
 Prec_diag_OLTv1.SSM:=data[18];
 Prec_diag_OLTv1.COEFF:=data[19];
 Prec_diag_OLTv1.FAZA:=data[20];
 Prec_diag_OLTv1.UOZ:=data[21];
 Prec_diag_OLTv1.KUOZ1:=data[22];
 Prec_diag_OLTv1.KUOZ2:=data[23];
 Prec_diag_OLTv1.KUOZ3:=data[24];
 Prec_diag_OLTv1.KUOZ4:=data[25];
 Prec_diag_OLTv1.ADCKNOCK:=data[26];
 Prec_diag_OLTv1.ADCMAF:=data[27];
 Prec_diag_OLTv1.ADCUBAT:=data[28];
 Prec_diag_OLTv1.ATIM:=data[29];
 Prec_diag_OLTv1.ADCTPS:=data[30];
 Prec_diag_OLTv1.ADCTWAT:=data[31];
 Prec_diag_OLTv1.ADCTAIR:=data[32];
 Prec_diag_OLTv1.ADCLAM1:=data[33];
 Prec_diag_OLTv1.DKState:=data[34];
 Prec_diag_OLTv1.SAS:=data[35];
 Prec_diag_OLTv1.SPD:=data[36];
 Prec_diag_OLTv1.T_JUFRXX:=data[37];
 Prec_diag_OLTv1.Tair:=data[38];
 Prec_diag_OLTv1.ADCLAM:=data[39];
 Prec_diag_OLTv1.DGTC_RICH:=StrToInt( '$' +StringReplace( ( IntToHex( Data[41],2 ) + IntToHex( Data[40],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) );
 Prec_diag_OLTv1.DGTC_LEAN:=StrToInt( '$' +StringReplace( ( IntToHex( Data[43],2 ) + IntToHex( Data[42],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) );
 Prec_diag_OLTv1.INJ:=StrToInt( '$' +StringReplace( ( IntToHex( Data[45],2 ) + IntToHex( Data[44],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) );
 Prec_diag_OLTv1.AIR:=StrToInt( '$' +StringReplace( ( IntToHex( Data[47],2 ) + IntToHex( Data[46],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) );
 Prec_diag_OLTv1.GBC:=StrToInt( '$' +StringReplace( ( IntToHex( Data[49],2 ) + IntToHex( Data[48],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) );
 Prec_diag_OLTv1.FRH:=StrToInt( '$' +StringReplace( ( IntToHex( Data[51],2 ) + IntToHex( Data[50],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) );
 except
  mainform.Memo1.Lines.Add('������ ������������ ������ ParseData_OLT_v1(data)');
 end;
 end;

 procedure TOBDII.ParseDataDiag;
 var
 LogData:string;
 I:integer;
 AVG_KNO:Double;
 begin
 AVG_KNO:=0;
 with PRec_RDBLI_j7ES do begin
DiagData.fSTOP := Mode1 and 1 <> 0;
DiagData.fXX := Mode1 and 2 <> 0;
DiagData.fPOW := Mode1 and 4 <> 0;
DiagData.fFUELOFF := Mode1 and 8 <> 0;
DiagData.fLAMREG := Mode1 and 16 <> 0;
DiagData.fDETZONE := Mode1 and 32 <> 0;
DiagData.fADS := Mode1 and 64 <> 0;
DiagData.fLEARN := Mode1 and 128 <> 0;
    DiagData.fXXPrev := Mode2 and 2 <> 0;
    DiagData.fXXFix := Mode2 and 4 <> 0;
    DiagData.fDET := Mode2 and 32 <> 0;
    DiagData.fLAM := Mode2 and 128 <> 0;
    DiagData.fLAMRDY := DKState and 1 <> 0;
    DiagData.fLAMHEAT := DKState and 2 <> 0;
    DiagData.ADCKNOCK := ADCKNOCK * 0.01953125; //  *5/256
    DiagData.ADCMAF := ADCMAF * 0.01953125;     //05859
    DiagData.ADCTWAT := ADCTWAT * 0.01953125;
    DiagData.ADCTAIR := ADCTAIR * 0.01953125;
    DiagData.ADCUBAT := ADCUBAT * 0.093;
    diagData.ADCLAM1 := (adclam1 / 256 ) * 1.25;
    DiagData.ADCLAM := (ADCLAM / 256) * 1.25;
    DiagData.ADCTPS := ADCTPS * 0.01953125;
    DiagData.RPM_RT := RPM_RT;
    DiagData.RPM_RT_16 := (RPM_RT+16) div 16;
    DiagData.THR_RT_16 := (RPM_THR_RT and $F0) shr 4;
    DiagData.RPM_THR_RT := RPM_THR_RT;
    diagdata.coefficient_vibora_tcharge:= round(coefficient_vibora_tcharge/256*100)/100;
    DiagData.GBC_RT := GBC_RT;
    DiagData.GBC_RT_16 := (GBC_RT + 16) div 16;
    DiagData.RPM_GBC_RT := RPM_GBC_RT;
    DiagData.PRESS_RT := PRESS_RT;
    DiagData.TWAT_RT := TWAT_RT;
    DiagData.KnockFlags := KnockFlags;
    DiagData.MisFireFlags := MisFireFlags;
    DiagData.StartFlags := StartFlags;
    DiagData.PXX_ZONE := PXX_ZONE;
    DiagData.DELAY_FUEL_CUTOFF := DELAY_FUEL_CUTOFF;
    DiagData.TLE_PIN_0_7 := TLE_PIN_0_7;
    DiagData.TLE_PIN_8_15 := TLE_PIN_8_15;
    DiagData.THR := THR;
    DiagData.RPM40 := RPM40 * 40 ;
if CycleTime <> 0 then DiagData.RPM := 5000000 div CycleTime else DiagData.RPM := 0;
 try
 if (DiagData.RPM> 0) and (oldrpm > 0) then begin
 if Time_Diag-OLDTIME > 0 then begin
  uskor:=(DiagData.RPM - oldrpm)/60/(Time_Diag-OLDTIME);
  uskor:=StrToFloat(FormatFloat('0.##0',uskor));
 end;
 end else uskor:=0;
 OLDTIME:=Time_Diag;
 oldrpm:=DiagData.RPM;
 finally

 end;

    DiagData.LaunchFuelCutOff := LaunchFuelCutOff * 40;

    DiagData.JUFRXX := JUFRXX * 10;

    DiagData.JFRXX1 := JFRXX1 * 10;

    DiagData.JFRXX2 := JFRXX2 * 10;

    DiagData.DERR_RPM := shortint(DERR_RPM) * 10;
    DiagData.DELTA_RPM_XX := shortint(DELTA_RPM_XX) * 10;

    DiagData.TWAT := Twat - 40;
    DiagData.TAIR := Tair - 40;

    DiagData.SSM := SSM;
    DiagData.UFRXX := UFRXX;

    //----------Double-------------
    if uoz and $80 = $80 then
    DiagData.UOZ :=round( (UOZ - 256) / 2 *10 )/10
    else
    DiagData.UOZ :=round( UOZ / 2 * 10) /10;
    {
    DiagData.KUOZ1 := shortint(KUOZ1) / 2;
    DiagData.KUOZ2 := shortint(KUOZ2) / 2;
    DiagData.KUOZ3 := shortint(KUOZ3) / 2;
    DiagData.KUOZ4 := shortint(KUOZ4) / 2;
    }
    DiagData.KUOZ1 := shortint(KUOZ1) * 5 / 256;//�������� ��� �� 1,2,3,4 ���������
    DiagData.KUOZ2 := shortint(KUOZ2) * 5 / 256;
    DiagData.KUOZ3 := shortint(KUOZ3) * 5 / 256;
    DiagData.KUOZ4 := shortint(KUOZ4) * 5 / 256;

    DiagData.DUOZ := shortint(DUOZ) / 2;
    DiagData.UOZ_TCORR := shortint(UOZ_TCORR) / 2;
    DiagData.DUOZ_REGXX := shortint(DUOZ_REGXX) / 2;
    DiagData.DIUOZ := shortint(DIUOZ) / 2;
    DiagData.DUOZ_LAUNCH := DUOZ_LAUNCH * 6;

    DiagData.AIR := AIR / 10;
    DiagData.GBC := GBC / 6;
    DiagData.UGB_RXX := UGB_RXX / 5;
    DiagData.Press := Press / 100;

    DiagData.TchargeCoeff := TchargeCoeff / 128;
    DiagData.Tcharge := Tcharge - 40;
    DiagData.FchargeGBC := FchargeGBC;
    DiagData.FchargeGBCFin := FchargeGBCFin;
    DiagData.KGBC_TPS := KGBC_TPS / 128;
    DiagData.KGBC_DAD := KGBC_DAD / 128;

    DiagData.ALF := (ALF + 128) / 256;
    DiagData.AFR := 14.7 * DiagData.ALF;
    DiagData.AFR_WBL := (ALF_WBL + 128) / 256 * 14.7;
    DiagData.KGBC_PIN :=EGT / 128;
    self.kgbc_pin:= EGT / 128;
    DiagData.KGTC := KGTC / 128;
    DiagData.COEFF := (COEFF + 128) / 256;
    DiagData.DGTC_LEAN := DGTC_LEAN / 256;
    DiagData.DGTC_RICH := DGTC_RICH / 256;
    DiagData.DGTC_DadRich := DGTC_DadRich / 256;
    DiagData.KINJ_AIRFREE := KINJ_AIRFREE / 256;
    DiagData.INJ := INJ / 125;

    if CycleTime <> 0 then DiagData.FUSE := INJ * 33.3 / CycleTime else DiagData.FUSE := 0;

    DiagData.TURBO_DYNAMICS := shortint(J7ES_EGT) * 4;
    DiagData.WGDC := WGDC * 100 / 255;
    DiagData.TARGET_BOOST := TARGET_BOOST / 100;
    DiagData.NS:=avg_noise_hip;
    DiagData.Faza := shortint(Faza) * 6;
    DiagData.SPD := SPD;
    DiagData.Knock := Knock;
    DiagData.number_shift:=number_shift;
    obdii.number_shift:=number_shift;
    DiagData.ErrCnt := ErrCnt;
    DiagData.Errors := Err4 shl 24 + Err3 shl 16 + Err2 shl 8 + Err1;

    DiagData.Errors:=0;
    DiagData.Errors :=ReadErrorCount(Err1) + ReadErrorCount(Err2) + ReadErrorCount(Err3) + ReadErrorCount(Err4);
     end;
    fsensorErrorCount:=DiagData.Errors;
for i := 1 to 50 do begin
if I < 50 then
 Fsensor_ADC_KNOCK[i]:=Fsensor_ADC_KNOCK[i+1];
 if I = 50 then  Fsensor_ADC_KNOCK[50]:=DiagData.ADCKNOCK;
AVG_KNO:=AVG_KNO+Fsensor_ADC_KNOCK[i];
end;
Fsensor_AVG_ADC_KNOCK:=AVG_KNO/50;
LogData:='';
LogData:=StringReplace(FloatToStr(self.Time_Diag),',','.',[rfReplaceAll, rfIgnoreCase]);
//LogData:=FormatDateTime('hh:mm:s.z', now);
LogData:=LogData + ', ' + self.ConvertBoolToInt(DiagData.fSTOP);
LogData:=LogData + ', ' + self.ConvertBoolToInt(DiagData.fXX);
LogData:=LogData + ', ' + self.ConvertBoolToInt(DiagData.fPOW);
LogData:=LogData + ', ' + self.ConvertBoolToInt(DiagData.fFUELOFF);
LogData:=LogData + ', ' + self.ConvertBoolToInt(DiagData.fLAMREG);
LogData:=LogData + ', ' + self.ConvertBoolToInt(DiagData.fDETZONE);
LogData:=LogData + ', ' + self.ConvertBoolToInt(DiagData.fADS);
LogData:=LogData + ', ' + self.ConvertBoolToInt(DiagData.fLEARN);
LogData:=LogData + ', ' + self.ConvertBoolToInt(DiagData.fXXPrev);
LogData:=LogData + ', ' + self.ConvertBoolToInt(DiagData.fXXFix);
LogData:=LogData + ', ' + self.ConvertBoolToInt(DiagData.fDET);
LogData:=LogData + ', ' + self.ConvertBoolToInt(DiagData.fLAM);
LogData:=LogData + ', ' + self.ConvertBoolToInt(DiagData.fLAMRDY);
LogData:=LogData + ', ' + self.ConvertBoolToInt(DiagData.fLAMHEAT);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.ADCKNOCK),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.ADCMAF),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.ADCTWAT),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.ADCTAIR),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.ADCUBAT),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.ADCLAM1),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.ADCLAM),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.ADCTPS),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + inttostr(DiagData.RPM_RT);
LogData:=LogData + ', ' + inttostr(DiagData.RPM_RT_16);
LogData:=LogData + ', ' + inttostr(DiagData.THR_RT_16);
LogData:=LogData + ', ' + inttostr(DiagData.RPM_THR_RT);
LogData:=LogData + ', ' + inttostr(DiagData.GBC_RT);
LogData:=LogData + ', ' + inttostr(DiagData.GBC_RT_16);
LogData:=LogData + ', ' + inttostr(DiagData.RPM_GBC_RT);
LogData:=LogData + ', ' + inttostr(DiagData.PRESS_RT);
LogData:=LogData + ', ' + inttostr(DiagData.TWAT_RT);
LogData:=LogData + ', ' + inttostr(DiagData.KnockFlags);
LogData:=LogData + ', ' + inttostr(DiagData.MisFireFlags);
LogData:=LogData + ', ' + inttostr(DiagData.StartFlags);
LogData:=LogData + ', ' + inttostr(DiagData.PXX_ZONE);
LogData:=LogData + ', ' + inttostr(DiagData.DELAY_FUEL_CUTOFF);
LogData:=LogData + ', ' + inttostr(DiagData.TLE_PIN_0_7);
LogData:=LogData + ', ' + inttostr(DiagData.TLE_PIN_8_15);
LogData:=LogData + ', ' + inttostr(DiagData.THR);
LogData:=LogData + ', ' + inttostr(DiagData.RPM40);
LogData:=LogData + ', ' + inttostr(DiagData.RPM);
LogData:=LogData + ', ' + inttostr(DiagData.LaunchFuelCutOff);
LogData:=LogData + ', ' + inttostr(DiagData.JUFRXX);
LogData:=LogData + ', ' + inttostr(DiagData.JFRXX1);
LogData:=LogData + ', ' + inttostr(DiagData.JFRXX2);
LogData:=LogData + ', ' + inttostr(DiagData.DERR_RPM);
LogData:=LogData + ', ' + inttostr(DiagData.DELTA_RPM_XX);
LogData:=LogData + ', ' + inttostr(DiagData.TWAT);
LogData:=LogData + ', ' + inttostr(DiagData.TAIR);
LogData:=LogData + ', ' + inttostr(DiagData.SSM);
LogData:=LogData + ', ' + inttostr(DiagData.UFRXX);
  LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.UOZ),',','.',[rfReplaceAll, rfIgnoreCase]);
  LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.KUOZ1),',','.',[rfReplaceAll, rfIgnoreCase]);
  LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.KUOZ2),',','.',[rfReplaceAll, rfIgnoreCase]);
  LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.KUOZ3),',','.',[rfReplaceAll, rfIgnoreCase]);
  LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.KUOZ4),',','.',[rfReplaceAll, rfIgnoreCase]);
  LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.DUOZ),',','.',[rfReplaceAll, rfIgnoreCase]);
  LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.UOZ_TCORR),',','.',[rfReplaceAll, rfIgnoreCase]);
  LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.DUOZ_REGXX),',','.',[rfReplaceAll, rfIgnoreCase]);
  LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.DIUOZ),',','.',[rfReplaceAll, rfIgnoreCase]);
  LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.DUOZ_LAUNCH),',','.',[rfReplaceAll, rfIgnoreCase]);
  LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.AIR),',','.',[rfReplaceAll, rfIgnoreCase]);
  LogData:=LogData + ', ' + IntToStr(round(DiagData.GBC));
  LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.UGB_RXX),',','.',[rfReplaceAll, rfIgnoreCase]);
  LogData:=LogData + ', ' + StringReplace(FloatToStr(FsensorPressure),',','.',[rfReplaceAll, rfIgnoreCase]);
  LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.TchargeCoeff),',','.',[rfReplaceAll, rfIgnoreCase]);
  LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.Tcharge),',','.',[rfReplaceAll, rfIgnoreCase]);
  LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.FchargeGBC),',','.',[rfReplaceAll, rfIgnoreCase]);
  LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.FchargeGBCFin),',','.',[rfReplaceAll, rfIgnoreCase]);
  LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.KGBC_TPS),',','.',[rfReplaceAll, rfIgnoreCase]);
  LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.KGBC_DAD),',','.',[rfReplaceAll, rfIgnoreCase]);
  LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.ALF),',','.',[rfReplaceAll, rfIgnoreCase]);
  LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.AFR),',','.',[rfReplaceAll, rfIgnoreCase]);
  LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.AFR_WBL),',','.',[rfReplaceAll, rfIgnoreCase]);
  LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.KGBC_PIN),',','.',[rfReplaceAll, rfIgnoreCase]);
  LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.KGTC),',','.',[rfReplaceAll, rfIgnoreCase]);
  LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.COEFF),',','.',[rfReplaceAll, rfIgnoreCase]);
  LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.DGTC_LEAN),',','.',[rfReplaceAll, rfIgnoreCase]);
  LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.DGTC_RICH),',','.',[rfReplaceAll, rfIgnoreCase]);
  LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.DGTC_DadRich),',','.',[rfReplaceAll, rfIgnoreCase]);
  LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.KINJ_AIRFREE),',','.',[rfReplaceAll, rfIgnoreCase]);
  LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.INJ),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.FUSE),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.TURBO_DYNAMICS),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.WGDC),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.TARGET_BOOST),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.Faza),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.SPD),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagData.Knock),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + inttostr(DiagData.ErrCnt);
LogData:=LogData + ', ' + inttostr(DiagData.Errors);
LogData:=LogData + ', ' + StringReplace(FloatToStr(FsensorFuelTimeCorrection),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + softname;
try
LogData:=LogData + ', ' + StringReplace(FloatToStr(lc1.AFR),',','.',[rfReplaceAll, rfIgnoreCase]);
Except
LogData:=LogData + ', ' + '0';
end;
LogData:=LogData + ', ' + StringReplace(FloatToStr(pcn_gen),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(self.new_pcn),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(self.Fsensor_AVG_ADC_KNOCK),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(FsensorGenFaza),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + IntToStr(lc1.EGT);
LogData:=LogData + ', ' + StringReplace(FloatToStr(uskor),',','.',[rfReplaceAll, rfIgnoreCase]);
//�������� ����� �� 32
LogData:=LogData + ', ' + inttostr(educationthread.educat_data.RPM_RT_32);
LogData:=LogData + ', ' + inttostr(educationthread.educat_data.TPS_RT_32);
LogData:=LogData + ', ' + inttostr(educationthread.educat_data.DAD_RT_32);
LogData:=LogData + ', ' + StringReplace(FloatToStr(diagdata.coefficient_vibora_tcharge),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(diagdata.NS),',','.',[rfReplaceAll, rfIgnoreCase]);
//����� ������������
LogData:=LogData + ', ' + inttostr(Flag_indicator);
//����� ��������
LogData:=LogData + ', ' + inttostr(diagdata.number_shift);
Flag_indicator:=0;
SaveLogJ7ES(LogData);
end;
 //---------------------
 procedure tobdii.ParseDataDiag_OLT_V1;
var
 LogData:string;
 I:integer;
 AVG_KNO:Double;
 begin
 AVG_KNO:=0;
try
 with Prec_diag_OLTv1 do begin
    DiagDataOLT_v1.fSTOP := Mode1 and 1 <> 0;
    DiagDataOLT_v1.fXX := Mode1 and 2 <> 0;
    DiagDataOLT_v1.fPOW := Mode1 and 4 <> 0;
    DiagDataOLT_v1.fFUELOFF := Mode1 and 8 <> 0;
    DiagDataOLT_v1.fLAMREG := Mode1 and 16 <> 0;
    DiagDataOLT_v1.fDETZONE := Mode1 and 32 <> 0;
    DiagDataOLT_v1.fADS := Mode1 and 64 <> 0;
    DiagDataOLT_v1.fLEARN := Mode1 and 128 <> 0;
    DiagDataOLT_v1.fXXPrev := Mode2 and 2 <> 0;
    DiagDataOLT_v1.fXXFix := Mode2 and 4 <> 0;
    DiagDataOLT_v1.fDET := Mode2 and 32 <> 0;
    DiagDataOLT_v1.fLAM := Mode2 and 128 <> 0;
    DiagDataOLT_v1.RPM_GBC_RT:=RPM_GBC_RT;
    DiagDataOLT_v1.TWAT:=Twat - 40;
    DiagDataOLT_v1.AFR:=14.7*(ALF+128)/256;
    DiagDataOLT_v1.RCO:=DDSF/256;
    DiagDataOLT_v1.THR:=THR;
    DiagDataOLT_v1.RPM40:=RPM40*40;
 if CycleTime <> 0 then DiagDataOLT_v1.RPM := 5000000 div CycleTime else DiagDataOLT_v1.RPM := 0;
 try
 if (DiagDataOLT_v1.RPM > 0) and (oldrpm > 0) then begin
 if Time_Diag-OLDTIME <>0 then
  uskor:=((DiagDataOLT_v1.RPM - oldrpm)/60)/(Time_Diag-OLDTIME);
  uskor:=StrToFloat(FormatFloat('0.##0',uskor));
 end else uskor:=0;
 OLDTIME:=self.Time_Diag;
 oldrpm:=DiagDataOLT_v1.RPM;
 except
  mainform.Memo1.Lines.Add('������ � ������� ��������� �������� ���_1');
 end;
    DiagDataOLT_v1.UFR_SSM:=UFRXX;
    DiagDataOLT_v1.SSM:=ssm;
    diagdataolt_v1.coeff:=(COEFF+128)/256;
    DiagDataOLT_v1.faza_INJ:=FAZA*6;
        //----------Double-------------
        if UOZ > 128 then
         DiagDataOLT_v1.UOZ := (shortint(UOZ) - 256 ) / 2
         else
    DiagDataOLT_v1.UOZ := shortint(UOZ) / 2;

    DiagDataOLT_v1.KUOZ1 := shortint(KUOZ1) / 2;
    DiagDataOLT_v1.KUOZ2 := shortint(KUOZ2) / 2;
    DiagDataOLT_v1.KUOZ3 := shortint(KUOZ3) / 2;
    DiagDataOLT_v1.KUOZ4 := shortint(KUOZ4) / 2;


    DiagDataOLT_v1.ADCKNOCK := ADCKNOCK * 0.01953125; //  *5/256
    DiagDataOLT_v1.ADCMAF := ADCMAF * 0.01953125;
    DiagDataOLT_v1.ADCUBAT := ADCUBAT * 0.093;
    DiagDataOLT_v1.ADCRCO:= ATIM;
    DiagDataOLT_v1.ADCTPS := ADCTPS * 0.01953125;
    DiagDataOLT_v1.ADCTWAT := ADCTWAT * 0.01953125;
    DiagDataOLT_v1.ADCTAIR := ADCTAIR * 0.01953125;
    DiagDataOLT_v1.ADCLAM := (ADCLAM / 256) * 1.25;


    DiagDataOLT_v1.fLAMRDY := DKState and 1 <> 0;
    DiagDataOLT_v1.fLAMHEAT := DKState and 2 <> 0;
    DiagDataOLT_v1.SPD := SPD;
    DiagDataOLT_v1.UFR_XX := T_JUFRXX * 10;
    DiagDataOLT_v1.TAIR := Tair - 40;
    DiagDataOLT_v1.DGTC_LEAN := DGTC_LEAN / 256;
    DiagDataOLT_v1.DGTC_RICH := DGTC_RICH / 256;
    DiagDataOLT_v1.INJ := INJ / 125;

    DiagDataOLT_v1.AIR := AIR / 10;
    DiagDataOLT_v1.GBC := GBC / 6;
    DiagDataOLT_v1.FRM:= FRH/50;

    DiagDataOLT_v1.Errors:=0;
    DiagDataOLT_v1.Errors :=ReadErrorCount(Err1) + ReadErrorCount(Err2) + ReadErrorCount(Err3) + ReadErrorCount(Err4);
    fsensorErrorCount:=DiagDataOLT_v1.Errors;

    if lc1.RunThread then begin
     if lc1.lc then begin
      DiagDataOLT_v1.AFR_LC:=lc1.AFR;
      if DiagDataOLT_v1.AFR > 0 then
      DiagDataOLT_v1.COEFF_LC:=DiagDataOLT_v1.AFR_LC/DiagDataOLT_v1.AFR;
     end else DiagDataOLT_v1.COEFF_LC:=1;
    end;

for i := 1 to 50 do begin
 if I < 50 then
  Fsensor_ADC_KNOCK[i]:=Fsensor_ADC_KNOCK[i+1];
 if I = 50 then  Fsensor_ADC_KNOCK[50]:=DiagDataOLT_v1.ADCKNOCK;
 AVG_KNO:=AVG_KNO+Fsensor_ADC_KNOCK[i];
end;
Fsensor_AVG_ADC_KNOCK:=AVG_KNO/50;



LogData:=StringReplace(FloatToStr(self.Time_Diag),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + self.ConvertBoolToInt(DiagDataOLT_v1.fSTOP);
LogData:=LogData + ', ' + self.ConvertBoolToInt(DiagDataOLT_v1.fXX);
LogData:=LogData + ', ' + self.ConvertBoolToInt(DiagDataOLT_v1.fPOW);
LogData:=LogData + ', ' + self.ConvertBoolToInt(DiagDataOLT_v1.fFUELOFF);
LogData:=LogData + ', ' + self.ConvertBoolToInt(DiagDataOLT_v1.fLAMREG);
LogData:=LogData + ', ' + self.ConvertBoolToInt(DiagDataOLT_v1.fDETZONE);
LogData:=LogData + ', ' + self.ConvertBoolToInt(DiagDataOLT_v1.fADS);
LogData:=LogData + ', ' + self.ConvertBoolToInt(DiagDataOLT_v1.fLEARN);
LogData:=LogData + ', ' + self.ConvertBoolToInt(DiagDataOLT_v1.fXXPrev);
LogData:=LogData + ', ' + self.ConvertBoolToInt(DiagDataOLT_v1.fXXFix);
LogData:=LogData + ', ' + self.ConvertBoolToInt(DiagDataOLT_v1.fDET);
LogData:=LogData + ', ' + self.ConvertBoolToInt(DiagDataOLT_v1.fLAM);
LogData:=LogData + ', ' + inttostr(DiagDataOLT_v1.RPM_GBC_RT);
LogData:=LogData + ', ' + inttostr(DiagDataOLT_v1.TWAT);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagDataOLT_v1.AFR),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagDataOLT_v1.RCO),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + inttostr(DiagDataOLT_v1.THR);
LogData:=LogData + ', ' + inttostr(DiagDataOLT_v1.RPM40);
LogData:=LogData + ', ' + inttostr(DiagDataOLT_v1.RPM);
LogData:=LogData + ', ' + inttostr(DiagDataOLT_v1.UFR_SSM);
LogData:=LogData + ', ' + inttostr(DiagDataOLT_v1.SSM);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagDataOLT_v1.coeff),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + inttostr(DiagDataOLT_v1.faza_INJ);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagDataOLT_v1.UOZ),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagDataOLT_v1.KUOZ1),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagDataOLT_v1.KUOZ2),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagDataOLT_v1.KUOZ3),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagDataOLT_v1.KUOZ4),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagDataOLT_v1.ADCKNOCK),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagDataOLT_v1.ADCMAF),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagDataOLT_v1.ADCUBAT),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagDataOLT_v1.ADCRCO),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagDataOLT_v1.ADCTPS),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagDataOLT_v1.ADCTWAT),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagDataOLT_v1.ADCTAIR),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagDataOLT_v1.ADCLAM),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + self.ConvertBoolToInt(DiagDataOLT_v1.fLAMRDY);
LogData:=LogData + ', ' + self.ConvertBoolToInt(DiagDataOLT_v1.fLAMHEAT);
LogData:=LogData + ', ' + inttostr(DiagDataOLT_v1.SPD);
LogData:=LogData + ', ' + inttostr(DiagDataOLT_v1.UFR_XX);
LogData:=LogData + ', ' + inttostr(DiagDataOLT_v1.TAIR);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagDataOLT_v1.DGTC_LEAN),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagDataOLT_v1.DGTC_RICH),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagDataOLT_v1.INJ),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagDataOLT_v1.AIR),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + IntToStr(round(DiagDataOLT_v1.GBC));
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagDataOLT_v1.FRM),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + inttostr(DiagDataOLT_v1.Errors);
LogData:=LogData + ', ' + inttostr(FsensorPressure);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagDataOLT_v1.AFR_LC),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(DiagDataOLT_v1.COEFF_LC),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + softname;
LogData:=LogData + ', ' + StringReplace(FloatToStr(diagdataolt_v1.AFR_LC),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(pcn_gen),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(new_pcn),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(Fsensor_AVG_ADC_KNOCK),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(FsensorGenFaza),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(self.InjDuty),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + IntToStr(lc1.EGT);
LogData:=LogData + ', ' + StringReplace(FloatToStr(self.uskor),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + inttostr(educationthread.educat_data.RPM_RT_32);
LogData:=LogData + ', ' + inttostr(educationthread.educat_data.TPS_RT_32);
LogData:=LogData + ', ' + inttostr(educationthread.educat_data.DAD_RT_32);
LogData:=LogData + ', ' + inttostr(educationthread.educat_data.RPM_RT_16);
LogData:=LogData + ', ' + inttostr(educationthread.educat_data.TPS_RT_16);
LogData:=LogData + ', ' + inttostr(educationthread.educat_data.DAD_RT_16);
LogData:=LogData + ', ' + inttostr(Flag_indicator);
Flag_indicator:=0;
//obdii.Flag_indicator = 1
end;
except
mainform.Memo1.Lines.Add('������ � ParseDataDiag_OLT_V1') ;
end;
 SaveLog_OLT_V1(LogData);
end;

 function Tobdii.ReadErrorCount(data: Byte):integer;
 begin
 result:=0;
 if data and $1 = $1 then result:=result+1;
 if data and $2 = $1 then result:=result+1;
 if data and $4 = $4 then result:=result+1;
 if data and $8 = $8 then result:=result+1;
 if data and $10 = $10 then result:=result+1;
 if data and $20 = $20 then result:=result+1;
 if data and $40 = $40 then result:=result+1;
 if data and $80 = $80 then result:=result+1;
 end;
 function TObdii.ConvertBoolToInt(data: Boolean):string;
 begin
  case data of
    true:
    begin
      exit('1');
    end;
    False:
    begin
      exit('0');
    end;
  end;
 end;

//------------------------------------------------------------------------------
// ���� ������
procedure TOBDII.Execute;
begin
  while RunThread do begin
    sleep(1);
    TTTIIME:=TTTIIME+1;
    if TTTIIME > 10000 then TTTIIME:=0;
    if Flag then begin
    if not Flag_outDiag then
     GetECUComplectation
    end;
  end;
end;
//------------------------------------------------------------------------------

end.
