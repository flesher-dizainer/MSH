unit uOBDII;

interface

uses
  Classes, Windows, Dialogs, SysUtils, Forms,uFirmware;

const
  sysDiag         = $F1;  // Адрес диагноста
  sysEngine       = $10;  // Адрес ЭБУ
  sysByteClear    = $C0;  // Байт для проверки принадлежности пакета данных к OBD-протоколу
  SoftName        = '614';//---версия программы----
//------- управление ИМ -----------------
  type
   TIOCONTROL = record
    Name:string;  //имя переменной
    ID:Byte;     //ид переменной AFR($49)
    valid_value:integer;//текущее значение
    Status:boolean; //статус переменной, управляем или нет
   end;
//-------- пакет данных от протокола j7es ---------------------
  type
   TRec_RDBLI_J7ES = packed record
    Mode1,             //Слово режима работы 1
    Mode2,             // Слово режима работы 2
    ErrCnt,            //флаги неисправности
    Err1,              //текущие неисправности 1
    Err2,               //текущие неисправности 2
    Err3,               //текущие неисправности 3
    Err4,               //текущие неисправности 4
    RPM_GBC_RT,         //режимная точка
    Twat,               //ДТОЖ
    ALF,                //Соотношение воздух/топливо
    DDSF,              // Коэффициент коррекции RCO
    THR,               //положение дросселя
    RPM40,             //обороты двс с квантованием на 40
    RPM10: byte;      //Скорость вращения двигателя на холостом ходу
    CycleTime: word;  //время цикла
    UFRXX,            //желаемое положение рхх
    SSM,              //текущее положение рхх
    COEFF,            //коэфицент коррекции времени впрыска
    FAZA,              //фаза впрыска
    UOZ,              //уоз
    KUOZ1,            // коррекция УОЗ цилиндра 1
    KUOZ2,
    KUOZ3,
    KUOZ4,
    ADCKNOCK,
    ADCMAF,
    ADCUBAT,
    ATIM,              // АЦП RCO
    ADCTPS,
    ADCTWAT,
    ADCTAIR,
    ADCLAM1,            //ацп ДК
    DKState,            //флаги состояния ДК
    SAS,                // октан-корректор (смещает УОЗ на заданную величину)
    SPD,                //скорость
    T_JUFRXX,           // Желаемые обороты ХХ
    Tair,               //температура воздуха на впуске
    ADCLAM: byte;       //АЦП ДК
    DGTC_RICH,          // обогащение по открытию дросселя
    DGTC_LEAN,          // обеднение по закрытию дросселя
    INJ,                 //Длительность импульса впрыска
    AIR,                 //массовый расход воздуха
    GBC,                 //цикловое наполнение
    FRH: word;           // часовой расход топлива
    //----здесь кончился пакет стокового олт V1
    PRESS_RT,            //режимная точка давления
    Tcharge,             // температура заряда
    TchargeCoeff,        // коэффициент коррекции цн по Тзаряда
    DUOZ,                // общая коррекция УОЗ
    LaunchFuelCutOff,    // обороты блокировки топливоподачи на лаунче
    KGTC,                // мультипликативная коррекция топливоподачи
    coefficient_vibora_tcharge,//коэффициент выбора тзаряда
    KnockFlags,
    MisFireFlags,
    KGBC_TPS,             //ПЦН дроссель
    KGBC_DAD,             // ПЦН для ДАД
    UOZ_TCORR,
    ALF_WBL,              // ALF с ШДК подключенного к ЭБУ на пин 75
    EGT,                  //ПОКА КРРЕКЦИЯ ЦН ПО ДОП ВЫВОДУ
    JUFRXX,               // уставка оборотов ХХ
    JFRXX1,               // порог оборотов 1 переходного режима
    JFRXX2,               // порог оборотов 2 переходного режима
    KINJ_AIRFREE,         // коэфф. коррекции времени впрыска по дельте давлений рампа-ресивер
    DUOZ_REGXX,           // смещение УОЗ пропорциональным регулятором оборотов ХХ
    DERR_RPM,             // изменение ошибки оборотов
    DIUOZ,                // смещение УОЗ по интегральным регулятором оборотов ХХ
    DELAY_FUEL_CUTOFF,    // задержка отключения топливоподачи
    TLE_PIN_0_7,
    TLE_PIN_8_15,
    J7ES_EGT,        //компенсация по BOOST_ERROR. С версии 075 это egt
    WGDC,                  //Wastegate Duty Cycle (WGDC)
    FAZA_J7,               //фаза
    UOZCORR_GTC,           //коррекция уоз по топливу
    TIME_HIP9011,          //Постоянная времени интегратора HIP9011
    number_shift,          //номер передачи
    TWAT_RT,
    RPM_RT,
    RPM_THR_RT,
    RAM_2A,                 //переменная ram_2a
    DELTA_RPM_XX,            // ошибка оборотов
    PXX_ZONE,                // состояние отсечки ПХХ
    RAM_2D,                 //переменная RAM_2D
    StartFlags,


    UGB_RXX,
    DUOZ_LAUNCH,             // отскок УОЗ на лаунче
    GBC_RT: byte;
    Knock,                   // счетчик детонации
    FchargeGBC,              // ЦН ДАД
    FchargeGBCFin,           // скорректированное ЦН
    Press,                   // давление
    DGTC_DadRich,            // обогащение по давлению
    TARGET_BOOST: word;      //желаемый избыток
    avg_noise_hip:word;      //средний уровень шума от hip
    rpm_rt_32:byte;
  end;
//---------- данные от пакета -----------------
  type
 TDiagData = packed record
fSTOP,      //флаг остановленного двс
fXX,        //флаг холостого хода
fPOW,      //флаг мощностное обогащение
fFUELOFF, //флаг блокировки топлива
fLAMREG,  //флаг зоны регулирования по дк
fDETZONE,//флаг попадания в зону детонации
fADS,   //флаг разрешения продувки адсорбера
fLEARN,//флаг сохранения обучения по дк

fXXPrev,//холостой ход в прошлом цикле
fXXFix, //разрежение выхода из хх
fDET, //признак обнаружения детонации
fLAM, //текущее состояние ДК

fLAMRDY,//флаг готовности ДК
fLAMHEAT : boolean;//нагрев ДК

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
fSTOP,      //флаг остановленного двс
fXX,        //флаг холостого хода
fPOW,      //флаг мощностное обогащение
fFUELOFF, //флаг блокировки топлива
fLAMREG,  //флаг зоны регулирования по дк
fDETZONE,//флаг попадания в зону детонации
fADS,   //флаг разрешения продувки адсорбера
fLEARN,//флаг сохранения обучения по дк

fXXPrev,
fXXFix,
fDET, //признак обнаружения детонации
fLAM:boolean; //текущее состояние ДК

RPM_GBC_RT,//режимная точка RPM-GBC 3D
TWAT :integer;//температура ОЖ
AFR:Double;//состав смеси
RCO:Double;
THR,//дроссель
RPM40,//обороты двс на 40
RPM,//обороты двс

UFR_SSM,//---желаемое рхх
SSM   : integer;//--текущее рхх
coeff:Double;//коэфицент коррекции времени впрыска
faza_INJ:integer;//фаза впрыска

UOZ,  //уоз
KUOZ1, //коррекция уоз 1ц
KUOZ2,  //коррекция уоз 2ц
KUOZ3,  //коррекция уоз 3ц
KUOZ4,  //коррекция уоз 4ц
//ацп датчиков
ADCKNOCK, //дд
ADCMAF,   //дмрв
ADCUBAT,  //акб
ADCRCO,   //RCO
ADCTPS,   //дпдз
ADCTWAT,  //дтож
ADCTAIR,  //дтв
ADCLAM :Double;  // DK1
fLAMRDY,//флаг готовности ДК
fLAMHEAT : boolean;//нагрев ДК
SPD,//скорость
UFR_XX:integer;//желаемые обороты хх
TAIR:integer;//температура воздуха
DGTC_LEAN,//Коэффициент коррекции GTC при обогащении
DGTC_RICH:Double;//Коэффициент коррекции GTC при обеднении
INJ:Double;//длительность импульса впрыска
AIR,//массовый расход воздуха
GBC,//цикловой расход воздуха
FRM:Double; //часовой расход воздуха
Errors :integer; //количество ошибок активных
AFR_LC : Double;//состав смеси с шдк
COEFF_LC:Double;//коэфицент коррекции с шдк
  end;

