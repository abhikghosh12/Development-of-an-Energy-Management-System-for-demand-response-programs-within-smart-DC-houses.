// CP: 65001
// SimulationX Version: 3.7.2.40674 x64
model hPController_demandResponse_dc "HPController_demandResponse_dc.mo"
	GreenBuilding.Interfaces.Ambience.AmbientCondition AmbientConditions if FlowControl or SourceAir "Ambient Conditions Connection" annotation(Placement(
		transformation(extent={{600,-685},{620,-665}}),
		iconTransformation(extent={{90,190},{110,210}})));
	input Modelica.Blocks.Interfaces.RealInput TRef(
		quantity="Thermics.Temp",
		displayUnit="°C") "Reference temperature" annotation(
		Placement(
			transformation(extent={{585,-390},{625,-350}}),
			iconTransformation(extent={{-220,130},{-180,170}})),
		Dialog(
			group="Temperature",
			tab="Results 1",
			__iti_showAs=ShowAs.Result));
	input Modelica.Blocks.Interfaces.RealInput TAct(
		quantity="Thermics.Temp",
		displayUnit="°C") "Actual temperature" annotation(
		Placement(
			transformation(extent={{585,-440},{625,-400}}),
			iconTransformation(extent={{-220,80},{-180,120}})),
		Dialog(
			group="Temperature",
			tab="Results 1",
			__iti_showAs=ShowAs.Result));
	input Modelica.Blocks.Interfaces.RealInput TFlow(
		quantity="Thermics.Temp",
		displayUnit="°C") "Flow temperature" annotation(
		Placement(
			transformation(extent={{585,-495},{625,-455}}),
			iconTransformation(extent={{-220,-120},{-180,-80}})),
		Dialog(
			group="Temperature",
			tab="Results 1",
			__iti_showAs=ShowAs.Result));
	input Modelica.Blocks.Interfaces.RealInput TReturn(
		quantity="Thermics.Temp",
		displayUnit="°C") "Return temperature" annotation(
		Placement(
			transformation(extent={{585,-550},{625,-510}}),
			iconTransformation(extent={{-220,-170},{-180,-130}})),
		Dialog(
			group="Temperature",
			tab="Results 1",
			__iti_showAs=ShowAs.Result));
	input Modelica.Blocks.Interfaces.RealInput TFlowRef(
		quantity="Thermics.Temp",
		displayUnit="°C") if not FlowControl "Reference flow temperature" annotation(
		Placement(
			transformation(extent={{585,-600},{625,-560}}),
			iconTransformation(
				origin={-100,200},
				extent={{-20,-20},{20,20}},
				rotation=-90)),
		Dialog(
			group="Temperature",
			tab="Results 1",
			__iti_showAs=ShowAs.Result));
	output Modelica.Blocks.Interfaces.RealOutput qvRef(
		quantity="Thermics.VolumeFlow",
		displayUnit="m³/h") "target volume flow" annotation(
		Placement(
			transformation(extent={{825,-380},{845,-360}}),
			iconTransformation(
				origin={-50,-200},
				extent={{-10,-10},{10,10}},
				rotation=-90)),
		Dialog(
			group="Volume Flow",
			tab="Results 1",
			__iti_showAs=ShowAs.Result));
	output Modelica.Blocks.Interfaces.RealOutput qvSourceRef(
		quantity="Thermics.VolumeFlow",
		displayUnit="m³/h") "Reference volume flow of source pump" annotation(
		Placement(
			transformation(extent={{825,-355},{845,-335}}),
			iconTransformation(
				origin={0,-200},
				extent={{-10,-10},{10,10}},
				rotation=-90)),
		Dialog(
			group="Volume Flow",
			tab="Results 1",
			__iti_showAs=ShowAs.Result));
	input Modelica.Blocks.Interfaces.BooleanInput Enable "External control input" annotation(
		Placement(
			transformation(extent={{585,-345},{625,-305}}),
			iconTransformation(
				origin={0,200},
				extent={{-20,-20},{20,20}},
				rotation=-90)),
		Dialog(
			group="I/O",
			tab="Results 1",
			__iti_showAs=ShowAs.Result));
	output Modelica.Blocks.Interfaces.BooleanOutput HPon "Switch-on/off of HP" annotation(
		Placement(
			transformation(extent={{825,-430},{845,-410}}),
			iconTransformation(extent={{190,140},{210,160}})),
		Dialog(
			group="I/O",
			tab="Results 1",
			__iti_showAs=ShowAs.Result));
	output Modelica.Blocks.Interfaces.BooleanOutput CPon "Switch-on/off of circulation pump" annotation(
		Placement(
			transformation(extent={{825,-465},{845,-445}}),
			iconTransformation(extent={{190,40},{210,60}})),
		Dialog(
			group="I/O",
			tab="Results 1",
			__iti_showAs=ShowAs.Result));
	output Modelica.Blocks.Interfaces.BooleanOutput AUXon if AuxHeat "Auxiliary heat switch on/off" annotation(
		Placement(
			transformation(extent={{825,-500},{845,-480}}),
			iconTransformation(extent={{190,-10},{210,10}})),
		Dialog(
			group="I/O",
			tab="Results 1",
			__iti_showAs=ShowAs.Result));
	output Modelica.Blocks.Interfaces.BooleanOutput SPon "Source pump switch on/off" annotation(
		Placement(
			transformation(extent={{825,-535},{845,-515}}),
			iconTransformation(extent={{190,90},{210,110}})),
		Dialog(
			group="I/O",
			tab="Results 1",
			__iti_showAs=ShowAs.Result));
	output Modelica.Blocks.Interfaces.BooleanOutput DEICINGon if SourceAir "Switch on/off de-icing" annotation(
		Placement(
			transformation(extent={{825,-565},{845,-545}}),
			iconTransformation(
				origin={200,-50},
				extent={{-10,-10},{10,10}})),
		Dialog(
			group="I/O",
			tab="Results 1",
			__iti_showAs=ShowAs.Result));
	input Modelica.Blocks.Interfaces.RealInput COP if COPcontrol "Actual COP of heat pump" annotation(
		Placement(
			transformation(extent={{585,-295},{625,-255}}),
			iconTransformation(extent={{-220,-20},{-180,20}})),
		Dialog(
			group="Coefficient of Performance",
			tab="Results 1",
			__iti_showAs=ShowAs.Result));
	protected
		AverageTemperature TAverage(
			SupportPoints=SupportPointsAmbientTemperature,
			StepTime=TimeStepAmbientTemperature) if FlowControl "Temperature averaging model" annotation(Placement(transformation(extent={{-150,100},{-130,110}})));
		DeIcing DEICING(
			tDeIcing=tDeIcing,
			tOperateIce=tOperation,
			tOn=tDeIcingOn,
			tOff=tDeIcingOff) if SourceAir "De-icing controller" annotation(Placement(transformation(extent={{-150,100},{-130,110}})));
		CirculationPump CPcontrol(
			tCPComp=tDelayCPComp,
			tCPIce=tDelayCPIce,
			TBoundIce=if SourceAir then TDeIcingBound else 280.15) "Circulation pump controller" annotation(Placement(transformation(extent={{-150,100},{-130,110}})));
		SourcePump SPcontrol(
			tSP=tDelaySPComp,
			TBoundIce=if SourceAir then TDeIcingBound else 280.15) "Source pump controller" annotation(Placement(transformation(extent={{-150,100},{-130,110}})));
		Compressor CompControl(
			tMinOff=tHPminOff,
			tMinOn=tHPminOn,
			tCompCP=tDelayHP,
			tCompSP=tDelaySP,
			TBoundIce=if SourceAir then TDeIcingBound else 280.15) "Compressor controller" annotation(Placement(transformation(extent={{-150,100},{-130,110}})));
		Real TFlowControl(
			quantity="Thermics.Temp",
			displayUnit="°C") "Control temperature for flow" annotation(Dialog(
			group="Temperature",
			tab="Results 1",
			__iti_showAs=ShowAs.Result));
		Boolean HP "HP state on/off" annotation(Dialog(
			group="I/O",
			tab="Results 1",
			__iti_showAs=ShowAs.Result));
		Boolean AUX "AUX state on/off" annotation(Dialog(
			group="I/O",
			tab="Results 1",
			__iti_showAs=ShowAs.Result));
		Boolean CP "CP state on/off" annotation(Dialog(
			group="I/O",
			tab="Results 1",
			__iti_showAs=ShowAs.Result));
		Boolean SP "SP state on/off" annotation(Dialog(
			group="I/O",
			tab="Results 1",
			__iti_showAs=ShowAs.Result));
	public
		Modelica.Blocks.Tables.CombiTable1D FlowTemperature(
			tableOnFile=FlowControl,
			table=[0,0],
			tableName=FlowTable,
			fileName=FlowFile) if FlowControl annotation(
			Placement(transformation(extent={{-10,-10},{10,10}})),
			Dialog(
				group="I/O",
				tab="Results 1"));
	protected
		Real tHPStart(
			quantity="Basics.Time",
			displayUnit="s") "Starting time of HP" annotation(Dialog(
			group="Timing",
			tab="Results 1",
			__iti_showAs=ShowAs.Result));
		Real tBiv=if AuxHeat then tBivalence else 0 "Auxiliary variable 1";
		Real deltaTAuxUp=if AuxHeat then deltaTAuxRefUp else 0 "Auxiliary variable 2";
		Real deltaTAuxLow=if AuxHeat then deltaTAuxRefLow else 0 "Auxiliary variable 3";
	public
		parameter Boolean SourceAir=true "If true, heat pump uses ambient air for heat source" annotation(Dialog(
			group="Heat Pump Type",
			tab="Controller Configuration"));
		parameter Boolean COPcontrol=false "If true, switches on if COP is greater than a certain threashold level" annotation(Dialog(
			group="Control Strategy",
			tab="Controller Configuration"));
		parameter Real COPmin=2.5 if COPcontrol "Minimum COP when heat pump can be used if it is COP-controlled" annotation(Dialog(
			group="Control Strategy",
			tab="Controller Configuration"));
		parameter Boolean FlowControl=false "If true, flow temperature controlled by ambient temperature, else manually controlled" annotation(Dialog(
			group="Flow Temperature Control",
			tab="Controller Configuration"));
		parameter Boolean AuxHeat=false "If true, auxiliary heat power supply, else none" annotation(Dialog(
			group="Auxiliary Heat Control",
			tab="Controller Configuration"));
		parameter Real tDelayHP(
			quantity="Basics.Time",
			displayUnit="s")=15 "Delay time between circultion pump and compressor starting" annotation(Dialog(
			group="Heat Pump",
			tab="Timing Control"));
		parameter Real tHPminOn(
			quantity="Basics.Time",
			displayUnit="s")=24 "Minimum turn-on time of HP" annotation(Dialog(
			group="Heat Pump",
			tab="Timing Control"));
		parameter Real tHPminOff(
			quantity="Basics.Time",
			displayUnit="s")=30 "Minimum turn-off time of HP" annotation(Dialog(
			group="Heat Pump",
			tab="Timing Control"));
		parameter Real tDelayCP(
			quantity="Basics.Time",
			displayUnit="s")=600 "Delay time between HP and circulation pump shutdown" annotation(Dialog(
			group="Circulation Pump",
			tab="Timing Control"));
		parameter Real tDelayCPComp(
			quantity="Basics.Time",
			displayUnit="s")=600 "Delay time between shutdown of compressor and circulation pump" annotation(Dialog(
			group="Circulation Pump",
			tab="Timing Control"));
		parameter Real tDelayCPIce(
			quantity="Basics.Time",
			displayUnit="s")=100 "Delay time between shutdown of compressor and circulation pump during de-icing process" annotation(Dialog(
			group="Circulation Pump",
			tab="Timing Control"));
		parameter Real tBivalence(
			quantity="Basics.Time",
			displayUnit="s")=3600 if AuxHeat "Delay time while not reaching reference temperature until auxiliary heating system starts" annotation(Dialog(
			group="Auxiliary Heating",
			tab="Timing Control"));
		parameter Real tDelaySP(
			quantity="Basics.Time",
			displayUnit="s")=60 "Delay time between source pump and HP starting" annotation(Dialog(
			group="Source Pump",
			tab="Timing Control"));
		parameter Real tDelaySPComp(
			quantity="Basics.Time",
			displayUnit="s")=60 "Delay time between shutdown of compressor and source pump" annotation(Dialog(
			group="Source Pump",
			tab="Timing Control"));
		parameter Real TFlowMax(
			quantity="Thermics.Temp",
			displayUnit="°C")=333.14999999999998 "Maximum flow temperature" annotation(Dialog(
			group="Boundaries Flow and Return",
			tab="I/O - Control"));
		parameter Real TReturnMax(
			quantity="Thermics.Temp",
			displayUnit="°C")=328.14999999999998 "Maximum return temperature" annotation(Dialog(
			group="Boundaries Flow and Return",
			tab="I/O - Control"));
		parameter Real deltaTActRefLow(
			quantity="Thermics.TempDiff",
			displayUnit="K")=-5 "Lowmost temperature difference between actual and reference temperature (<0: TLow<TRef, >0: TLow>TRef)" annotation(Dialog(
			group="Reference Temperature",
			tab="I/O - Control"));
		parameter Real deltaTActRefUp(
			quantity="Thermics.TempDiff",
			displayUnit="K")=5 "Upmost temperature difference between actual and reference temperature (<0: TUp<TRef, >0: TUp>TRef)" annotation(Dialog(
			group="Reference Temperature",
			tab="I/O - Control"));
		parameter Real deltaTAuxRefUp(
			quantity="Thermics.TempDiff",
			displayUnit="K")=3 if AuxHeat "Temperature difference between actual temperature and reference temperature for auxiliary heating switch-off" annotation(Dialog(
			group="Auxiliary Heating",
			tab="I/O - Control"));
		parameter Real deltaTAuxRefLow(
			quantity="Thermics.TempDiff",
			displayUnit="K")=-3 if AuxHeat "Temperature difference between actual temperature and reference temperature for auxiliary heating switch-on" annotation(Dialog(
			group="Auxiliary Heating",
			tab="I/O - Control"));
		parameter String FlowFile=GreenBuilding.Utilities.Functions.getModelDataDirectory()+"\\heat_pump\\control\\flow_control.txt" if FlowControl "File name for flow temperature control by ambient temperature" annotation(Dialog(
			group="Flow Temperature",
			tab="flow control"));
		parameter String FlowTable="T_flow_c" if FlowControl "Table name for flow temperature control by ambient temperature" annotation(Dialog(
			group="Flow Temperature",
			tab="flow control"));
		parameter Real TAmbientMax(
			quantity="Thermics.Temp",
			displayUnit="°C")=289.14999999999998 if FlowControl "Maximum temperature for flow control" annotation(Dialog(
			group="Ambient Temperature",
			tab="flow control"));
		parameter Real TAmbientMin(
			quantity="Thermics.Temp",
			displayUnit="°C")=257.14999999999998 if FlowControl "Minimum temperature for flow control" annotation(Dialog(
			group="Ambient Temperature",
			tab="flow control"));
		parameter Real SupportPointsAmbientTemperature=168 if FlowControl "Used support points for temperature averaging" annotation(Dialog(
			group="Ambient Temperature",
			tab="flow control"));
		parameter Real TimeStepAmbientTemperature(
			quantity="Basics.Time",
			displayUnit="s")=3600 if FlowControl "Used time step for temperature averaging" annotation(Dialog(
			group="Ambient Temperature",
			tab="flow control"));
		parameter Real qvSource(
			quantity="Thermics.VolumeFlow",
			displayUnit="m³/h")=0.90000000000000002 "Constant velocity of source pump" annotation(Dialog(
			group="Source Pump",
			tab="flow control"));
		parameter Real deltaTFlowRefMax(
			quantity="Thermics.TempDiff",
			displayUnit="K")=3 "Temperature difference (TFlow-TFlowRef) when qvRef=qvMax" annotation(Dialog(
			group="Boundary Temperatures for Volume Flow Control",
			tab="Volume Flow Control"));
		parameter Real deltaTFlowRefMin(
			quantity="Thermics.TempDiff",
			displayUnit="K")=-10 "Temperature difference (TFlow-TFlowRef) when qvRef=qvMin" annotation(Dialog(
			group="Boundary Temperatures for Volume Flow Control",
			tab="Volume Flow Control"));
		parameter Real qvMax(
			quantity="Thermics.VolumeFlow",
			displayUnit="m³/h")=0.00083333333333333328 "Maximum volume flow of circulation pump" annotation(Dialog(
			group="Volume Flow Boundaries",
			tab="Volume Flow Control"));
		parameter Real qvMin(
			quantity="Thermics.VolumeFlow",
			displayUnit="m³/h")=0.00019444444444444443 "Minimum volume flow of circulation pump" annotation(Dialog(
			group="Volume Flow Boundaries",
			tab="Volume Flow Control"));
		parameter Real TDeIcingBound(
			quantity="Thermics.Temp",
			displayUnit="°C")=280.14999999999998 if SourceAir "Boundary temperature for change between active and passive de-icing" annotation(Dialog(
			group="Boundary Temperature",
			tab="De-Icing"));
		parameter Real tDeIcing(
			quantity="Basics.Time",
			displayUnit="s")=270 if SourceAir "Duration of de-icing process" annotation(Dialog(
			group="Timing Control",
			tab="De-Icing"));
		parameter Real tOperation(
			quantity="Basics.Time",
			displayUnit="s")=5400 if SourceAir "Statistically operation time between two de-icing processes" annotation(Dialog(
			group="Timing Control",
			tab="De-Icing"));
		parameter Real tDeIcingOn(
			quantity="Basics.Time",
			displayUnit="s")=60 if SourceAir "Switch-on time of de-icing process" annotation(Dialog(
			group="Timing Control",
			tab="De-Icing"));
		parameter Real tDeIcingOff(
			quantity="Basics.Time",
			displayUnit="s")=60 if SourceAir "Shutdown time of de-icing process" annotation(Dialog(
			group="Timing Control",
			tab="De-Icing"));
	protected
		model AverageTemperature "Calculation of average ambient temperature"
			GreenBuilding.Interfaces.Ambience.AmbientCondition AmbientConditions "External Ambient Conditions Connector";
			function arrayChange
				input Real array[:];
				input Real newValue;
				input Integer sizeArray;
				output Real arrayNew[sizeArray];
				protected
					Real saveArray[sizeArray];
				algorithm
					for i in 1:(sizeArray-1) loop
						saveArray[i]:=array[i+1];
					end for;
					saveArray[sizeArray]:=newValue;
					arrayNew:=saveArray;
			end arrayChange;
			function arrayAverage
				input Real array[:];
				input Integer sizeArray;
				output Real average;
				protected
					Real save;
				algorithm
					save:=0;
					for i in 1:sizeArray loop
						save:=save+array[i];
					end for;
					average:=save/sizeArray;
			end arrayAverage;
			protected
				discrete Real ArrayTemperature[SupportPoints];
				discrete Real TimeStep;
			public
				Real TAverage "Average temperature for time period";
				parameter Integer SupportPoints=168 "Number of support points for averaging" annotation(Dialog(
					group="parameter",
					tab="temperature averaging"));
				parameter Integer StepTime(
					quantity="Basics.Time",
					displayUnit="s")=3600 "Time step between each data point" annotation(Dialog(
					group="parameter",
					tab="temperature averaging"));
			initial equation
				TimeStep=time.start;
				for i in 1:SupportPoints loop
					ArrayTemperature[i]=AmbientConditions.TAmbientAverageAct;
				end for;
				TAverage=arrayAverage(ArrayTemperature,SupportPoints);
			equation
				when (time-TimeStep > StepTime) then
					TimeStep=time;
					ArrayTemperature=arrayChange(ArrayTemperature,AmbientConditions.TAmbient,SupportPoints);
					TAverage=arrayAverage(ArrayTemperature,SupportPoints);
				end when;
			annotation(Icon(coordinateSystem(extent={{-100,50},{100,-50}})));
		end AverageTemperature;
		model DeIcing "De-icing controller V1.0"
			function Count_DEICING
				input Integer Count;
				input Integer Counter;
				output Integer CountMore;
				algorithm
					CountMore:=Count+Counter;
			end Count_DEICING;
			protected
				discrete Real tHeatStart;
				Boolean IceOn;
				discrete Real tIceStart;
				discrete Real tIceEnd;
				Integer CountIceOn;
			public
				Boolean DEICING "Dontrol signal de-icing";
				Boolean HEAT "Control signal heating";
				parameter Real tDeIcing(
					quantity="Basics.Time",
					displayUnit="s")=270 "Duration of de-icing process" annotation(Dialog(
					group="control time periods",
					tab="DE-ICING"));
				parameter Real tOperateIce(
					quantity="Basics.Time",
					displayUnit="s")=5400 "Duration between two de-icing processes" annotation(Dialog(
					group="control time periods",
					tab="DE-ICING"));
				parameter Real tOn(
					quantity="Basics.Time",
					displayUnit="s")=60 "Switch-on time of de-icing process" annotation(Dialog(
					group="control time periods",
					tab="DE-ICING"));
				parameter Real tOff(
					quantity="Basics.Time",
					displayUnit="s")=60 "Switch-off time of de-icing process" annotation(Dialog(
					group="control time periods",
					tab="DE-ICING"));
			initial equation
				CountIceOn = 0;
				tHeatStart = time.start;
				tIceStart = time.start;
				tIceEnd = time.start;
				IceOn = false;
			equation
						when not pre(HEAT) then
							CountIceOn=0;
						elsewhen not pre(IceOn) then
							if time>time.start then
								CountIceOn=Count_DEICING(pre(CountIceOn),1);
							else
								CountIceOn=Count_DEICING(pre(CountIceOn),0);
							end if;
						end when;
				
						when pre(HEAT) then
							tHeatStart=time;
						end when;
				
						when pre(IceOn) then
							tIceStart=time;
						end when;
				
						when not pre(IceOn) then
							tIceEnd=time;
						end when;
				
						when (((time-tHeatStart) > (tOperateIce/2)) and pre(HEAT) and (not (pre(CountIceOn) > 0))) then
							IceOn=true;
						elsewhen (((time-tIceEnd) > tOperateIce) and pre(HEAT) and (pre(CountIceOn) > 0)) then
							IceOn=true;
						elsewhen ((time-tIceStart) > (tOn+tDeIcing+tOff)) then
							IceOn=false;
						elsewhen (not pre(HEAT)) then
							IceOn=false;
						end when;
					
						DEICING = IceOn;
			annotation(Icon(coordinateSystem(extent={{-100,50},{100,-50}})));
		end DeIcing;
		model CirculationPump "Circulation pump control V1.0"
			Boolean HEAT "Heat signal";
			Boolean DEICING(
				start=false,
				fixed=true) "De-icing signal";
			Boolean CP "Switch-on/off of circulation pump";
			Boolean COMP(
				start=false,
				fixed=true) "Switch-on/off of compressor";
			Real TAmbient "Ambient temperature";
			protected
				discrete Real tEndComp;
				discrete Real tStartIce;
				Boolean CPon;
			public
				parameter Real tCPComp(
					quantity="Basics.Time",
					displayUnit="s")=600 "Follow-up time of circulation pump after compressor operation" annotation(Dialog(
					group="switching and operation time period",
					tab="HEATING"));
				parameter Real tCPIce(
					quantity="Basics.Time",
					displayUnit="s")=100 "Follow-up time of circulation pump while di-icing" annotation(Dialog(
					group="switching and operation time period",
					tab="DE-ICING"));
				parameter Real TBoundIce(
					quantity="Basics.Unitless",
					displayUnit="-")=7 "Boundary temperature for active/passive de-icing" annotation(Dialog(
					group="boundary temperature for active/passive de-icing",
					tab="DE-ICING"));
			initial equation
				tEndComp=time.start;
				tStartIce=time.start;
				CPon=HEAT;
			equation
				when not pre(COMP) and not pre(HEAT) then
					tEndComp=time;
				end when;
				
				when pre(DEICING) and (TAmbient < TBoundIce) then
					tStartIce=time;
				end when;
				
				when not pre(HEAT) and (time-tEndComp)>tCPComp then
					CPon=false;
				elsewhen pre(DEICING) and TAmbient>=TBoundIce and (time-tStartIce)>tCPIce then
					CPon=false;
				elsewhen not pre(CPon) and not pre(DEICING) and pre(HEAT) then
					CPon=true;
				end when;
				
				CP=CPon;
			annotation(Icon(coordinateSystem(extent={{-100,50},{100,-50}})));
		end CirculationPump;
		model SourcePump "Source pump control V1.0"
			protected
				discrete Real tEndComp;
				discrete Real tStartIce;
				Boolean SPon;
			public
				parameter Real tSP(
					quantity="Basics.Time",
					displayUnit="s")=60 "Follow-up time of source pump after compressor operation" annotation(Dialog(
					group="switching and operation time period",
					tab="HEATING"));
				parameter Real TBoundIce=7 "Boundary temperature for active/passive de-icing" annotation(Dialog(
					group="boundary temperature for active/passive de-icing",
					tab="DE-ICING"));
				Boolean HEAT "Heat signal";
				Boolean DEICING(
					start=false,
					fixed=true) "De-icing signal";
				Boolean SP "Switch on/off of source pump";
				Real TAmbient "Ambient temperature";
				Boolean COMP(
					start=false,
					fixed=true) "Compressor on/off";
			initial equation
				tEndComp=time.start;
				tStartIce=time.start;
				SPon=HEAT;
			equation
				when not pre(COMP) and not pre(HEAT) then
					tEndComp=time;
				end when;
				
				when pre(DEICING) and (TAmbient < TBoundIce) then
					tStartIce=time;
				end when;				
				
				when pre(HEAT) and not pre(DEICING) then
					SPon=true;
				elsewhen not pre(HEAT) and (time-tEndComp)>tSP then
					SPon=false;
				elsewhen pre(DEICING) and TAmbient<TBoundIce and (time-tStartIce)>tSP then
					SPon=false;
				elsewhen not pre(SPon) and not pre(DEICING) and pre(HEAT) then
					SPon=true;
				end when;
				
				SP=SPon;
			annotation(Icon(coordinateSystem(extent={{-100,50},{100,-50}})));
		end SourcePump;
		model Compressor "Compressor control V1.0"
			Boolean HEAT "Heat signal";
			Boolean DEICING(
				start=false,
				fixed=true) "De-icing signal";
			Boolean COMP "Switch-on/off of compressor";
			Boolean SP(
				start=false,
				fixed=true) "Switch-on/off of source pump";
			Boolean CP(
				start=false,
				fixed=true) "Switch-on/off of circulation pump";
			Real TAmbient "Ambient temperature";
			discrete Real tStartComp;
			discrete Real tEndComp;
			discrete Real tStartCP;
			discrete Real tStartSP;
			discrete Real tStartHeat;
			Boolean COMPon;
			parameter Real tMinOff(
				quantity="Basics.Time",
				displayUnit="s")=24 "Minimum turn-off time" annotation(Dialog(
				group="switching and operation time period",
				tab="HEATING"));
			parameter Real tMinOn(
				quantity="Basics.Time",
				displayUnit="s")=30 "Minimum turn-on time" annotation(Dialog(
				group="switching and operation time period",
				tab="HEATING"));
			parameter Real tCompCP(
				quantity="Basics.Time",
				displayUnit="s")=15 "Delay time compared to circultion pump" annotation(Dialog(
				group="switching and operation time period",
				tab="HEATING"));
			parameter Real tCompSP(
				quantity="Basics.Time",
				displayUnit="s")=60 "Delay time compared to source pump" annotation(Dialog(
				group="switching and operation time period",
				tab="HEATING"));
			parameter Real TBoundIce=7 "Boundary temperature for active/passive de-icing" annotation(Dialog(
				group="boundary temperature for active/passive de-icing",
				tab="DE-ICING"));
			initial equation
				if HEAT then
					tStartHeat = time.start-max(tCompCP,tCompSP)-1;				
					tStartCP = time.start-tCompCP-1;
					tStartSP = time.start-tCompSP-1;
					tStartComp = time.start-tMinOn-1;
					tEndComp = time.start;					
				else
					tStartHeat = time.start;				
					tStartCP = time.start;
					tStartSP = time.start;
					tStartComp = time.start;
					tEndComp = time.start-tMinOff-1;					
				end if;
				COMPon = HEAT;
			equation
				when pre(HEAT) then
					tStartHeat=time;
				end when;
				
				when pre(CP) then
					tStartCP=time;
				end when;
				
				when pre(SP) then
					tStartSP=time;
				end when;
				
				when pre(COMPon) then	
					tStartComp=time;
				end when;
				
				when not pre(COMPon) then
					tEndComp=time;
				end when;
				
				when (time-tStartCP)>tCompCP and (time-tStartSP)>tCompSP and pre(HEAT) and (time-tEndComp)>tMinOff and not pre(DEICING) then
					COMPon=true;
				elsewhen (time-tStartComp)>tMinOn and not pre(HEAT) then
					COMPon=false;
				elsewhen pre(DEICING) and TAmbient>=TBoundIce then
					COMPon=false;
				elsewhen not pre(DEICING) then
					COMPon=true;
				end when;
				
				COMP=COMPon;
			annotation(Icon(coordinateSystem(extent={{-100,50},{100,-50}})));
		end Compressor;
	initial equation
		assert(deltaTFlowRefMax>deltaTFlowRefMin,"qvRef not computable");
		if (AuxHeat) then	
			assert(deltaTAuxRefUp<deltaTActRefUp, "Temperature regulation limits must be within system control limits");
		end if;
		
		tHPStart = time.start;
		
		if (((TAct-TRef)<deltaTActRefUp) and Enable) then
			CPcontrol.HEAT=(not COPcontrol or (COPcontrol and (COP>COPmin)));
			SPcontrol.HEAT=(not COPcontrol or (COPcontrol and (COP>COPmin)));
			CompControl.HEAT=(not COPcontrol or (COPcontrol and (COP>COPmin)));
			DEICING.HEAT=(not COPcontrol or (COPcontrol and (COP>COPmin))) and SourceAir;
		else
			CPcontrol.HEAT=false;
			SPcontrol.HEAT=false;
			CompControl.HEAT=false;
			if SourceAir then
				DEICING.HEAT=false;
			else
				DEICING.HEAT=true;
			end if;
		end if;
		
		AUX = (((TAct-TRef)<deltaTActRefUp) and Enable) and (not COPcontrol or (COPcontrol and (COP>COPmin))) and (AuxHeat and (TAct-TRef)<deltaTAuxLow);
	equation
		if FlowControl then
			connect(AmbientConditions,TAverage.AmbientConditions);
		end if;
		
		if FlowControl then
			FlowTemperature.u[1]=TAverage.TAverage;
		end if;
		
		if FlowControl then
			TFlowControl=FlowTemperature.y[1];
		else
			TFlowControl=TFlowRef;
		end if;
		
		when pre(CompControl.HEAT) then
			tHPStart=time;
		end when;
		
		when (((TAct-TRef)<deltaTActRefLow) and Enable and (not COPcontrol or (COPcontrol and (COP>COPmin))))  then
			CPcontrol.HEAT=true;
			SPcontrol.HEAT=true;
			CompControl.HEAT=true;
			if SourceAir then	
				DEICING.HEAT=true;
			end if;
		elsewhen (((TAct-TRef)>deltaTActRefUp) or (TFlow>TFlowMax) or (TReturn>TReturnMax) or not Enable or (COPcontrol and (COP<=COPmin))) then
			CPcontrol.HEAT=false;
			SPcontrol.HEAT=false;
			CompControl.HEAT=false;
			if SourceAir then
				DEICING.HEAT=false;
			else
				DEICING.HEAT=true;
			end if;
		end when;
		
		when pre(CompControl.HEAT) and Enable and AuxHeat and (time-tHPStart)>tBiv and (TAct-TRef)<deltaTAuxLow then
			AUX=true;
		elsewhen (not Enable or not pre(CompControl.HEAT) or ((TAct-TRef)>deltaTAuxUp)) and pre(AUX) then
			AUX=false;
		end when;
		
		if SourceAir then
			CPcontrol.DEICING=DEICING.DEICING;
			SPcontrol.DEICING=DEICING.DEICING;
			CompControl.DEICING=DEICING.DEICING;
		else
			CPcontrol.DEICING=false;
			SPcontrol.DEICING=false;
			CompControl.DEICING=false;
		end if;
		
		if SourceAir then	
			CPcontrol.TAmbient=AmbientConditions.TAmbient;
			SPcontrol.TAmbient=AmbientConditions.TAmbient;
			CompControl.TAmbient=AmbientConditions.TAmbient;
		else
			CPcontrol.TAmbient=280.15;
			SPcontrol.TAmbient=280.15;
			CompControl.TAmbient=280.15;
		end if;
		
		CPcontrol.COMP=CompControl.COMP;
		SPcontrol.COMP=CompControl.COMP;
		
		CompControl.CP=CPcontrol.CP;
		CompControl.SP=SPcontrol.SP;
			
		if Enable then	
			HP=CompControl.COMP;
			CP=CPcontrol.CP;
			SP=SPcontrol.SP;
		else
			HP=false;
			CP=false;
			SP=false;
		end if;
		
		if SP  then
			qvSourceRef=qvSource;
		else
			qvSourceRef=0;
		end if;
		
		if CP  then
			if HP then	
				qvRef=max(min((qvMin+(qvMax-qvMin)*(((TFlow-(TFlowControl+deltaTFlowRefMin))/(deltaTFlowRefMax-deltaTFlowRefMin)))),qvMax),qvMin);
			else
				qvRef=qvMin;
			end if;
		else
			qvRef=0;
		end if;
		
		HPon=HP;
		
		if SourceAir then
			DEICINGon=DEICING.DEICING;
		end if;
		
		CPon=CP;
		SPon=SP;
		
		if (AuxHeat) then
			AUXon=AUX;
		end if;
	annotation(
		__iti_viewinfo[0](
			viewSettings(clrRaster=12632256),
			simViewInfos[0](
				runtimeClass="CSimView",
				tabGroup=0,
				tabFrame=0,
				tabAlignment=0,
				typename="ModelViewInfo"),
			simViewInfos[1](
				runtimeClass="CSimXModelicaView",
				tabGroup=0,
				tabFrame=0,
				tabAlignment=0,
				typename="ViewInfo"),
			simViewInfos[2](
				runtimeClass="CSimXModelicaView",
				tabGroup=0,
				tabFrame=0,
				tabAlignment=0,
				typename="ViewInfo"),
			simViewInfos[3](
				runtimeClass="CSimXModelicaView",
				tabGroup=0,
				tabFrame=0,
				tabAlignment=0,
				typename="ViewInfo"),
			typename="ModelInfo"),
		Icon(
			coordinateSystem(extent={{-200,-200},{200,200}}),
			graphics={
				Bitmap(
					imageSource="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
AAAASUVORK5CYII=",
					extent={{-200,200},{200,-200}})}),
		Documentation(info="MIME-Version: 1.0
Content-Type: multipart/related;boundary=\"--$iti$\";type=\"text/html\"

----$iti$
Content-Type:text/html;charset=\"iso-8859-1\"
Content-Transfer-Encoding: quoted-printable
Content-Location: C:\\Users\\schwan\\AppData\\Local\\Temp\\iti319F.tmp\\hlp3675.tmp\\HPControlHeatLed.htm

<=21DOCTYPE HTML PUBLIC =22-//W3C//DTD HTML 4.0 Transitional//EN=22>
<HTML><HEAD><TITLE>Heat-led HP controller V1.0</TITLE>
<META content=3D=22text/html; charset=3Diso-8859-1=22 http-equiv=3DContent-T=
ype>
<STYLE type=3Dtext/css>
p, li =7Bfont-family: Verdana, Arial, Helvetica, sans-serif; font-size:12px;=
 color: =23000000;=7D
.Ueberschrift1 =7Bfont-family: Verdana, Arial, Helvetica, sans-serif; font-s=
ize:14px; font-weight:bold; color:=23000000; margin-top:0; margin-bottom:6px=
;=7D
.Ueberschrift2 =7Bfont-family: Verdana, Arial, Helvetica, sans-serif; font-s=
ize:12px; font-weight:bold; color:=23000000; margin-top:6px; margin-bottom:6=
px;=7D
.Ueberschrift3 =7Bfont-family: Verdana, Arial, Helvetica, sans-serif; font-s=
ize:12px; font-weight:bold; font-style:italic; color:=23000000; margin-top:6=
px; margin-bottom:6px;=7D
.SymbolTab =7Bfont-family: Verdana, Arial, Helvetica, sans-serif; font-size:=
12px; font-weight:bold; color:=23000000;=7D
</STYLE>
<LINK rel=3Dstylesheet href=3D=22../format_help.css=22>
<META name=3DGENERATOR content=3D=22MSHTML 10.00.9200.16721=22></HEAD>
<BODY link=3D=230000ff bgColor=3D=23ffffff vLink=3D=23800080>
<P class=3DUeberschrift1 style=3D=22MARGIN-BOTTOM: 0px; MARGIN-TOP: 0px=22>H=
eat-led HP 
controller V1.0</P>
<HR style=3D=22MARGIN-BOTTOM: 0px; MARGIN-TOP: 0px=22 SIZE=3D1 noShade>

<TABLE borderColor=3D=23ffffff cellSpacing=3D0 borderColorDark=3D=23ffffff c=
ellPadding=3D2 
width=3D=22100%=22 bgColor=3D=23cccccc borderColorLight=3D=23ffffff border=
=3D1>
  <TBODY>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>Symbol:</P></TD>
    <TD bgColor=3D=23ffffff vAlign=3Dtop colSpan=3D3><IMG 
      src=3D=22HPControlHeatLed=5Csymbol.png=22 width=3D124 height=3D124></T=
D></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>Ident:</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop colSpan=3D3>
      <P 
  class=3DSymbolTab>GreenBuilding.HeatPump.Control.HPControlHeatLed</P></TD>=
</TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>Version:</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop colSpan=3D3>
      <P class=3DSymbolTab>1.0</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>File:</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop colSpan=3D3>
      <P class=3DSymbolTab></P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>Connectors:</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Ambient Conditions Connection</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>AmbientConditions</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Reference temperature</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>TRef</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Actual temperature</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>TAct</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Flow temperature</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>TFlow</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Return temperature</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>TReturn</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Reference flow temperature</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>TFlowRef</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>target volume flow</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>qvRef</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Reference volume flow of source pump</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>qvSourceRef</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>External control input</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Enable</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Switch-on/off of HP</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>HPon</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Switch-on/off of circulation pump</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>CPon</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Source pump switch on/off</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>SPon</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Switch on/off de-icing</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>DEICINGon</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>Parameters:</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>If true, heat pump uses ambient air for heat 
    source</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>SourceAir</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>If true, switches on if COP is greater than a cer=
tain 
      threashold level</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>COPcontrol</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Minimum COP when heat pump can be used if it is =

      COP-controlled</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>COPmin</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>If true, flow temperature controlled by ambient =

      temperature, else manually controlled</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>FlowControl</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>If true, auxiliary heat power supply, else none</=
P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>AuxHeat</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Delay time between circultion pump and compressor=
 
      starting</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>tDelayHP</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Minimum turn-on time of HP</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>tHPminOn</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Minimum turn-off time of HP</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>tHPminOff</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Delay time between HP and circulation pump 
    shutdown</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>tDelayCP</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Delay time between shutdown of compressor and 
      circulation pump</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>tDelayCPComp</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Delay time between shutdown of compressor and 
      circulation pump during de-icing process</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>tDelayCPIce</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Delay time while not reaching reference temperatu=
re 
      until auxiliary heating system starts</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>tBivalence</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Delay time between source pump and HP starting</P=
></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>tDelaySP</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Delay time between shutdown of compressor and sou=
rce 
      pump</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>tDelaySPComp</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Maximum flow temperature</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>TFlowMax</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Maximum return temperature</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>TReturnMax</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Lowmost temperature difference between actual and=
 
      reference temperature (&gt;0: TLow&gt;TRef; &lt;0: TLow&lt;TRef)</P></=
TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>deltaTActRefLow</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Upmost temperature difference between actual and =

      reference temperature (&gt;0: TUp&gt;TRef; &lt;0: TUp&lt;TRef)</P></TD=
>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>deltaTActRefUp</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Temperature difference between actual temperature=
 and 
      reference temperature for auxiliary heating switch-off</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>deltaTAuxRefUp</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Temperature difference between actual temperature=
 and 
      reference temperature for auxiliary heating switch-on</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>deltaTAuxRefLow</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>File name for flow temperature control by ambient=
 
      temperature</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>FlowFile</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Table name for flow temperature control by ambien=
t 
      temperature</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>FlowTable</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Maximum temperature for flow control</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>TAmbientMax</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Minimum temperature for flow control</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>TAmbientMin</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Used support points for temperature averaging</P>=
</TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>SupportPointsAmbientTemperature</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Used time step for temperature averaging</P></TD>=

    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>TimeStepAmbientTemperature</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Constant velocity of source pump</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>qvSource</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Temperature difference (TFlow-TFlowRef) when 
      qvRef=3DqvMax</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>deltaTFlowRefMax</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Temperature difference (TFlow-TFlowRef) when 
      qvRef=3DqvMin</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>deltaTFlowRefMin</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Maximum volume flow of circulation pump</P></TD>=

    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>qvMax</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Minimum volume flow of circulation pump</P></TD>=

    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>qvMin</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Boundary temperature for change between active an=
d 
      passive de-icing</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>TDeIcingBound</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Duration of de-icing process</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>tDeIcing</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Statistically operation time between two de-icing=
 
      processes</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>tOperation</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Switch-on time of de-icing process</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>tDeIcingOn</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Shutdown time of de-icing process</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>tDeIcingOff</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>Results:</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>target volume flow</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>qvRef</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Reference volume flow of source pump</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>qvSourceRef</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Switch-on/off of HP</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>HPon</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Switch-on/off of circulation pump</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>CPon</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Auxiliary heat switch on/off</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>AUXon</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Source pump switch on/off</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>SPon</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Switch on/off de-icing</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>DEICINGon</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR></TBODY></TABLE>
<P class=3DUeberschrift2>Description:</P>
<P style=3D=22MARGIN-BOTTOM: 0px; MARGIN-TOP: 6pt=22>This model controls the=
 operation 
of a simulated heat pump system regarding heat demand (temperature spread 
between actual and reference temperature) of an external heat sink (building=
, 
heat storage, heat supply via hydraulic shunt). It can be seen as a model fo=
r 
heat pump manager systems. </P>
<P style=3D=22MARGIN-BOTTOM: 0px; MARGIN-TOP: 6pt=22>Firstly the controller =
model has 
to be defined regarding the configuration of heat pump system to be controll=
ed. 
If this heat pump uses ambient air as environmental heat source the 
'SourceAir'-parameter has to be set to 'true'. In opposite to heat pumps usi=
ng 
other environmental heat sources (ground, well water) air heat pumps must be=
 
de-iced during heating process to completely ensure their functionality. In =
this 
process these devices are switched-off during heating and the operation mode=
 is 
turned for a short time period. Defining these time periods needs for 
measurement data of internal system states of the controlled heat pump syste=
m 
(e.g. working medium temperature). Because inner processes were neglected in=
 
heat pump model these states are not available during simulation run. To ena=
ble 
the consideration of influences of a de-icing process on heat power output a=
nd 
overall system behavior a statistical approach to define the de-icing proces=
s 
was needed. Therefore measurement results for different heat pump systems we=
re 
scrutinized and a statistical approach was developed. So, de-icing processe=
s 
are switched-on and -off after statistic time periods. Their duration is als=
o 
defined by statistical data. Nevertherless user can define these time period=
s 
manually in 'De-Icing'-parameter dialogue. Without further results of 
measurements for a specific heat pump system, please use pre-defined paramet=
ers 
for simulations run.</P>
<P style=3D=22MARGIN-BOTTOM: 0px; MARGIN-TOP: 6pt=22>Furthermore, the operat=
ion of a 
de-icing process depends on the air temperature used as environmental heat =

source. Below 'TDeIcingBound' (should be set at about 7=B0C - measurement re=
sults) 
a de-icing process needs a complete turn of heat pump operation mode, so 
compressor and circulation pump stays switched-on and ventilator is 
switched-off. Above this temperature level compresser and circulation pump c=
an 
be switched-off during de-icing process, only ventilator has to stay switche=
d-on 
to provide heat for de-icing.</P>
<P style=3D=22MARGIN-BOTTOM: 0px; MARGIN-TOP: 6pt=22>Enabling ambient air as=
 heat 
source also needs to focus on the maximum and minimum source pump volume flo=
w. 
Because the source pump of an air heat pump is a ventilator (instead of a 
circulation pump) its maximum volume flow is much higher than the one of nor=
mal 
electric pumps at least (more than 1000 m3/h comparing to less than 10 m3/h)=
. 
Make sure that these source pump parameters are defined correctly to avoid w=
rong 
system operation. To parameterize these values regard heat pump source file =
in 
model data directory. </P>
<P style=3D=22MARGIN-BOTTOM: 0px; MARGIN-TOP: 6pt=22>Secondly, it has to be =
defined if 
simulated heat pump should also be controlled regarding a minimum coeffcient=
 of 
performance (COP). Because of the reduced system efficiency at low COPs 
sometimes it could be more useful to use additional heating systems (e.g. 
condensing boiler) instead of the heat pump for heating.</P>
<P style=3D=22MARGIN-BOTTOM: 0px; MARGIN-TOP: 6pt=22>Furthermore flow temper=
ature 
control mode has to be characterized. That means, if 'FlowControl' is true, =
the 
reference flow temperature of heat pump is defined regarding ambient tempera=
ture 
and an arbitrary flow temperature characteristic in model data directory. If=
 a 
static reference flow temperature should be used for simulation, 'FlowContro=
l' 
should remain 'false'. To avoid high dynamic oscillations during simulation =
run, 
average ambient temperature is used for flow temperature control. Averaging =

ambient temperature needs to define a number of support points and a time st=
ep 
size in the parameter dialogue. These parameters are used to calculate the =

average ambient temperature out of several data points. The time difference =

between each data point is the time step. The number of data points used for=
 
calculation is the number of support points. When initializing, initial ambi=
ent 
temperature is used as data point for every support point.</P>
<P style=3D=22MARGIN-BOTTOM: 0px; MARGIN-TOP: 6pt=22>At last, it has to be d=
etermined 
if an auxiliary, internal, electric heating system should be controlled. Tha=
t 
way, heat power output of heat pump system can be increased when heat demand=
 
exceeds maximum level.</P>
<P style=3D=22MARGIN-BOTTOM: 0px; MARGIN-TOP: 6pt=22>After this controller =

configuration all connectors to be defined for the simulation are available =
to 
be connected to heat pump and heating system. Make sure that all connectors =
are 
characterized to avoid numerical difficulties.</P>
<P style=3D=22MARGIN-BOTTOM: 0px; MARGIN-TOP: 6pt=22>Basically the heat pump=
 
controller uses besides maximum flow and return temperature a temperature 
hysteresis around reference temperature for the connected heating system (he=
at 
storage, hydraulic shunt, building zone) as control parameters for system 
switch-on/off:</P>
<UL>
  <LI>
  <DIV style=3D=22MARGIN-BOTTOM: 0px; MARGIN-TOP: 6pt=22>If: 
  (TAct-TRef)&lt;deltaTActRefLow, heat pump is switched-on.</DIV>
  <LI>
  <DIV style=3D=22MARGIN-BOTTOM: 0px; MARGIN-TOP: 6pt=22>if: 
  (TAct-TRef)&gt;deltaTActRefUp, heat pump is switched-off.</DIV></LI></UL>=

<P style=3D=22MARGIN-BOTTOM: 0px; MARGIN-TOP: 6pt=22>Besides the main contro=
l 
parameters and characteristics an additional input connector is provided 
('Enable'). This connector can be defined by external energy management syst=
ems 
to enable/disable CHP operation. If the CHP controller should work autonomou=
sly 
define this connector with a static 'true' argument. This connector also ena=
bles 
to switch-off heat pump system externally at times of high electricity deman=
d 
(off-time).</P>
<P style=3D=22MARGIN-BOTTOM: 0px; MARGIN-TOP: 6pt=22>The flow temperature of=
 heat pump 
is controlled by a temperature hysteresis around the reference flow temperat=
ure 
(depending on flow control mode). As control state the reference volume flow=
 
signal of the circulation pump is used:</P>
<UL>
  <LI>
  <DIV style=3D=22MARGIN-BOTTOM: 0px; MARGIN-TOP: 6pt=22>If: 
  (TFlow-TFlowRef)&gt;deltaTFlowRefMax, the reference volume flow is 
  maximum.</DIV>
  <LI>
  <DIV style=3D=22MARGIN-BOTTOM: 0px; MARGIN-TOP: 6pt=22>if: 
  (TFlow-TFlowRef)&lt;deltaTFlowRefMin, the reference volume flow output is =

  minimum.</DIV>
  <LI>
  <DIV style=3D=22MARGIN-BOTTOM: 0px; MARGIN-TOP: 6pt=22>
  <DIV style=3D=22MARGIN-BOTTOM: 0px; MARGIN-TOP: 6pt=22>Between the two tem=
perature 
  boundaries the reference volume flow is linearily 
  interpolated.</DIV></DIV></LI></UL>
<P style=3D=22MARGIN-BOTTOM: 0px; MARGIN-TOP: 6pt=22>Maximum volume depends =
on the 
selected circulation pump (c.f. model data directory), but minimum volume fl=
ow 
can be defined depending on heat pump system data sheet values. Make sure th=
at 
minimum volume flow is set to a value above zero because this is needed to s=
tart 
volume flow control at all. Note that minimum volume flow should be set to a=
 
level where heat power output can be performed easily with an adequate 
temperature spread (TFlow-TReturn). If this value is too high, volume flow =

control can cause system state faults.</P>
<P style=3D=22MARGIN-BOTTOM: 0px; MARGIN-TOP: 6pt=22>If an auxiliary heating=
 system 
has to be controlled a corresponding temperature hysteresis around reference=
 
temperature for the connected heating system has to be defined:</P>
<UL>
  <LI>
  <DIV style=3D=22MARGIN-BOTTOM: 0px; MARGIN-TOP: 6pt=22>If: 
  (TAct-TRef)&lt;deltaTAuxRefLow, auxiliary heating system is switched-on.</=
DIV>
  <LI>
  <DIV style=3D=22MARGIN-BOTTOM: 0px; MARGIN-TOP: 6pt=22>if: 
  (TAct-TRef)&gt;deltaTAuxRefUp, auxiliary heating system is 
  switched-off.</DIV></LI></UL>
<P style=3D=22MARGIN-BOTTOM: 0px; MARGIN-TOP: 6pt=22>To ensure that auxiliar=
y heating 
system is only swithched-on when heat demand is too high, it only can be 
switched-on, if actual heating system temperature stays below the minimum le=
vel 
for a certain time period (tBivalence). Make sure that switch-off temperatur=
e 
level for auxiliary heating system is set below correspondent temperature le=
vel 
for overall system switch-off to avoid extensive usage of auxiliary heating =

system (auxiliary heating system should work as slave system only when reall=
y 
needed).</P>
<P style=3D=22MARGIN-BOTTOM: 0px; MARGIN-TOP: 6pt=22>Finally, user is given =
the 
possibility to vary internal operation time constants (minimum switch-on/off=
 
time etc.) of heat pump manager. If there are no validated timing informatio=
n 
available for a special heat pump manager, please use pre-defined 
ones.</P></BODY></HTML>


----$iti$
Content-Type: image/png
Content-Transfer-Encoding: base64
Content-Location: HPControlHeatLed\\symbol.png

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

----$iti$--"),
		experiment(
			StopTime=0.999999999999994,
			StartTime=0,
			Interval=0.00199999999999999,
			__iti_MaxInterval="10",
			__iti_AbsTolerance="1e-06"));
end hPController_demandResponse_dc;