type
  TOBDII = class( TThread )
    private
      DCB:TDCB;
      hCOMPort:  THandle;     // COM-порт
      FBaudRate: integer;     //скорость порта
      FPortName: string;      // Имя порта
      FopenPort:boolean;
      FStartWorkTime: TDateTime;
      FDiagnosticSession: boolean;//флаг изменённой скорости
      FErrorList: TStringList;  // Список кодов ошибок


      //procedure LOG( s: string );  // Добавляет запись в лог-файл
      function OpenPort():boolean;
      procedure ClosePort(hcomport:Thandle);
      procedure WritePort( Data: array of byte );  // Запись в порт
      procedure ReadPort( out Data: array of byte; out Count: integer );  // Чтение из порта
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
      function stopDiagnosticSession : boolean;//завершение диагностики
      function stopCommunication : boolean; //остановка связи
      function TesterPresent:boolean; //тестер на линии
     // procedure ReadDataEcu;//запрос пакета данных обычного эбу
      procedure ReadDataEcuOLT;//запрос пакета данных ОЛТ эбу
    //  procedure ReadVolt;//запрос пакета АЦП
      procedure ReadErrorECU;//запрос ошибок эбу
      procedure ClearError;//сброс ошибок эбу

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
    IO_DATA:Array[0..11] of TIOCONTROL ;//массив управления ИМ
     oldtime:Double;
    // newtime:Double;
     oldRPM:integer;
    // NewRPM:integer;
     uskor:Double;
    LogTimeName:string;
    T_ime:Double;
    StartDiagSession :boolean;//флаг переключения скорости
    TesterPres:boolean;//флаг диагностики
    OBD_ERROR:TStringList;//ошибки
   // OLT_TAB : TableOLT;//значение таблиц для расчёта ОЛТ
    //sysSendingDelay: integer;  // Задержка между чтением/записью
    sleepTimeRead: integer;    //задержка считывания
    SleepTimeWrite:integer;    //задержка записи
    SleepTimeWrite_2:integer;  //задержка запросов пакета, для переключения на эту задержку
    //SleepCountData:integer;    //сколь ждать байтов с порта
    FCommunication: boolean;//флаг инициализации связи с эбу
    FlagWriteIsNew:boolean;//флаг, показывающий другим потокам, что занято обращение к флагу
    FlagIsNew: boolean;//флаг обновленных данных
    Flag_Volt: boolean;//флаг считанных ацп
    Flag_Error:boolean;//флаг считывания ошибок
    Flag_Clear_Error:boolean;//флаг сброса ошибок
    Flag_Read_Error:boolean;//флаг считывания кодов ошибок
    Flag_Disconnect:boolean;//флаг завершение диагностики
    ErrorRead:integer;//ошибка чтения эбу или эбу не отвечает количество неверных пактетов
    Flag_outDiag:boolean;//флаг для отключения диагностики
    //флаги
    //флаги режима работы лямды
    flag_O2_heater:integer;//нагрев лямды
    flag_O2_gotov:integer;//лямда готова
    //Описание слова режима работы 1(3-й байт)
    flag_endine_run :integer;//признак выключения двигателя
    flag_XX :integer;//признак холостого хода
    flag_pow :integer;//признак обгащения по мощности
    flag_fuelOFF:integer;//признак блокировки подачи топлива
    flag_zone_O2:integer;//признак зоны регулирования по датчику кислорода
    flag_zona_knock:integer;//признак попадания в зону детонации
    flag_produv_adsorber:integer;//признак разрешения продувки адсорбера
    flag_save_O2:integer;//признак сохранения результатов обучения по датчику кислорода
    //Описание слова режима работы 2.(4-й байт)
    flAG_xx_old:integer;//признак наличия холостого хода в прошлом цикле вычислений
    flag_block_exit_xx:integer;//разрешение блокировки выхода из режима холостого хода
    flag_zona_knock_old:integer;//признак попадания в зону детонации в прошлом цикле вычислений
    flag_produv_adsorb_old:integer;//признак наличия продувки адсорбера в прошлом цикле вычислений
    flag_knock:integer;//признак обнаружения детонации
    flag_O2_old:integer;//признак прошлого состояния датчика кислорода
    flag_o2_new:integer;//признак текущего состояния датчика кислорода
                     /////АЦП датчиков///////
   volt_knock : Double;//датчик детонации
   volt_TWAT  : Double;//датчик температуры мотора
   volt_AIR   : Double;//датчик расхода воздуха
   volt_AKB   : Double;//напряжение акб
   volt_O2    : Double;//напряжение датчика кислорода
   volt_TPS   : Double;//напряжение дроселя
       // Показания датчиков
      FLambda:                  boolean; // флаг комплектации датчиком кислорода (в олт это заведён двс)
      FAdsorber:                boolean; //	флаг комплектации адсорбером
      Fxx:                      string;
      FlagXX:integer;                      //флаг наличия холостого хода
      Fsensor_rpm_gbc_3d:             integer;//точка обороты наполнение
      FsensorCoolantTemp:             Double;//Температура двс
      FsensorAirFuelRatio:            Double; //состав смеси
      FsensorRCO:                     Double;//RCO
      FsensorThrottlePosition:        Double;//положение дросселя
      FsensorCrankshaftSpeed:         Integer;//частота вращения двигателя
      FsensorCrankshaftIdleSpeed:     Double;//обороты холостого хода
      FsensorTimeCicle:               integer;//предположительное время цикла
      FsensorIdleWantPosition:        Double;//желаемое положение рхх
      FsensorIdleDoublePosition:        Double;//текущее положение рхх
      FsensorFuelTimeCorrection:      Double;//коэфицент корекции
      FsensorFuelTimeCorrection_LC:   boolean;//флаг что коррекция по шдк
      FsensorFuelTimeCorrection_wbl: boolean;
      FsensorFazaIngection:           Double;//фаза впрыска
      FsensorSparkAngle:              Double;//уоз
      FsensorSparkAngle_correct_1:    Double;//Коррекция УОЗ цилиндра 1   /2
      FsensorSparkAngle_correct_2:    Double;//Коррекция УОЗ цилиндра 2   /2
      FsensorSparkAngle_correct_3:    Double;//Коррекция УОЗ цилиндра 3   /2
      FsensorSparkAngle_correct_4:    Double;//Коррекция УОЗ цилиндра 4   /2
      FsensotKNOCkVoltage:            Double;//ацп датчика детонации
      FsensorDmrvVoltage:             Double;//ацп дмрв
      FsensorVoltage:                 Double;//напряжение акб
      FsensorRCOVoltage:              Double;//ацп RCO
      FsensorTPSVoltage              :Double;//ацп дросселя
      FsensorTWATvoltage:             Double;//ацп дтож
      FsensorTAIRvoltage:             Double;//ацп дтв
      FsensorLambdaVoltage:           Double;//изменение ацп ДК

      FsensorCarSpeed:                Double;//скорость авто
      fsensorErrorCount:              integer;//количество ошибок
      FsensorCrankshaftIdleWantSpeed: Double;//желаемые обороты холостого хода
      FsensorTAIR:                    Double;//температура во впуске
      FsensorLamMdaVoltage_2:         Double;//АЦП ДК

      FsensorCoeffCorrGTC_HI:         Double;//Коэффициент коррекции GTC при обогащении(2 байта) / 256
      FsensorCoeffCorrGTC_LO:         Double;//Коэффициент коррекции GTC при обеднении(2 байта) / 256
      FsensorFuelTimeLength:          Double;//длительность времени впрыска
      FsensorAirWeightRate:           Double;//массовый расход воздуха
      FsensorAirCycleRate:            Double;//цикловой расход воздуха
      FsensorFuelTimeRate:            Double;//часовой расход топлива

      FsensorRPM_RT:                  integer;//точка оборотов
      FsensorDAD_RT:                  integer;//точка давления
      FsensorPressure:                integer;//давление во впускном коллекторе

      FsensorPressure_PCN:            Double;//поправка цн по давлению
      FsensorTPS_PCN:                 Double;//поправка цн по давлению
      kgbc_pin:                       double;//поправка цн по доп выводу

      Fsensor_ADC_KNOCK:              array [1..50] of Double;
      Fsensor_AVG_ADC_KNOCK:          Double;//среднее значение напряжения датчика детонации

      FsensorFlagLambdaStatus:        Double;//флаг состояния лямды
      FsensorAirTimeRate:             Double;
      FsensorFasaGRAD:                integer;//угол длительности впрыска
      FsensorGenFaza:                 integer;//сгенерированная фаза впрыска
      fsensor_rpm_rt_32:byte;
      //FsensorRamCoeffCorr:            byte;//байт коэфицента коррекции
      FsensorFuelWayRate:             Double;
      FzoneDK:                        boolean; //зона работы по дк
      FLam:                           Double; // состояние дk(бедно или богато)
      FlamOld:                        integer;//прошлое состояние лямды
      Flam_Log:                       integer;//прошлое и новое состояние лямды одинаковы
      InjDuty:                        Double; //Загрузка форсунок %
      pcn_gen,new_pcn:Double;//-- ПЦН И СГЕНЕРИРОВАННОЕ НОВОЕ ПЦН
      fsensor_wbl,
      FSENSOREGT:real; //ТУМПЕРАТУРА ОТРАБОТАВШИХ ГАЗОВ J7ES
      number_shift:integer;//номер передачи
      DIAG_DATA:string;//swid прошивки для диагностики
      Flag: boolean;
     TTTIIME:integer;
      Time_T:integer;
      Time_Diag:double;
      FcorrLC1:Double;//коэфицент коррекции от шдк
      FdadNaklon:Double;//наклон дад
      FdadSMeshenie:Double;//смещение дад
      FlagOLT: boolean;//флаг онлайного эбу
      Flag_OLT_DAD:boolean;//Флаг диагностики дад на обычном эбу

      FlagSwitchToRam:boolean;//флаг переключения памяти
      FlagSnKey:boolean;//флаг считанного серийника
      SnKey: array of byte;//считанный серийник
      KeyHash: array of byte;//сгенерированный большой кей хеш(240 байт)
      FlagOKIO:boolean;//флаг корректного упрвления IO
      DATA_IO:array of byte;
      FlagWriteFirmware:boolean;//флаг записаных таблиц открытой прошивки
      FlagWriteIO:boolean;//флаг запроса IO
      StartAddrTableOLT:integer;//адрес начала произвольной таблицы
      SatartAddrBCN:integer;//адрес таблицы бцн
      SatartAddrfaza:integer;//адрес таблицы фазы
      FlagRewraiteTableOLT:boolean;//флаг перезаписи произвольной таблицы в ОЛТ
      FlagRewraiteTableBCN:boolean;//флаг перезаписи БЦН
      FlagRewraiteTableFAZA:boolean;//флаг перезаписи faza

      outPackCount:integer;//отправленные байты
      TableFirmwareOlt: array of byte;//массив прошивки для записи в олт
      TableOLT: array of byte;//таблица для произвольной перезаписи ОЛТ
      TableBCN: array of byte;//таблица для перезаписи бцн
      TableFAZA: array of byte;//таблица перезаписи фазы впрыска
      LicenseError:boolean;//---- флаг показывающий что лицензия не подходит
      Flag_indicator:integer;
      NewLog:boolean;
      LogName:string;
      class var RunThread: boolean;
      constructor Create( Port: string; BaudRate: integer; BAudRate2:integer; SendingDelay: integer; RTS, DRT: boolean; BufferSize: integer );
      destructor  Destroy;override;
      function    Stop : boolean;//остановка диаг сессии
      function    ConnectToECU: boolean;
      procedure   GetECUComplectation;
      procedure   SaveLogJ7ES(S:String );
      procedure   SaveLog_OLT_V1(S:String);
      procedure   SaveLogConnect(S:String);
      function    ReadDiagData(ID:integer):Double;
      Procedure   SwitchToRam;//переключение памяти
      procedure   ReadKeyHash;//чтение серийника и создание большого кей хеш
      function    convertSnKey(data:array of byte):string;
      Procedure   WriTeDataOLT(Data : Array of byte; StartAddrXram:Integer);//Запись таблицы в олт(любую таблицу можно отсюда отправить)
      procedure   WriteTableClearO2;///очистка памяти обучения по дк
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
// Конструктор класса
constructor TOBDII.Create( Port: string; BaudRate: integer; BAudRate2:integer; SendingDelay: integer; RTS: Boolean; DRT: Boolean; BufferSize: Integer );
var
  DCB: TDCB;
begin
//------ заполнение управление ИМ ------
 IO_DATA[0].Name:='AFR';
 IO_DATA[0].ID:=$49;
 IO_DATA[0].Status:=False;

 IO_DATA[1].Name:='UOZ';
 IO_DATA[1].ID:=$4A;
 IO_DATA[1].Status:=False;

 IO_DATA[2].Name:='RXX';
 IO_DATA[2].ID:=$41;
 IO_DATA[2].Status:=false;

 IO_DATA[3].Name:='Форсунка 1';
 IO_DATA[3].ID:=$01;
 IO_DATA[3].Status:=false;

 IO_DATA[4].Name:='Форсунка 2';
 IO_DATA[4].ID:=$02;
 IO_DATA[4].Status:=false;

 IO_DATA[5].Name:='Форсунка 3';
 IO_DATA[5].ID:=$03;
 IO_DATA[5].Status:=false;

 IO_DATA[6].Name:='Форсунка 4';
 IO_DATA[6].ID:=$04;
 IO_DATA[6].Status:=false;

 IO_DATA[7].Name:='Зажигание 1-4';
 IO_DATA[7].ID:=$05;
 IO_DATA[7].Status:=false;

 IO_DATA[8].Name:='Зажигание 2-3';
 IO_DATA[8].ID:=$06;
 IO_DATA[8].Status:=false;

 IO_DATA[9].Name:='Топливный насос';
 IO_DATA[9].ID:=$09;
 IO_DATA[9].Status:=false;

 IO_DATA[10].Name:='Вентилятор охл ДВС';
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
 //BaudRate - скорость на которую нужно переключиться
 //BAudRate2 - скорость установки связи
  inherited Create( true );
  // Выставляем флаг работы потока
  RunThread := false;
  OBD_ERROR:=TStringList.Create;
  ErrorRead:=0;
  FPortName:=Port;
  FBaudRate := BaudRate;
  SleepTimeWrite_2:=SendingDelay;
//------------------------------------------ открытие порта ---------------------
  //Открываем порт
  hCOMPort := CreateFile( PChar( Port ), Generic_Read + Generic_Write, 0 , nil, Open_Existing, File_Attribute_Normal, 0 );
  // Проверяем отсутствие ошибок при отрытии
  if hCOMPort = Invalid_Handle_Value then begin
    Application.MessageBox(PChar( 'Ошибка открытия порта ' + Port ), 'Ошибка',
                                  MB_ICONWARNING + MB_OK );
    //TODO: Обработчик ошибки открытия порта
    Exit;
  end;
  // Выставляем настройки порта
  GetCommState( hCOMPort, DCB );
  DCB.BaudRate := BaudRate2;  //10400;
  DCB.ByteSize := 8;
  DCB.Parity   := NOPARITY;
  DCB.StopBits := ONESTOPBIT;
  // Проверка настройки порта
  if not SetCommState( hCOMPort, DCB ) then begin
   closehandle(hComPort);
   Exit;
  end;

  //очистка буфера порта
if not PurgeComm(hCOMPort,PURGE_TXCLEAR or PURGE_RXCLEAR)then begin
 closehandle(hComPort);
 exit;
end;
  // Инициализируме переменные
  FCommunication := false;
  FDiagnosticSession  := false;
  FErrorList := TStringList.Create;
  //LoadECUList;

  // Выставляем флаг работы потока
  FStartWorkTime := Now;
  RunThread := true;
  resume;
  FopenPort:=True;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Деструктор класса
destructor TOBDII.Destroy;
begin
  CloseHandle( hCOMPort );
  //FErrorList.Free;
 // inherited Destroy;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Остановка работы потока
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
mainform.Memo1.Lines.Add('Непредвиденная ошибка в OBDII.stop');
end;
end;
//------------------------------------------------------------------------------

function Tobdii.OpenPort():boolean;
var
DCB:TDCB;
begin
//------------------------------------------ открытие порта ---------------------
 FopenPort:=False;
  //Открываем порт
  hCOMPort := CreateFile( PChar( FPortName ), Generic_Read + Generic_Write, 0 , nil, Open_Existing, File_Attribute_Normal, 0 );
  // Проверяем отсутствие ошибок при отрытии
  if hCOMPort = Invalid_Handle_Value then begin
   Result:=False;
   Exit;
  end;
  // Выставляем настройки порта
  GetCommState( hCOMPort, DCB );
  DCB.BaudRate := FBaudRate;  //10400;
  DCB.ByteSize := 8;
  DCB.Parity   := NOPARITY;
  DCB.StopBits := ONESTOPBIT;
  // Проверка настройки порта
  if not SetCommState( hCOMPort, DCB ) then Exit(false);
  //очистка буфера порта
  if not PurgeComm(hCOMPort,PURGE_TXCLEAR or PURGE_RXCLEAR) then exit(false);
  FopenPort :=true ;
  exit(true);
//------------------------------- убрать до сюда -------------------
end;


procedure TOBDII.ClosePort(hcomport: Thandle);
begin
  if not FopenPort then  exit;
  closehandle(hcomport);
  FopenPort :=false ;
end;

//------------------------------------------------------------------------------
// Запись в порт
procedure TOBDII.WritePort( Data: array of Byte );
var
  Size, NumberOfBytesWritten: Cardinal;
  s: string;
  i: integer;
begin
i:=0;
//очистка и проверка порта
  if not PurgeComm(hCOMPort,PURGE_TXCLEAR or PURGE_RXCLEAR) then begin
    for i := 1 to 10 do begin
     sleep(100);
     ClosePort(hCOMPort);
    if OpenPort then break;
    end;
 end;
 if (i = 10) and ( not FopenPort ) then begin
 mainform.Memo1.Lines.Add('Не удалось очистить порт и перезапустить!');
  exit;
 end;
S:='Запрос: ';
  // Отправляем данные
  sleep( SleepTimeWrite );
  Size := Length( Data );
  outPackCount:=size;//количкество отправленых байтов
if not  WriteFile( hCOMPort, Data, length(data), NumberOfBytesWritten, nil ) then
mainform.Memo1.Lines.Add('Не удалось отправить в порт!');
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Чтение из порта
procedure TOBDII.ReadPort( out Data: array of byte; out Count: integer );
var
  Errors, Size, NumberOfBytesReaded: Cardinal;
  COMStat: TCOMStat;
  TimeOutRead,i:integer;//таймаут чтения
  Diag_DATA:array of byte; //общий огромный пакет диагностики
  Heater_data: array[0..255] of byte;//первый байт, указывающий размер заголовка.
  dlina:Cardinal;//размер сообщения
  ReadPa:boolean;//флаг считанного пакета
  Count_pack:byte;//количество пакетов, для того чтоб завершить приём
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
  Showmessage('Ошибка очистки порта на Чтении данных 1 !');
  ClosePort(hCOMPort);
  if not OpenPort then  Showmessage('Не удалось заново открыть порт!!!');
  exit;
 end;
  Size := COMStat.cbInQue;
  //читаем первый байт, для определения длины заголовка. 4 или 3 байта
  if Size > 0 then begin
     TimeOutRead:=0;
     ReadFile( hCOMPort, Heater_data, 1, NumberOfBytesReaded, nil);
     setlength(Diag_DATA,length(Diag_DATA) + 1);
     Diag_DATA[length(Diag_DATA)-1]:=Heater_data[0];
     //-----------короткий пакет---------------------------
     if Heater_data[0] xor $80 > 0 then begin
     //здесь обычный короткий заголовок, длина пакета = заголовок адрес адрес количество контролька
      dlina:=Heater_data[0] xor $80;
      inc(dlina,3);
       //SaveLogConnect('Прочтён заголовок пакета');
     end;
    //------------ длинный пакет, продолжаем считывать пакет ещё из 3 байт -------------------
    if Heater_data[0] = $80 then begin
     //4-й байт размер пакета(у нас осталось 3, значит 3-й байт)
     // SaveLogConnect('Пакет длинный, читаем ещё 3 байта');
    Errors:=0;
    repeat
    sleep(1);
    inc(TimeOutRead,1);
      if not ClearCommError( hCOMPort, Errors, @COMStat ) then begin
       Showmessage('Ошибка очистки порта на Чтении данных 2 !');
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
    //--------- приём остатка пакета ----------------
    Errors:=0;
  repeat
  sleep(1);
   inc(TimeOutRead,1);
   ReadPa:=False;
   if not ClearCommError( hCOMPort, Errors, @COMStat ) then begin
    Showmessage('Ошибка очистки порта на Чтении данных 3 !');
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
// Расчет контрольной суммы ( CRC )
function TOBDII.CalculateCRC( Package: array of Byte ): byte;
var
  b: byte;
  i,CRC: integer;
begin
  // Обнуляем значение контрольной суммы
  CRC := $00;

  // В качестве контрольной суммы используется простая 8-битная сумма всех байт
  for i := 0 to Length( Package ) - 1 do begin
    b := Package[ i ];
    CRC := CRC + b;
  end;

  // Возвращаем значение CRC
  Exit(lo( CRC) );
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Проверяем принадлежность данных к OBD-II
{
function TOBDII.IsOBDPackage( Package: array of Byte ): boolean;
var
  Fmt, ControlBits: byte;
begin
  // Считываем первый байт пакета данных, который содержит информацию о формате сообщения
  Fmt := Package[ 0 ];
  // Обнуляем последние 6 бит байта Fmt
  ControlBits := Fmt and sysByteClear;
  // Проверяем принадлежность данных к протоколу KWP
  if ControlBits = $80 then
    Exit( true )
  else
    Exit( false );
end;
}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Проверка контрольной суммы
function TOBDII.CheckCRC( Package: array of byte; Count: integer ): boolean;
var
   CRCInData, b: byte;
  i,CalcCRC: integer;
begin
  // Значение контрольной суммы хранится в последнем байте пакета. Считываем его
  CRCInData := Package[ Count - 1 ];

  // Обнуляем значение расчетной контрольной суммы
  CalcCRC := $00;

  // Считаем контрольную сумму пакета
  for i := 0 to Count - 2 do begin
    b := Package[ i ];
    CalcCRC := CalcCRC + b;
  end;

  // Проверяем совпадает ли контрольная сумма и возвращаем значение
  if lo( CalcCRC )= CRCInData then Exit( true ) else Exit( false );
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Разбираем данные
function TOBDII.WorkWithData( Package: array of Byte; Count: Integer ): boolean;
const
  sysECUIndByte = $5A;
  //--------------------- генерирование фазы -----------
  procedure genFaz;
  begin
  try
   if FsensorCrankshaftSpeed > 0 then begin

    FsensorFasaGRAD:=round( FsensorFuelTimeLength * 720 /(60000/FsensorCrankshaftSpeed*2));
 end;
 //угол закрытия впуска - угол закрытия выпуска = длина впуска без перекрытия
 if not faza_data.BoolWriteInj then  //открытый клапан
  if FsensorFasaGRAD >= (faza_data.IntClose - faza_data.EXCL - 10) then
   FsensorGenFaza:= faza_data.IntClose  - FsensorFasaGRAD
    else
     FsensorGenFaza:= faza_data.EXCL;
 if faza_data.BoolWriteInj then FsensorGenFaza:= faza_data.IntOpen  - FsensorFasaGRAD ;
 if FsensorGenFaza <= 0 then inc(FsensorGenFaza,710);
    except
    mainform.Memo1.Lines.Add('Возникла ошибка в расчёте FsensorGenFaza' ) ;
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

    // Проверяем адресата данных
    if Tgt <> sysDiag then Exit( false );



    // Проверяем тип пакета (3 или 4 байта в заголовке)
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
             SleepTimeWrite:=150;//задержка перед отправкой в порт
             sleepTimeRead:=100;//задержка перед чтением
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
///-------------здесь пакет от олт протокола---------------------------------
             //Диагностические данные олт протокола
             if ( Fmt = $80 ) and ( Data[ 0 ] = $0F ) then begin
               SleepTimeWrite:=SleepTimeWrite_2;
               try
                if length(data) > 0 then
                 if inttostr(data[1])<>'' then begin
                  //признак выключения двигателя
                  if data[1] and $1 = $1 then flag_endine_run :=0 else flag_endine_run :=1 ;
                 // признак холостого хода
                 if data[1] and $2 = $2 then  flag_XX:=1 else flag_XX:=0;
                 //признак обгащения по мощности
                 if data[1] and $4 = $4 then  flag_pow:=1 else  flag_pow:=0;
                 //признак блокировки подачи топлива
                 if data[1] and $8 = $8 then flag_fuelOFF:=1 else flag_fuelOFF:=0;
                 //признак зоны регулирования по датчику кислорода
                 if data[1] and $10 = $10 then FzoneDK :=true else FzoneDK :=false;
                 if data[1] and $10 = $10 then flag_zone_O2 :=1 else flag_zone_O2 :=0;
                  //признак попадания в зону детонации
                 if data[1] and $20 = $20 then flag_zona_knock:=1 else flag_zona_knock:=0;
                  //признак разрешения продувки адсорбера
                  if data[1] and $40 = $40 then flag_produv_adsorber:=1 else flag_produv_adsorber:=0;
                  //признак сохранения результатов обучения по датчику кислорода
                  if data[1] and $80 = $80 then flag_save_O2 :=1 else  flag_save_O2:=0;
                end;
                //слово режима работы 2
                if length(data) > 1 then
                if inttostr(data[2])<>'' then begin
                 //признак наличия холостого хода в прошлом цикле вычислений
                 if data[2] and $2 = $2 then flAG_xx_old:=1 else flAG_xx_old:=0;
                 //разрешение блокировки выхода из режима холостого хода
                 if data[2] and $4 = $4 then flag_block_exit_xx:=1 else flag_block_exit_xx:=0;
                 //признак попадания в зону детонации в прошлом цикле вычислений
                 if data[2] and $8 = $8 then flag_zona_knock_old:=1 else flag_zona_knock_old:=0;
                 //признак наличия продувки адсорбера в прошлом цикле вычислений
                 if data[2] and $10 = $10 then flag_produv_adsorb_old:=1 else flag_produv_adsorb_old:=0;
                 //признак обнаружения детонации
                 if data[2] and $20 = $20 then flag_knock:=1 else flag_knock:=0;
                 //признак прошлого состояния датчика кислорода
                 if data[2] and $40 = $40 then FlamOLD:=1 else FlamOLD:=0;
                 //признак текущего состояния датчика кислорода
                 if data[2] and $80 = $80 then Flam:=1 else Flam:=0;
                 //проверка прошлого состояния лямды
                end;
              if inttostr(data[8]) <>'' then Fsensor_rpm_gbc_3d         :=data[8];//rpm/gbc/3d
              if inttostr(data[9]) <>'' then FsensorCoolantTemp         := Data[ 9 ] - 40;//температура ож
              if inttostr(data[10])<>'' then FsensorAirFuelRatio        := 14.7 * ( Data[ 10 ] + 128 ) / 256;//состав смеси
              if inttostr(data[11])<>'' then FsensorRCO                 :=data[11]/256;//rco
              if inttostr(data[12])<>'' then FsensorThrottlePosition    := Data[ 12 ];//положение дросселя
              //if inttostr(data[13])<>'' then FsensorCrankshaftSpeed     := Data[ 13 ] * 40;//скорость вращения коленвала
              if inttostr(data[14])<>'' then FsensorCrankshaftIdleSpeed := Data[ 14 ] * 10;//скорость вращения коленвала на хх
              if inttostr(data[15])<>'' then FsensorTimeCicle :=StrToInt( '$' +StringReplace( ( IntToHex( Data[16],2 ) + IntToHex( Data[15],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) );
               if FsensorTimeCicle > 0 then FsensorCrankshaftSpeed:=5000000 div FsensorTimeCicle else FsensorCrankshaftSpeed:=0;

              if inttostr(data[17])<>'' then FsensorIdleWantPosition    := Data[ 17 ];//желаемое положение рхх
              if inttostr(data[18])<>'' then FsensorIdleDoublePosition    := Data[ 18 ];//текущее положение рхх
              if not FsensorFuelTimeCorrection_LC then
              if inttostr(data[19])<>'' then FsensorFuelTimeCorrection  := strtofloat(formatfloat('##0.##',( Data[ 19 ] + 128 ) / 256));//коэфицент коррекции времени впрыска
             // if inttostr(data[19])<>'' then OLT_TAB.COEFFCORR_OLT := round((data[19] + 128) / 256 * 128);//коэфицент коррекции для расчёта поправки цн уже преобразованное
             // if inttostr(data[19])<>'' then FsensorRamCoeffCorr :=round(( data[19]+128)/256*128);
              if inttostr(data[20])<>'' then FsensorFazaIngection       :=data[20]*3;
              if inttostr(data[21])<>'' then begin

              if data[21] and $80 = $80 then begin
                FsensorSparkAngle:= strtofloat('-'+floattostr((256 - Data[ 21 ]) / 2));//уоз
              end else

              FsensorSparkAngle          := Data[ 21 ] / 2;//уоз

              end;
              if inttostr(data[22])<>'' then FsensorSparkAngle_correct_1:=data[22]/2;
              if inttostr(data[23])<>'' then FsensorSparkAngle_correct_2:=data[23]/2;
              if inttostr(data[24])<>'' then FsensorSparkAngle_correct_3:=data[24]/2;
              if inttostr(data[25])<>'' then FsensorSparkAngle_correct_4:=data[25]/2;

              if inttostr(data[26])<>'' then FsensotKNOCkVoltage        := ( data [ 26 ] * 5 ) / 256;//ацп датчика детонации
              if inttostr(data[27])<>'' then FsensorDmrvVoltage         := (DATA[ 27 ] * 5) / 256;//ацп дмрв(канала расхода воздуха)
               //	N=0.287*E*5.0/256 [В] напряжение акб
              if inttostr(data[28])<>'' then FsensorVoltage             :=  Data[ 28 ]*0.093  ;//напряжение акб
              if inttostr(data[29])<>'' then FsensorRCOVoltage          := data[29]*5/256;
              if inttostr(data[30])<>'' then FsensorTPSVoltage          := data[30]*5/256;
              if inttostr(data[31])<>'' then FsensorTWATvoltage          := data[31]*5/256;
              if inttostr(data[32])<>'' then FsensorTAIRvoltage          := data[32]*5/256;
              if inttostr(data[33])<>'' then FsensorLambdaVoltage       := ( Data[ 33 ] / 256 ) * 1.25;//ацп датчика кислорода
              if inttostr(data[34])<>'' then FsensorFlagLambdaStatus    := Data[ 34 ];//флаг состояния датчика кислорода
              if inttostr(data[34])<>'' then begin
                if data[34] and $1 = $1 then self.flag_O2_gotov :=1 else flag_O2_gotov:=0;//готовность дк
                if data[34] and $2 = $2 then self.flag_O2_heater :=1 else flag_O2_heater:=0;//нагрев дк
              end;
              if inttostr(data[36])<>'' then FsensorCarSpeed            := Data[ 36 ];//скорость автомобиля
              if inttostr(data[37])<>'' then FsensorCrankshaftIdleWantSpeed := Data[ 37 ] * 10;//желаемые обороты хх
              if inttostr(data[38])<>'' then FsensorTAIR                :=Data[38]-40;
              if inttostr(data[39])<>'' then FsensorLamMdaVoltage_2      := ( Data[ 39 ] / 256 ) * 1.25;
              if inttostr(data[40])<>'' then FsensorCoeffCorrGTC_HI:=StrToInt( '$' +StringReplace( ( IntToHex( Data[41],2 ) + IntToHex( Data[40],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) )/256;
              if inttostr(data[42])<>'' then FsensorCoeffCorrGTC_LO:=StrToInt( '$' +StringReplace( ( IntToHex( Data[43],2 ) + IntToHex( Data[42],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) )/256;



             // if inttostr(data[47])<>'' then SELF.FsensorFuelTimeLength:=DATA[47]/125 ELSE FsensorFuelTimeLength:=1;

               // время впрыска
                 FsensorFuelTimeLength := StrToInt( '$' +StringReplace( ( IntToHex( Data[45],2 ) + IntToHex( Data[44],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) ) / 125;

               //массовый расход воздуха (кг/час)
                 FsensorAirWeightRate := StrToInt( '$' +StringReplace( ( IntToHex( Data[47],2 ) + IntToHex( Data[46],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) ) / 10;
               // Цикловой расход воздуха (мг/такт)
                 FsensorAirCycleRate := StrToInt( '$' +StringReplace( ( IntToHex( Data[49],2 ) + IntToHex( Data[48],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) ) / 6;
                 //часовой расход
                 FsensorFuelTimeRate:=StrToInt( '$' +StringReplace( ( IntToHex( Data[51],2 ) + IntToHex( Data[50],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) ) / 50;
                 //dad
                 if mainform.LoadFirmware then
                 FsensorPressure:=round( (FsensorDmrvVoltage + firmware.FdadSMeshenie)* firmware.FdadNaklon);//давление во впускном коллекторе
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
    mainform.Memo1.Lines.Add('Ошибка в определении коррекции с шдк');
    end;
    end;
  FlagIsNew := true;
  except
  mainform.Memo1.Lines.Add('Возникла ошибка в разборе пакета ОЛТ_1');
  end;
             end;//конец пакета олт протокола
/////////расширенный протокол J7ES/////////
 if ( Fmt = $80 ) and ( Data[ 0 ] = $0D ) then begin
 if length(data) < 101 then exit;

 SleepTimeWrite:=SleepTimeWrite_2;
 try
 ParseData_RDBLI_J7ES(data);
  except
 mainform.Memo1.Lines.Add('Возникла ошибка в ParseData_RDBLI_J7ES(data)');
 end;
 try
 ParseDataDiag;
 except
 mainform.Memo1.Lines.Add('Возникла ошибка в ParseDataDiag');
 end;
 try
                  if inttostr(data[1])<>'' then begin
                  //признак выключения двигателя
                  if data[1] and $1 = $1 then flag_endine_run :=0 else flag_endine_run :=1 ;
                 // признак холостого хода
                 if data[1] and $2 = $2 then  flag_XX:=1 else flag_XX:=0;
                 //признак обгащения по мощности
                 if data[1] and $4 = $4 then  flag_pow:=1 else  flag_pow:=0;
                 //признак блокировки подачи топлива
                 if data[1] and $8 = $8 then flag_fuelOFF:=1 else flag_fuelOFF:=0;
                 //признак зоны регулирования по датчику кислорода
                 if data[1] and $10 = $10 then FzoneDK :=true else FzoneDK :=false;
                 if data[1] and $10 = $10 then flag_zone_O2 :=1 else flag_zone_O2 :=0;
                  //признак попадания в зону детонации
                 if data[1] and $20 = $20 then flag_zona_knock:=1 else flag_zona_knock:=0;
                  //признак разрешения продувки адсорбера
                  if data[1] and $40 = $40 then flag_produv_adsorber:=1 else flag_produv_adsorber:=0;
                  //признак сохранения результатов обучения по датчику кислорода
                  if data[1] and $80 = $80 then flag_save_O2 :=1 else  flag_save_O2:=0;
                end;
                //слово режима работы 2
                if inttostr(data[2])<>'' then begin
                 //признак наличия холостого хода в прошлом цикле вычислений
                 if data[2] and $2 = $2 then flAG_xx_old:=1 else flAG_xx_old:=0;
                 //разрешение блокировки выхода из режима холостого хода
                 if data[2] and $4 = $4 then flag_block_exit_xx:=1 else flag_block_exit_xx:=0;
                 //признак попадания в зону детонации в прошлом цикле вычислений
                 if data[2] and $8 = $8 then flag_zona_knock_old:=1 else flag_zona_knock_old:=0;
                 //признак наличия продувки адсорбера в прошлом цикле вычислений
                 if data[2] and $10 = $10 then flag_produv_adsorb_old:=1 else flag_produv_adsorb_old:=0;
                 //признак обнаружения детонации
                 if data[2] and $20 = $20 then flag_knock:=1 else flag_knock:=0;
                 //признак прошлого состояния датчика кислорода
                 if data[2] and $40 = $40 then FlamOLD:=1 else FlamOLD:=0;
                 //признак текущего состояния датчика кислорода
                 if data[2] and $80 = $80 then Flam:=1 else Flam:=0;
                 //проверка прошлого состояния лямды

                end;
              if inttostr(data[8]) <>'' then Fsensor_rpm_gbc_3d         :=data[8];//rpm/gbc/3d
              if inttostr(data[9]) <>'' then FsensorCoolantTemp         := Data[ 9 ] - 40;//температура ож
              if inttostr(data[10])<>'' then FsensorAirFuelRatio        := 14.7 * ( Data[ 10 ] + 128 ) / 256;//состав смеси
              if inttostr(data[11])<>'' then FsensorRCO                 :=data[11]/256;//rco
              if inttostr(data[12])<>'' then FsensorThrottlePosition    := Data[ 12 ];//положение дросселя
              //if inttostr(data[13])<>'' then FsensorCrankshaftSpeed     := Data[ 13 ] * 40;//скорость вращения коленвала
              if inttostr(data[14])<>'' then FsensorCrankshaftIdleSpeed := Data[ 14 ] * 10;//скорость вращения коленвала на хх
              if inttostr(data[15])<>'' then FsensorTimeCicle :=StrToInt( '$' +StringReplace( ( IntToHex( Data[16],2 ) + IntToHex( Data[15],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) );
              if FsensorTimeCicle > 0 then  FsensorCrankshaftSpeed:= 5000000 div FsensorTimeCicle else FsensorCrankshaftSpeed:=0;

              if inttostr(data[17])<>'' then FsensorIdleWantPosition    := Data[ 17 ];//желаемое положение рхх
              if inttostr(data[18])<>'' then FsensorIdleDoublePosition    := Data[ 18 ];//текущее положение рхх
              if not FsensorFuelTimeCorrection_LC then
              if FsensorFuelTimeCorrection_wbl then  FsensorFuelTimeCorrection:=fsensor_wbl/self.FsensorAirFuelRatio
               else
              if inttostr(data[19])<>'' then FsensorFuelTimeCorrection  := strtofloat(formatfloat('##0.##',( Data[ 19 ] + 128 ) / 256));//коэфицент коррекции времени впрыска

             // if inttostr(data[19])<>'' then OLT_TAB.COEFFCORR_OLT := round((data[19] + 128) / 256 * 128);//коэфицент коррекции для расчёта поправки цн уже преобразованное
             // if inttostr(data[19])<>'' then FsensorRamCoeffCorr :=round(( data[19]+128)/256*128);
              if inttostr(data[20])<>'' then FsensorFazaIngection       :=data[20]*3;
              if inttostr(data[21])<>'' then begin

              if data[21] and $80 = $80 then begin
                FsensorSparkAngle:= strtofloat('-'+floattostr((256 - Data[ 21 ]) / 2));//уоз
              end else
              FsensorSparkAngle          := Data[ 21 ] / 2;//уоз

              end;
              if inttostr(data[22])<>'' then FsensorSparkAngle_correct_1:=data[22]/2;
              if inttostr(data[23])<>'' then FsensorSparkAngle_correct_2:=data[23]/2;
              if inttostr(data[24])<>'' then FsensorSparkAngle_correct_3:=data[24]/2;
              if inttostr(data[25])<>'' then FsensorSparkAngle_correct_4:=data[25]/2;

              if inttostr(data[26])<>'' then FsensotKNOCkVoltage        := ( data [ 26 ] * 5 ) / 256;//ацп датчика детонации
              if inttostr(data[27])<>'' then FsensorDmrvVoltage         := (DATA[ 27 ] * 5) / 256;//ацп дмрв(канала расхода воздуха)
               //	N=0.287*E*5.0/256 [В] напряжение акб
              if inttostr(data[28])<>'' then FsensorVoltage             :=  Data[ 28 ]*0.093  ;//напряжение акб
              if inttostr(data[29])<>'' then FsensorRCOVoltage          := data[29]*5/256;
              if inttostr(data[30])<>'' then FsensorTPSVoltage          := data[30]*5/256;
              if inttostr(data[31])<>'' then FsensorTWATvoltage          := data[31]*5/256;
              if inttostr(data[32])<>'' then FsensorTAIRvoltage          := data[32]*5/256;
              if inttostr(data[33])<>'' then FsensorLambdaVoltage       := ( Data[ 33 ] / 256 ) * 1.25;//ацп датчика кислорода
              if inttostr(data[34])<>'' then FsensorFlagLambdaStatus    := Data[ 34 ];//флаг состояния датчика кислорода
              if inttostr(data[34])<>'' then begin
                if data[34] and $1 = $1 then self.flag_O2_gotov :=1 else flag_O2_gotov:=0;//готовность дк
                if data[34] and $2 = $2 then self.flag_O2_heater :=1 else flag_O2_heater:=0;//нагрев дк
              end;
              if inttostr(data[36])<>'' then FsensorCarSpeed            := Data[ 36 ];//скорость автомобиля
              if inttostr(data[37])<>'' then FsensorCrankshaftIdleWantSpeed := Data[ 37 ] * 10;//желаемые обороты хх
              if inttostr(data[38])<>'' then FsensorTAIR                :=Data[38]-40;
              if inttostr(data[39])<>'' then FsensorLamMdaVoltage_2      := ( Data[ 39 ] / 256 ) * 1.25;
              if inttostr(data[40])<>'' then FsensorCoeffCorrGTC_HI:=StrToInt( '$' +StringReplace( ( IntToHex( Data[41],2 ) + IntToHex( Data[40],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) )/256;
              if inttostr(data[42])<>'' then FsensorCoeffCorrGTC_LO:=StrToInt( '$' +StringReplace( ( IntToHex( Data[43],2 ) + IntToHex( Data[42],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) )/256;



             // if inttostr(data[47])<>'' then SELF.FsensorFuelTimeLength:=DATA[47]/125 ELSE FsensorFuelTimeLength:=1;

               // время впрыска
                 FsensorFuelTimeLength := StrToInt( '$' +StringReplace( ( IntToHex( Data[45],2 ) + IntToHex( Data[44],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) ) / 125;

               //массовый расход воздуха (кг/час)
                 FsensorAirWeightRate := StrToInt( '$' +StringReplace( ( IntToHex( Data[47],2 ) + IntToHex( Data[46],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) ) / 10;
               // Цикловой расход воздуха (мг/такт)
                 FsensorAirCycleRate := StrToInt( '$' +StringReplace( ( IntToHex( Data[49],2 ) + IntToHex( Data[48],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) ) / 6;
                 //часовой расход
                 FsensorFuelTimeRate:=StrToInt( '$' +StringReplace( ( IntToHex( Data[51],2 ) + IntToHex( Data[50],2 ) ), '$', '', [rfReplaceAll, rfIgnoreCase] ) ) / 50;
                 //dad_RT [52] - точка давления по дад
               if length(data)>=53 then
                if inttostr(data[52])<>'' then FsensorDAD_RT:=data[52];
                 //rpm_rt data[76] - точка по дросселю
                //pressure data[94,95]
                FsensorFazaIngection:=data[76]*6;
                if length(data)>=94 then
                 FsensorPressure:= round( (data[95]*256+data[94])/100) ;
               // if mainform.LoadFirmware then
               //  FsensorPressure:=round( (FsensorDmrvVoltage + firmware.FdadSMeshenie)* firmware.FdadNaklon);//давление во впускном коллекторе
                   ///поправка цн по давлению data[60]
                if length(data)>=59 then begin

                 if inttostr(data[60])<>'' then   FsensorPressure_PCN:=data[60]/128;
                 //поправка цн по дросселю data[59]
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
 mainform.Memo1.Lines.Add('Возникла ошибка в разборе пакета J7ES Length(data) = '+Inttostr(length(data)));
 end;
 end;

           end;
      // 	ReadMemoryByAddress ( RMBA ) keynhash+
      $63: begin
      //генерируем серийный номер из кей
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
        // Проверяем наличие файла
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
        //data[1] это тип параметра запрашиваемого
        //data[2] это как я понял значение параметра, например состава смеси
            FlagSwitchToRam:=true;
           end;
      // 	WriteDataByLocalIdentifier ( WDBLI )
      $7B: begin

           end;
      // TesterPresent ( TP )
      $7E: begin
           TesterPres:=true;
           end;
      // Обработка отрицательных ответов
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
// Формирование пакета и отправка в порт
procedure TOBDII.SendPackage( TargetDevice: Byte; SourceDevice: Byte; DataType: Byte );
var
  Data: array of byte;
begin
  SetLength( Data, 0 );
  SendPackage( TargetDevice, SourceDevice, DataType, Data, 0 );
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Формирование пакета и отправка в порт
procedure TOBDII.SendPackage( TargetDevice: Byte; SourceDevice: Byte; DataType: Byte; Data: array of Byte; DataLength: Byte );


  //----------------------------------------------------------------------------
  // Удаление эхо
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
    showmessage('Произошла ошибка в удалении ЭХО адаптера');
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
    // Проверяем есть ли данные
 if Length( Data ) > 0 then begin
  for i := 0 to Length( Data ) - 1 do begin
   SetLength( OutPackage, Length( OutPackage ) + 1 );
   OutPackage[length(OutPackage) - 1] := Data[ i ];
  end;
 end;
 //добавляем контрольку
    CS := CalculateCRC( OutPackage );
    SetLength( OutPackage, Length( OutPackage ) + 1 );
    OutPackage[ Length( OutPackage ) - 1 ] := CS;
  // Отправляем данные в порт
  WritePort( OutPackage );
  s:='Запрос  ->  ';
   for i := 0 to length ( OutPackage ) - 1 do s:=S+' '+inttohex( OutPackage[i], 2);
  // SaveLogConnect(s);
  // Обнуляем массив данных
  SetLength( InPackage, 2048 );
  // Принимаем ответ из порта
  ReadPort( InPackage, InCount );
  // Проверяем эхо
  SetLength( Package, 2048 );
  if (InCount = 0) or (InCount = length(OutPackage)) then begin
   inc(ErrorRead,1);
   mainform.Memo1.Lines.Add('Нет ответа ЭБУ = ' + IntToStr(ErrorRead));

   if ErrorRead > 10 then begin
    Flag_outDiag:=true;
    mainform.Memo1.Lines.Add('Вешаем флаг ошибки связи!');
    ErrorRead:=0;
   exit;
   //Application.ProcessMessages;
   end;

  end;
CheckECHO( OutPackage, InPackage, InCount, Package, Count );
  s:='Ответ   <-  ';
   for i := 0 to Count do s:=S+' '+inttohex( Package[i], 2);
   SaveLogConnect(s);
  // Разбираем принятые данные
  FlagWriteIsNew:=True;
  WorkWithData( Package, Count );
  FlagWriteIsNew:=False;
end;
//------------------------------------------------------------------------------
//--чтение кей хеш
procedure TOBDII.ReadKeyHash;
var
 Data : array of Byte;
begin
//запрос на чтение памяти - 85 10 F1 23 00 00 C0 10 79.
 SetLength( Data, 4 );
  Data[ 0 ] := $00;
  data[ 1 ] := $00;
  data[ 2 ] := $C0;
  data[ 3 ] := $10;
SendPackage( sysEngine, sysDiag, $23, Data, 0 );
end;
//--------конвертирование серийника для отображения
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
//перезапись таблицы в ОЛТ
Procedure TobdII.WriTeDataOLT(Data: array of Byte; StartAddrXram: Integer);
var
i,s,r,f:integer;
DataPack:array of byte;
SizePack:integer;
begin
F:=0;
SizePack:=0;
//s - количество циклов для отправки
//r - сами цыклы
//определяем количество циклов для отправки в порт
 s:=length(data) div 96;
 if (length(data) mod 96) > 0 then s:= s + 1;

 //сами циклы
for r := 1 to s do begin
mainform.Reload_status(r,s);
//определение размера пакета
 if (length(data) mod 96) > 0 then begin
   if R < S then SizePack:=96;
   if S = R then SizePack:=length(data)-((s-1)*96);
  end else begin
   SizePack:=length(data) div s;
  end;
//здесь общая процедура заполнения пакета
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
end;//конец циклов
mainform.Reload_status(0,0);
end;
//----------------------------------------------------
//обнуление обучения
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

//переключение памяти swith to ram
procedure TOBDII.SwitchToRam;
var
 Data : array of Byte;
begin
//запрос на чтение памяти - 85 10 F1 23 00 00 C0 10 79.
//0x84, 0x10, 0xF1, 0x30, 0x0F, 0x06, 0x01, 0xCB
 SetLength( Data, 3 );
  Data[ 0 ] := $0F;
  data[ 1 ] := $06;
  data[ 2 ] := $01;
 SendPackage( sysEngine, sysDiag, $30, Data, 0 );
end;

//------------------------------------------------------------------------------
// Установка соедниения с контроллером
function TOBDII.ConnectToECU: boolean;
begin
  StartCommunication;//инициализация эбу
  if not (FCommunication) then begin
   stop;
   result:=False;
   exit;
  end;

  if not StartDiagnosticSession then begin
   stop;
   exit(false);//изменение скорости связи
  end;
  if not TesterPresent then begin
   stop;
   exit(false);
   end;

  if (FlagOLT) and (FCommunication) then
  begin
   SwitchToRam;//переключение памяти
  if not FlagSwitchToRam then  SwitchToRam;
  if not FlagSwitchToRam then  SwitchToRam;
  if not FlagSwitchToRam then  SwitchToRam;
  if (FlagSwitchToRam) and (FlagOLT) then ReadKeyHash;//читаем кей хеш
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
//--- переключение памяти
   if not FlagSwitchToRam  then SwitchToRam;
  //чтение серийника
   if (not FlagSnKey) and (FlagSwitchToRam) then
    begin
     readKeyHash;
    mainform.RzStatusPane1.Caption:='Sn: '+convertSnKey(snkey);
    end;

//запись прошивки в эбу
   if (FlagWriteFirmware = true) and (FlagSnKey) then begin
     WriTeDataOLT(TableFirmwareOlt,$5F00);
     FlagWriteFirmware:=false;
   end;
//--- перезапись памяти
   if FlagRewraiteTableOLT then begin
    if LicenseError then begin
     FlagRewraiteTableOLT:=false;
     Showmessage('Нет лицензии, перезаписи не будет!');
     exit;
    end;
     WriTeDataOLT(TableOLT,StartAddrTableOLT);//перезапись произвольной таблицы ОЛТ
     FlagRewraiteTableOLT:=False;
   end;
   //ПЕРЕЗАПИСЬ БЦН
if FlagRewraiteTableBCN then  begin
  if SatartAddrBCN > 0 then WriTeDataOLT(TableBCN,SatartAddrBCN);
  FlagRewraiteTableBCN:=fALSE;
end;
 //ПЕРЕЗАПИСЬ ФАЗЫ
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
//запрос диагностических данных
   if (FlagSnKey) and (FlagSwitchToRam) then ReadDataEcuOLT;
//удаление ошибок
   if Flag_Clear_Error then ClearError;
//считывание кодов ошибок
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

///------запрос олт пакета
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

//----чтение кодов ошибок
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
//сохранение лога J7ES
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
F:='Time, Флаг остановки ДВС, Флаг холостого хода, Флаг мощностного обогащения, Флаг отключения топливоподачи, флаг зоны регулирования по ДК, флаг попадания в зону детонации, Продувка адсорбера, Сохранение ДК обучения, '
+'fXXPrev, fXXFix, Флаг обнаружения детонации, Состояние ДК, Флаг готовности ДК, Нагрев ДК, АЦП ДД, АЦП ДМРВ, АЦП ДТОЖ, '
+'АЦП ДТВ, АЦП АКБ, АЦП ДК1, АЦП ДК, АЦП ДПДЗ, RPM_RT, RPM_RT_16, THR_RT_16, RPM_THR_RT, '
+'GBC_RT, GBC_RT_16, RPM_GBC_RT, PRESS_RT, TWAT_RT, Обнаружение детонации, Пропуски воспламенения, '
+'StartFlags, PXX_ZONE, DELAY_FUEL_CUTOFF, TLE_PIN_0_7, TLE_PIN_8_15,  THR, RPM40, '
+'RPM, LaunchFuelCutOff, JUFRXX, JFRXX1, JFRXX2, DERR_RPM, DELTA_RPM_XX, TWAT, TAIR, '
+'SSM, UFRXX, UOZ, KUOZ1, KUOZ2, KUOZ3, KUOZ4, DUOZ, UOZ_TCORR, DUOZ_REGXX, DIUOZ, '
+'DUOZ_LAUNCH,  Массовый расход воздуха, Цикловое наполнение, UGB_RXX, Давление, Коэф-т коррекции ЦН по ТЗ, Tcharge, FchargeGBC, FchargeGBCFin, '
+'ПЦН_TPS, '
+'ПЦН_ДАД, ALF, AFR,  AFR_WBL, KGBC_PIN, KGTC, COEFF, DGTC_LEAN, DGTC_RICH, DGTC_DadRich, '
+'KINJ_AIRFREE, INJ, INJ_DUTY, EGT, WGDC, TARGET_BOOST, Faza, Скорость авто, '
+'Knock, ErrCnt, Errors, LC_COEFF, Версия Мини Шайтана, LC_AFR, PCN_GEN, NEW_PCN_GEN, ADCKNOCK_AVG, FAZA_INJ_GEN, '
+'lc_EGT, Ускорение КВ, RPM_RT_32, TRT_RT_32, DAD_RT_32, К-т выбора Тзаряда, Средний уровень шума ДВС, Метка пользователя, Номер передачи';
    WriteLn(Logfile,f);
    CloseFile(LogFile);
   end;// else fileName:=fileName+'.'+'1.csv';

   AssignFile(LogFile,fileName);
   Append(LogFile);
   WriteLn(LogFile, S);
   CloseFile(LogFile);

end;
//-----------сохранение лога OLT v1-------------------------------------------------------------
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
  NewLog:=true;//повесили что не нужно новый файл создавать
  LogName:=fileName;//присваиваем имя файлу, новому
end;
  FileName:=LogName;
  if not FileExists('Logs\'+fileName) then begin
  // AssignFile(LogFile,fileName);
   AssignFile(LogFile,'Logs\' +  fileName);
  Rewrite(LogFile);
F:='TIME, Флаг остановки ДВС, холостой ход, мощностное обогащение,'
+' блокировка топлива, зона регулирования ДК, Зона детонации, Продувка адсорбера, Сохранение обучения по ДК, fXXPrev,'
+' fXXFix, Обнаружение детонации, текущее состояние ДК, режимная точка RPM_GBC_RT, TWAT, AFR, RCO, Положение дросселя, RPM40, '
+'RPM, Желаемое положение РХХ, Текущее положение РХХ, coeff, faza_INJ, UOZ, KUOZ1, KUOZ2, KUOZ3, KUOZ4, '
+'ADCKNOCK, ADCMAF, ADCUBAT, ADCRCO, ADCTPS, ADCTWAT, ADCTAIR, ADCLAM, fLAMRDY, '
+'fLAMHEAT, Скорость, желаемые обороты холостого хода, TAIR, DGTC_LEAN,'
+' DGTC_RICH, Время впрыска, Массовый расход воздуха, Цикловой расход воздуха, '
+'FRM, Errors, Давление, AFR_LC, COEFF_LC, Версия Мини Шайтана, LC_AFR, ПЦН, ПЦН_NEW,'
+' ADCKNOCK_AVG, '
+'FAZA_INJ_GEN, Загрузка форсунок, EGT, Ускорение КВ(ОБ/СЕК), RPM_RT_32, TRT_RT_32, DAD_RT_32, '
+'RPM_RT_16, TRT_RT_16, DAD_RT_16, Метка пользователя';
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
  mainform.Memo1.Lines.Add('Ошибка в сохранении лога ОЛТ_1');
end;
end;
//сохранение лога связи

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
 //-------- АЦП ДД -----------
 11:begin
 result:=self.FsensotKNOCkVoltage ;
 end;
 //------- ацп дмрв/дад
 12:begin
  result:=self.FsensorDmrvVoltage  ;
 end;
 //---------- ацп дросселя
 13:begin
   result:=self.FsensorTPSVoltage;
 end;
 //---------- ацп дк
 14:begin
  result:=self.FsensorLamMdaVoltage_2;
 end;
 //----------- скорость авто
 15:begin
  result:=self.FsensorCarSpeed;
 end;
 //---------- время впрыска
 16:begin
  result:=self.FsensorFuelTimeLength;
 end;
 //------ массовый расход воздуха
 17:begin
   result:=self.FsensorAirWeightRate;
 end;
 18:begin
   //------Т_заряда---------
   result:=Round(DiagData.Tcharge);
 end;
 19:begin
 //акб
   result:=StrToFloat(FormatFloat('#0.#',FsensorVoltage));
 end;
 20:begin
   //--- загрузка форсунок ---------
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
   //номер передачи
   result:=obdii.number_shift;
 end;
 end;
end;
// StartCommunication. Установка соединения с ЭБУ(инициализация связи)
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
// Начало диагностической сессии (изменение скорости связи)
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
  // Проверка настройки порта
  if not SetCommState( hCOMPort, DCB ) then begin
    //TODO: Обработчик ошибки выставления параметров порта
    Exit(False);
  end else exit(true);
 end;

end;
//------------------------------------------------------------------------------
function TobdII.stopDiagnosticSession : boolean;//завершение диагностики
begin
SendPackage( sysEngine, sysDiag, $20 );
if FDiagnosticSession then begin
 exit(false);
 end else exit(true);
end;

function tobdii.stopCommunication : boolean;//завершение связи
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
//разбор пакета
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
 //конец олт v1
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
  mainform.Memo1.Lines.Add('Ошибка присваивания данных ParseData_OLT_v1(data)');
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
    DiagData.KUOZ1 := shortint(KUOZ1) * 5 / 256;//временно ацп ДД 1,2,3,4 цилиндров
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
//режимная точка на 32
LogData:=LogData + ', ' + inttostr(educationthread.educat_data.RPM_RT_32);
LogData:=LogData + ', ' + inttostr(educationthread.educat_data.TPS_RT_32);
LogData:=LogData + ', ' + inttostr(educationthread.educat_data.DAD_RT_32);
LogData:=LogData + ', ' + StringReplace(FloatToStr(diagdata.coefficient_vibora_tcharge),',','.',[rfReplaceAll, rfIgnoreCase]);
LogData:=LogData + ', ' + StringReplace(FloatToStr(diagdata.NS),',','.',[rfReplaceAll, rfIgnoreCase]);
//метка пользователя
LogData:=LogData + ', ' + inttostr(Flag_indicator);
//номер передачи
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
  mainform.Memo1.Lines.Add('Ошибка в расчёте ускорения оборотов ОЛТ_1');
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
mainform.Memo1.Lines.Add('Ошибка в ParseDataDiag_OLT_V1') ;
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
// Тело потока
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
