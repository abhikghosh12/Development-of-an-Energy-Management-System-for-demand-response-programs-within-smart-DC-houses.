// CP: 65001
// SimulationX Version: 3.7.2.40674 x64
within ;
model HeatPumpDC1 "HeatPumpDC1.mo"
	protected
		Boolean DeIcing "DeIcing on/off-switch";
	public
		input Modelica.Blocks.Interfaces.RealInput qvRef(
			quantity="Thermics.VolumeFlow",
			displayUnit="m³/h") "Reference volume flow of circulation pump" annotation(
			Placement(
				transformation(
					origin={115,105},
					extent={{-20,-20},{20,20}},
					rotation=-90),
				iconTransformation(
					origin={100,200},
					extent={{-20,-20},{20,20}},
					rotation=-90)),
			Dialog(
				group="Volume Flow",
				tab="Results 1",
				showAs=ShowAs.Result));
		input Modelica.Blocks.Interfaces.RealInput qvSourceRef(
			quantity="Thermics.VolumeFlow",
			displayUnit="m³/h") "Reference volume flow of source pump" annotation(
			Placement(
				transformation(
					origin={170,105},
					extent={{-20,-20},{20,20}},
					rotation=-90),
				iconTransformation(
					origin={150,200},
					extent={{-20,-20},{20,20}},
					rotation=-90)),
			Dialog(
				group="Volume Flow",
				tab="Results 1",
				showAs=ShowAs.Result));
	protected
		Real qv(
			quantity="Thermics.VolumeFlow",
			displayUnit="m³/h") "Actual volume flow of circulation pump" annotation(Dialog(
			group="Volume Flow",
			tab="Results 1",
			showAs=ShowAs.Result));
		Real qvSource(
			quantity="Thermics.VolumeFlow",
			displayUnit="m³/h") "Actual volume flow of source pump" annotation(Dialog(
			group="Volume Flow",
			tab="Results 1",
			showAs=ShowAs.Result));
	public
		input Modelica.Blocks.Interfaces.BooleanInput HPon "Switch on/off of HP" annotation(
			Placement(
				transformation(extent={{-85,61},{-45,101}}),
				iconTransformation(extent={{-220,80},{-180,120}})),
			Dialog(
				group="I/O",
				tab="Results 1",
				showAs=ShowAs.Result));
		input Modelica.Blocks.Interfaces.BooleanInput CPon "Switch on/off of circulation pump" annotation(
			Placement(
				transformation(extent={{-85,10},{-45,50}}),
				iconTransformation(extent={{-220,-20},{-180,20}})),
			Dialog(
				group="I/O",
				tab="Results 1",
				showAs=ShowAs.Result));
		input Modelica.Blocks.Interfaces.BooleanInput SPon "I/O-switch for source pump" annotation(
			Placement(
				transformation(
					origin={-5,105},
					extent={{-20,-20},{20,20}},
					rotation=-90),
				iconTransformation(
					origin={-200,50},
					extent={{-20,-20},{20,20}})),
			Dialog(
				group="I/O",
				tab="Results 1",
				showAs=ShowAs.Result));
		GreenBuilding.Interfaces.Electrical.DC SPGrid " DC connection of source pump to Grid" annotation(Placement(
			transformation(
				origin={95,-140},
				extent={{-10,-10},{10,10}},
				rotation=-90),
			iconTransformation(
				origin={200,-150},
				extent={{-10,-10},{10,10}},
				rotation=-90)));
		GreenBuilding.Interfaces.Electrical.DC CPGrid " DC connection of circulation pump to Grid" annotation(Placement(
			transformation(extent={{155,-150},{175,-130}}),
			iconTransformation(extent={{-10,-210},{10,-190}})));
		GreenBuilding.Interfaces.Electrical.DC COMPGrid " DC connection of compressor to Grid" annotation(Placement(
			transformation(extent={{-135,-150},{-115,-130}}),
			iconTransformation(extent={{-160,-210},{-140,-190}})));
		GreenBuilding.Interfaces.Thermal.VolumeFlowIn ReturnHP "Return pipe" annotation(Placement(
			transformation(extent={{240,-25},{260,-5}}),
			iconTransformation(extent={{190,-10},{210,10}})));
		GreenBuilding.Interfaces.Thermal.VolumeFlowOut FlowHP "flow pipe" annotation(Placement(
			transformation(extent={{240,30},{260,50}}),
			iconTransformation(extent={{190,90},{210,110}})));
		GreenBuilding.Interfaces.Ambience.AmbientCondition AmbientConditions "Ambient Connection Connection" annotation(Placement(
			transformation(extent={{75,85},{95,105}}),
			iconTransformation(extent={{-110,190},{-90,210}})));
		input Modelica.Blocks.Interfaces.BooleanInput DEICINGon if SourceAir "Switch on/off de-icing process for air heat pumps" annotation(
			Placement(
				transformation(extent={{220,55},{260,95}}),
				iconTransformation(extent={{-220,-120},{-180,-80}})),
			Dialog(
				group="I/O",
				tab="Results 1",
				showAs=ShowAs.Result));
		output Modelica.Blocks.Interfaces.RealOutput COP "Actual COP of heat pump" annotation(
			Placement(
				transformation(extent={{240,90},{260,110}}),
				iconTransformation(extent={{-190,-160},{-210,-140}})),
			Dialog(
				group="Coefficient of Performance",
				tab="Results 1",
				showAs=ShowAs.Result));
		GreenBuilding.Interfaces.Electrical.DefineCurrentDC SPGridConnection annotation(
			Placement(transformation(
				origin={95,-70},
				extent={{-10,-10},{10,10}},
				rotation=-90)),
			Dialog(
				group="Coefficient of Performance",
				tab="Results 1"));
		GreenBuilding.Interfaces.Electrical.DefineCurrentDC CPGridConnection annotation(
			Placement(transformation(
				origin={240,-70},
				extent={{10,-10},{-10,10}},
				rotation=90)),
			Dialog(
				group="Coefficient of Performance",
				tab="Results 1"));
		Modelica.Blocks.Tables.CombiTable1D PelCP(
			tableOnFile=true,
			tableName=CPTable,
			fileName=HPFile) "Electrical power demand of circulation pump" annotation(
			Placement(transformation(extent={{-10,-10},{10,10}})),
			Dialog(
				group="Coefficient of Performance",
				tab="Results 1"));
		Modelica.Blocks.Tables.CombiTable1D PelSP(
			tableOnFile=true,
			tableName=SPTable,
			fileName=HPFile) "Electrical power demand of source pump" annotation(
			Placement(transformation(extent={{-10,-10},{10,10}})),
			Dialog(
				group="Coefficient of Performance",
				tab="Results 1"));
		Modelica.Blocks.Tables.CombiTable2D QHeatPump(
			tableOnFile=true,
			tableName=QHeatTable,
			fileName=HPFile) "Heat power output of heat pump" annotation(
			Placement(transformation(extent={{-10,-10},{10,10}})),
			Dialog(
				group="Coefficient of Performance",
				tab="Results 1"));
		Modelica.Blocks.Tables.CombiTable2D COPHeatPump(
			tableOnFile=true,
			tableName=COPTable,
			fileName=HPFile) "COP of heat pump" annotation(
			Placement(transformation(extent={{-10,-10},{10,10}})),
			Dialog(
				group="Coefficient of Performance",
				tab="Results 1"));
	protected
		Real TFlow(
			quantity="Thermics.Temp",
			displayUnit="°C") "Flow temperature of HP" annotation(Dialog(
			group="Temperature",
			tab="Results 1",
			showAs=ShowAs.Result));
	public
		Real TSource(
			quantity="Thermics.Temp",
			displayUnit="°C") "Temperature of heat source" annotation(Dialog(
			group="Temperature",
			tab="Results 1",
			showAs=ShowAs.Result));
	protected
		Real TReturn(
			quantity="Thermics.Temp",
			displayUnit="°C") "Return temperature of HP" annotation(Dialog(
			group="Temperature",
			tab="Results 1",
			showAs=ShowAs.Result));
		Real QHeatInput(
			quantity="Basics.Power",
			displayUnit="kW") "actual heat power" annotation(Dialog(
			group="Heating Power",
			tab="Results 1",
			showAs=ShowAs.Result));
	public
		Real QHeat(
			quantity="Basics.Power",
			displayUnit="kW") "Heat output power of HP" annotation(Dialog(
			group="Heating Power",
			tab="Results 1",
			showAs=ShowAs.Result));
		Real PSP(
			quantity="Basics.Power",
			displayUnit="kW") "Effective power of source pump" annotation(Dialog(
			group="Electrical Power",
			tab="Results 2",
			showAs=ShowAs.Result));
		Real PCP(
			quantity="Basics.Power",
			displayUnit="kW") "Effective power of circulation pump" annotation(Dialog(
			group="Electrical Power",
			tab="Results 2",
			showAs=ShowAs.Result));
		Real PCOMP(
			quantity="Basics.Power",
			displayUnit="kW") "Effective power of compressor" annotation(Dialog(
			group="Electrical Power",
			tab="Results 2",
			showAs=ShowAs.Result));
		Real EHeat(
			quantity="Basics.Energy",
			displayUnit="kWh") "Heat output of heat pump" annotation(Dialog(
			group="Energy",
			tab="Results 2",
			showAs=ShowAs.Result));
		Real ECOMP(
			quantity="Basics.Energy",
			displayUnit="kWh") "Electrical energy demand of compressor" annotation(Dialog(
			group="Energy",
			tab="Results 2",
			showAs=ShowAs.Result));
		Real ECP(
			quantity="Basics.Energy",
			displayUnit="kWh") "Electrical energy demand of circulation pump" annotation(Dialog(
			group="Energy",
			tab="Results 2",
			showAs=ShowAs.Result));
		Real ESP(
			quantity="Basics.Energy",
			displayUnit="kWh") "Electrical energy demand of source pump" annotation(Dialog(
			group="Energy",
			tab="Results 2",
			showAs=ShowAs.Result));
	protected
		discrete Real StartTime(
			quantity="Basics.Time",
			displayUnit="s") "Starting time of HP" annotation(Dialog(
			group="Timing",
			tab="Results 2",
			showAs=ShowAs.Result));
		discrete Real DeIcingEndTime(
			quantity="Basics.Time",
			displayUnit="s") "Ending time of de-icing proceess" annotation(Dialog(
			group="Timing",
			tab="Results 2",
			showAs=ShowAs.Result));
	public
		GreenBuilding.Interfaces.Electrical.DefineCurrentDC COMPGridConnection annotation(
			Placement(transformation(
				origin={-125,-70},
				extent={{10,-10},{-10,10}},
				rotation=90)),
			Dialog(
				group="Timing",
				tab="Results 2"));
		parameter Boolean SourceAir=true "If true, heat pump uses ambient air for heat source" annotation(Dialog(
			group="Source Pump - Configuration",
			tab="Model Configuration"));
		parameter Integer SourcePhase=1 "Phase number of source pump grid connection (ventilator, brine pump)" annotation(Dialog(
			group="Source Pump - Configuration",
			tab="Model Configuration"));
		parameter Integer CompPhase=1 "Phase number of HP-compressor" annotation(Dialog(
			group="Compressor Configuration",
			tab="Model Configuration"));
		parameter Real cpMed(
			quantity="Thermics.SpecHeatCapacity",
			displayUnit="kJ/(kg·K)")=4177 "Specific heat capacity of heating medium" annotation(Dialog(
			group="Heating System",
			tab="Heat Pump - Dimensions"));
		parameter Real rhoMed(
			quantity="Basics.Density",
			displayUnit="kg/m³")=1000 "Density of heating medium" annotation(Dialog(
			group="Heating System",
			tab="Heat Pump - Dimensions"));
		parameter Real VHP(
			quantity="Geometry.Volume",
			displayUnit="l")=0.01 "Heating medium volume of HP" annotation(Dialog(
			group="Heating System",
			tab="Heat Pump - Dimensions"));
		parameter Real TAmbient(
			quantity="Thermics.Temp",
			displayUnit="°C")=291.14999999999998 "Ambient temperature" annotation(Dialog(
			group="Heat Losses",
			tab="Heat Pump - Dimensions"));
		parameter Real QlossRate(
			quantity="Thermics.HeatCond",
			displayUnit="W/K")=0.2 "Heat loss rate of HP-isolation" annotation(Dialog(
			group="Heat Losses",
			tab="Heat Pump - Dimensions"));
		parameter String HPFile=GreenBuilding.Utilities.Functions.getModelDataDirectory()+"\\heat_pump\\hp_data\\Stiebel_Eltron\\WPL_10_ACS\\SE_WPL_10_DC.txt" "File name for heat pump characteristics" annotation(Dialog(
			group="Heating Power",
			tab="HP - Power Data"));
		parameter String QHeatTable="Q_AW" "Table name for source and flow temperature depending heat power output" annotation(Dialog(
			group="Heating Power",
			tab="HP - Power Data"));
		parameter String COPTable="COP" "Table name for source and flow temperature depending COP of HP" annotation(Dialog(
			group="Heating Power",
			tab="HP - Power Data"));
		parameter Real CosPhiCOMP=0.7 "Power factor of compressor" annotation(Dialog(
			group="Heating Power",
			tab="HP - Power Data"));
		parameter Real TSourceMin(
			quantity="Thermics.Temp",
			displayUnit="°C")=253.14999999999998 "Minimum source temperature for heat pump" annotation(Dialog(
			group="Boundaries",
			tab="HP - Power Data"));
		parameter Real TSourceMax(
			quantity="Thermics.Temp",
			displayUnit="°C")=293.14999999999998 "Maximum source temperature for heat pump" annotation(Dialog(
			group="Boundaries",
			tab="HP - Power Data"));
		parameter Real TFlowMin(
			quantity="Thermics.Temp",
			displayUnit="°C")=288.14999999999998 "Minimum flow temperature for heat pump" annotation(Dialog(
			group="Boundaries",
			tab="HP - Power Data"));
		parameter Real TFlowMax(
			quantity="Thermics.Temp",
			displayUnit="°C")=333.14999999999998 "Maximum flow temperature for heat pump" annotation(Dialog(
			group="Boundaries",
			tab="HP - Power Data"));
		parameter Real depthGround(
			quantity="Geometry.Length",
			displayUnit="m")=10 if not SourceAir "Average depth of ground environmental heat is taken of" annotation(Dialog(
			group="Source Ground",
			tab="HP - Power Data"));
		parameter String CPTable="P_CP" "Table name for CP-power behavior" annotation(Dialog(
			group="Power Data",
			tab="CP - Dimensions"));
		parameter Real qvMax(
			quantity="Thermics.VolumeFlow",
			displayUnit="m³/h")=0.00083333333333333328 "Maximum volume flow of CP" annotation(Dialog(
			group="Boundaries",
			tab="CP - Dimensions"));
		parameter Real qvMin(
			quantity="Thermics.VolumeFlow",
			displayUnit="m³/h")=0.00019444444444444443 "Minimum volume flow of CP" annotation(Dialog(
			group="Boundaries",
			tab="CP - Dimensions"));
		parameter String SPTable="P_VEN" "Table name for volume flow depending power demand of source pump" annotation(Dialog(
			group="Power Data",
			tab="SP - Dimensions"));
		parameter Real CosPhiSP=0.98 "Power factor of source pump" annotation(Dialog(
			group="Power Data",
			tab="SP - Dimensions"));
	protected
		function ground
			input Real depthGround;
			input Real DayOfYear;
			input Boolean LeapYear;
			input Real cGround;
			input Real lambdaGround;
			input Real rhoGround;
			input Real GeoGradient;
			input Real TAmbientAverage;
			input Real TAmbientMax;
			input Integer MaxMonth;
			output Real TGround;
			protected
				Real a=lambdaGround/(rhoGround*cGround);
				Real xi;
				Real TimePeriod;
				Real PhaseDisplacement=2*pi*MaxMonth/12;
			algorithm
				if (LeapYear) then
					TimePeriod:=366*24*3600;
				else
					TimePeriod:=365*24*3600;
				end if;
				xi:=depthGround*sqrt(pi/(a*TimePeriod));
				TGround:=TAmbientAverage+GeoGradient*depthGround+(((TAmbientMax-TAmbientAverage)*exp(-xi)))*cos(2*pi*(DayOfYear*24*3600)/TimePeriod-PhaseDisplacement-xi);
			annotation(
				__iti_Impure=false,
				derivative=groundDot);
		end ground;
		function groundDot
			input Real depthGround;
			input Real DayOfYear;
			input Boolean LeapYear;
			input Real cGround;
			input Real lambdaGround;
			input Real rhoGround;
			input Real GeoGradient;
			input Real TAmbientAverage;
			input Real TAmbientMax;
			input Integer MaxMonth;
			input Real depthGroundDot;
			input Real DayOfYearDot;
			input Real cGroundDot;
			input Real lambdaGroundDot;
			input Real rhoGroundDot;
			input Real GeoGradientDot;
			input Real TAmbientAverageDot;
			input Real TAmbientMaxDot;
			output Real TGroundDot;
			protected
				Real a:=lambdaGround/(rhoGround*cGround);
				Real xi;
				Real TimePeriod;
				Real PhaseDisplacement:=2*pi*MaxMonth/12;
				Real aDot=0;
				Real xiDot=0;
				Real TimePeriodDot=0;
				Real PhaseDisplacementDot=0;
			algorithm
				if (LeapYear) then
					TimePeriod:=366*24*3600;
				else
					TimePeriod:=365*24*3600;
				end if;
				xi:=depthGround*sqrt(pi/(a*TimePeriod));
				
				TGroundDot:=(((TAmbientMax-TAmbientAverage)*exp(-xi)))*-(2*pi*24*3600*DayOfYearDot/TimePeriod)*sin(2*pi*(DayOfYear*24*3600)/TimePeriod-PhaseDisplacement-xi);
			annotation(Impure=false);
		end groundDot;
	public
		parameter Real qvSourceMax(
			quantity="Thermics.VolumeFlow",
			displayUnit="m³/h")=0.97222222222222221 "Maximum volume flow of SP" annotation(Dialog(
			group="Boundaries",
			tab="SP - Dimensions"));
		parameter Real qvSourceMin(
			quantity="Thermics.VolumeFlow",
			displayUnit="m³/h")=0 "Minimum volume flow of SP" annotation(Dialog(
			group="Boundaries",
			tab="SP - Dimensions"));
		parameter Real tHPStart(
			quantity="Basics.Time",
			displayUnit="s")=90 "Heat power switch-on time period" annotation(Dialog(
			group="Heating Power",
			tab="Dynamics"));
		parameter Real tCP(
			quantity="Basics.Time",
			displayUnit="s")=15 "Operation time delay of circulation pump" annotation(Dialog(
			group="Circulation Pump",
			tab="Dynamics"));
		parameter Real tSP(
			quantity="Basics.Time",
			displayUnit="s")=15 "Operation time delay of source pump" annotation(Dialog(
			group="Source Pump",
			tab="Dynamics"));
		GreenBuilding.Interfaces.Thermal.DefineVolumeFlow ToFlow annotation(Placement(transformation(extent={{200,30},{220,50}})));
		GreenBuilding.Interfaces.Thermal.ExtractVolumeFlow FromReturn annotation(Placement(transformation(extent={{219,-23},{199,-3}})));
	initial equation
			if HPon then	
				TFlow=ReturnHP.T;
			else
				TFlow=TAmbient;
			end if;	
				
			if SPon then
				qvSource=max(min(qvSourceRef,qvSourceMax),qvSourceMin);
			else
				qvSource=0;
			end if;
		
			if CPon then			
				FlowHP.qv=max(min((qvRef),qvMax),qvMin);			
			else
				FlowHP.qv=0;
			end if;
		
			EHeat=0;
			ECP=0;
			ECOMP=0;
			ESP=0;
			
			
			StartTime=time.start;
			
			
			if SourceAir then
				DeIcingEndTime=time.start;
			else
				DeIcingEndTime=0;
			end if;
			
			if HPon then
				QHeatInput=QHeatPump.y;
				PCOMP=-0.75*QHeatPump.y/(max(COPHeatPump.y,1));
			else
				QHeatInput=0;
				PCOMP=0;
			end if;
	equation
					if SourceAir then
						DeIcing=DEICINGon;
					else
						DeIcing=false;
					end if;
					
					if SourceAir then
						TSource=AmbientConditions.TAmbient;
					else
						TSource=ground(depthGround,AmbientConditions.DayOfYear,AmbientConditions.LeapYear,AmbientConditions.cGround,AmbientConditions.lambdaGround,AmbientConditions.rhoGround,AmbientConditions.GeoGradient,AmbientConditions.TAverageAmbientAnnual,AmbientConditions.TAmbientMax,AmbientConditions.MaxMonth);
					end if;
					
					when HPon then
						StartTime=time;
					end when;			
					
					if SourceAir then
						when not DeIcing then
							DeIcingEndTime=time;
						end when;
					else					
						DeIcingEndTime=0;						
					end if;
				
						
				
					QHeatPump.u1=max(min((TSource),TSourceMax),TSourceMin);
					QHeatPump.u2=max(min((TFlow),TFlowMax),TFlowMin);
					COPHeatPump.u1=max(min((TSource),TSourceMax),TSourceMin);
					COPHeatPump.u2=max(min((TFlow),TFlowMax),TFlowMin);
		
					if SourceAir then		
						when (HPon and not ((time-StartTime)<tHPStart) and (StartTime>time.start)) then
							reinit(QHeatInput,QHeatPump.y);
							reinit(PCOMP,-0.75*QHeatPump.y/(max(COPHeatPump.y,1)));
						elsewhen (HPon and not (time-DeIcingEndTime)<tHPStart and (StartTime<DeIcingEndTime)) then
							reinit(QHeatInput,QHeatPump.y);
						elsewhen DeIcing then	
							reinit(QHeatInput,0);
						elsewhen (not HPon) then
							reinit(QHeatInput,0);
							reinit(PCOMP,0);
						end when;
					else
						when (HPon and not ((time-StartTime)<tHPStart) and (StartTime>time.start)) then
							reinit(QHeatInput,QHeatPump.y);
							reinit(PCOMP,-0.75*QHeatPump.y/(max(COPHeatPump.y,1)));
						elsewhen (not HPon) then
							reinit(QHeatInput,0);
							reinit(PCOMP,0);
						end when;
					end if;
					
					if HPon then
						if (not DeIcing) then
							if (((time-StartTime)<tHPStart) and (StartTime>time.start) and (StartTime>DeIcingEndTime)) then
								tHPStart/3*der(QHeatInput)+QHeatInput=QHeatPump.y;	
							elseif ((time-DeIcingEndTime)<tHPStart) then
								tHPStart/3*der(QHeatInput)+QHeatInput=QHeatPump.y;	
							else
								der(QHeatInput)=der(QHeatPump.y);
							end if;
						else
							der(QHeatInput)=0;
						end if;
						
						if (((time-StartTime)<tHPStart) and (StartTime>time.start)) then
							tHPStart/3*der(PCOMP)+PCOMP=-0.75*QHeatPump.y/(max(COPHeatPump.y,1));
						else
							der(PCOMP)=-der(0.75*QHeatPump.y)/(max(COPHeatPump.y,1));
						end if;
					else
						der(QHeatInput)=0;
						der(PCOMP)=0;
					end if;
					
				
									
					
					if SPon then
						tSP*der(qvSource)+qvSource=max(min(qvSourceRef,qvSourceMax),qvSourceMin);
						PelSP.u[1]=qvSource;
						PSP=-PelSP.y[1];
					else
						tSP*der(qvSource)+qvSource=0;
						PelSP.u[1]=0;
						PSP=0;
					end if;
					
					TReturn=FromReturn.TMedium;
					qv=FromReturn.qvMedium;
					if (CPon) then	
						tCP*der(ToFlow.qvMedium)+ToFlow.qvMedium=max(min((qvRef),qvMax),qvMin);
						PelCP.u[1]=qv;
						PCP=-PelCP.y[1];
					else
						tCP*der(ToFlow.qvMedium)+ToFlow.qvMedium=0;
						PelCP.u[1]=0;
						PCP=0;
					end if;
					cpMed*rhoMed*VHP*der(TFlow)=-QlossRate*(TFlow-TAmbient)+QHeatInput-cpMed*rhoMed*qv*(TFlow-TReturn);
					ToFlow.TMedium=TFlow;	
					
					
					
					
						if (SPGridConnection.V>1e-10) then
							SPGridConnection.I=PSP/SPGridConnection.V;
							
						else
							SPGridConnection.I=0;
							
						end if;
					
					
					
					
					
						if (COMPGridConnection.V>1e-10) then
							COMPGridConnection.I=PCOMP/COMPGridConnection.V;
							
						else
							COMPGridConnection.I=0;
							
						end if;
					
					
					
					
					
					
						if (CPGridConnection.V>1e-10) then
							CPGridConnection.I=PCP/CPGridConnection.V;
							
						else
							CPGridConnection.I=0;
							
						end if;
				
					
					
					QHeat=cpMed*rhoMed*qv*(TFlow-TReturn);
					COP=COPHeatPump.y;
					
					der(EHeat)=QHeat;
					der(ECOMP)=PCOMP;
					der(ECP)=PCP;
					der(ESP)=PSP;
					
				
				connect(CPGrid,CPGridConnection.FlowCurrent) annotation(Line(points={{165,-140},{170,-140},{240,-140},{240,-85},{240,-80}}));
		
			
				
				
				
				connect(SPGrid,SPGridConnection.FlowCurrent) annotation(Line(points={{95,-140},{90,-140},{90,-112.7},{95,-112.7},{95,-85},{95,
		-80}}));
		
				
				
				connect(COMPGrid,COMPGridConnection.FlowCurrent) annotation(Line(points={{-125,-140},{-130,-140},{-130,-113},{-125,-113},{-125,-85},{-125,
			-80}}));
		
			
			connect(ToFlow.Pipe,FlowHP) annotation(Line(
				points={{220,40},{225,40},{245,40},{250,40}},
				color={190,30,45}));
			
			connect(FromReturn.Pipe,ReturnHP) annotation(Line(
				points={{219,-13},{224,-13},{245,-13},{245,-15},{250,-15}},
				color={190,30,45},
				thickness=0.0625));
	annotation(
		solutionState=32,
		simQueue(
			t=0,
			t0=0,
			dtMin=1e-012,
			dtMax=10000000000000,
			dtSolverMin=10000,
			event[0](
				eventTime=1000000000000,
				data="0:4")),
		viewinfo[0](
			viewSettings(clrRaster=12632256),
			typename="ModelInfo"),
		Icon(
			coordinateSystem(extent={{-200,-200},{200,200}}),
			graphics={
				Bitmap(
					imageSource="iVBORw0KGgoAAAANSUhEUgAAAG4AAABuCAYAAADGWyb7AAAAAXNSR0IArs4c6QAAAARnQU1BAACx
jwv8YQUAAAAZdEVYdFNvZnR3YXJlAEFkb2JlIEltYWdlUmVhZHlxyWU8AAAJUklEQVR4Xu2dW4hV
VRjHfQmLCoQuGgUNSVmUNSRZT+GDYA89DAQV9KIPBvWS9eiT3SC6TRcfJCHpQmhBYiSmQUNKVwgL
iqCiMacyU9ExkSmR3f7vWfvM+r7zffuss/ba58x4vh/88cycb6+19vqfddtn1nKeYRiGEcNwrrFc
mWlWCF7Ak0oQIF1s6r8qzbOWNnsFb1SkC0yzRypScLZ69epsbGwsGx8fz4xmQN2ijlHXkgdOKm3B
27dvd0kbvQJ1LnmRS4UEwn2jPygtT4UEouka/QF1z/3IpUICjx8/7pIxeg3GPO5HLhUSaPQX7kcu
FRJo9BfuRy4VEtg06A5GR0ezDRs2RGvLli1ddekp8oSQRtPLI+5HLhUS2CTr1q0jedXRggULgpYt
MBmxUhoxQlpIsymEPFVIYFN0WGRGq8o8ZZaWRPv373e5pEXIS4UENkGTFTg0NORyaQfvSdek0MjI
iMslLUJeKiSwCXCTPB9oeHg4W7FiRbC0Lk/qurQnEVK6nSSlAzWxdBLyUSGBqcHN8TzQEmIW+khL
6nKlTz+PQ56xEwst3yYeDfI8cqmQwNRI3WSdmRkqkbc8/Mzh3WSKCQVPEzPN1PjpO6mQwNTg5vz0
8cmtizQ75fD3U3Rr/F4GyrgUN4vW46cJ+bM8qZWngI+bGP9S46fvpEICU3H2xGR26q1t2Y6Vd2eP
nndxS/gZv8f7sUjG+GNmE8b9/Nfp7J0932arHni0pQfXv5R9/tOJbOLYlIuqDy93LhUSmIKTr76W
/b5oSXbwgitU4f3TH+xyV3RHL42DKZs/+SN7YedvlUIMzK0LL3cuFRJYl2NrHxGN0oTW1y2SMZ26
ypgxDkZIJlXp78l/3dVx8HLnUiGBdZh86nliysT5C7OJ+Ze3K/99GYOWd+bAQZdCNRjbMK5IC2t/
3YX1IX+/XDOGPvGY+u9stnHPhGhOlT767qhLIQ5e7lwqJDAWjFl+9yga5sszD600BD7RiZHfpVaB
sUsyppNgdh2EMquQwFgwrrVM01oa08ELFrWuCaGXxr2575BoTIgmT59xqXSPUGYVElhWZB1JJony
Wt3U3s9d0XV6aZxkSC8klFmFBPoGROn8RbJJksy4NgllViGBMybkBsCErhXWTRYy49oklFmFBJYV
WZggVXZKmXFtEsqsQgLLipwWJg/da2J+YKsz49oklFmFBFLj4hTcXZpxbRLKrEICsYiOkf/ExIyL
l1BmFRIYCyrejJsWFu+xCGVWIYGxmHEzMuMYZhyFBMZixs3IjGOYcRQSGIsZNyMzjmHGUUhgLGbc
jMw4hhlHIYGxmHEzMuMYZhyFBMZixs3IjGOYcRQSGEuUcbnMOIpQZhUSGIsZNyMzjmHGUUhgLL0w
LsU+cpycEIJkSKjMOA/JNGxoxO+x/cnfLInX+J1mdIh5kiGhMuMc3AAYhm4zZCMHYqSNkLi+CsmQ
UJlxOXxcw+aNmKMqMLbxLchV24slQ0I18Mahsv2ywbQ6W4JhuG8eXmv70SVDQjXwxvnbpaoquRv4
hwHdsIRkSKgG2ji+3zp0NhgCH/OkD4RkSKgG2jj/UBtsZEwJulu/y4SRHMmQUA20cX6ZUra2En+m
Kn0wJENCNbDG8XEoxdjG4V0xn/TU2djYF+MOr7onSoduX5nMOLQwv0xNgA+Dnwd/FPbul4dFU0KE
feA4rSFGfpmcVEhgWZF1VNc4f+2GDfdN4d93SuPqyC+TkwoJ9A2QtlCFKHibVS4zjsovk5MKCSwr
sicbG3N1Mg6zv6bw79uM61KScfysrjpPSzT4BOgc6yrjFDzG5XHlNb5xvFJTHFnI4YtwzoAaF9ha
FeOAv0BuYpzzTyfCozXOnDNO2m0aqj+vXz5tRALj+Fc5vCurA++KpQV+HeNwIBvWcjHyy+WkQgLr
cOTeNS0jRKOYpmeh0+d5cXh3WfebgRL+uAuS0v1m/KRoSohgQCx+uZxUSGAdcBJey7gO4xxaZRmL
1iqBLtIvm/YkPxQY5H/jAEnPKQEOYQs57pALZ3nh2lj8sjmpkMA68IPYCqHb9OQbBuGJi3boKJ5u
8NYRa55kGsa5qlaMJxmSOVWqe2alXz4nFRJYF7S6NvMUVZlWwscjCAZ08y04ul3pqMSQNL6fOBV0
/CFi5vRBowDnT+I0PTzD3L1wcfbu/Eta+mrJsmIs7OaAUf7nC6XQ+vCwWAItCabz7rZUN0sMnIaH
54/Pbv0qe/iZbS2t37S7mMRgPKzTPfoIZVUhganhFQcTYpBani+0QuQF8S7RF7pezexO8A8Q8kqN
n76TCglMDU8/1jigdXmhQkXH/KFRiRlXE7S+bgxEC+yma9QYKON4BacwrgStB+mhAiF0g8gPr/Gn
D1hY12lhnIEyDjfnp5/SuF7DjWvif7Ty03dSIYGpOZeNa+Je/PSdVEhgavhT+LlsHL+X2NlpFX76
TiokMDV8Go8xqC5Yo2ENh9YcInxYqp6QhIDr+XhdN00JP30nFRKYGtwczwOVCUMxvY9R1TpNE8Yj
Ka0QoWXxPJsY34Cfh5MKCWwC/hXNuSAY2gRCXioksAn4n8LNddX9lqIKIT8VEtgUnR5ZzRWhm29i
bCsR8lQhgU2CsaKbJx6zSVjc92JGLOStQgJ7AR/8u1WM+WgpUlqh6hVC2VVI4FwAYyZmdeV0v5Mw
JjXZvaWE+5FLhQQa/YX7kUuFBBrpOfLPD9nvJ75wP1XD/cilQgKNtHx9YDTb+OnVbdr+3X3Zvl8e
L0z14X7kUiGBRlp+PbpbNK7U+l2LCxNLA7kfuVRIoJEeybBSSzcPZw/tuK54DZO5H7lUSKCRnp3f
r82e+2Qou/ONpdnI1htbRkFr3r8+W/76LcXrzZ8tJV44qZBAIz0//vUeMeqqjcsKwcDHPry2aHXl
+9yPXCok0EjP1JnJ7JW9NxemrXr7puzaTbcW/1744vLCNLyubVwTG+WN6dnl/e/dUHSVT358TWES
JiaXvnxb8Xv8/MS2K4kXTioksJePdwYJtDqMYWXLKgXzyq7ykZcXEi+cVEhgk19ZDDramq7sKu+4
6yLihZNKW3ATf0thTIM1GzcOXeeDT1/W5oOTyFAuKbhoeeg2bcxLC7rM0jyMaegelZZWSkUKNs0e
qYzlki4w9V/wRmU4l3SRqf+CN5UgwFre7BG86GiaYRiGwZg3739hN7cEC0hRaQAAAABJRU5ErkJg
gg==",
					extent={{-197,200},{210,-210}})}),
		Documentation(info="MIME-Version: 1.0
Content-Type: multipart/related;boundary=\"--$iti$\";type=\"text/html\"

----$iti$
Content-Type:text/html;charset=\"iso-8859-1\"
Content-Transfer-Encoding: quoted-printable
Content-Location: C:\\Users\\Stefan.Mohr\\AppData\\Local\\Temp\\iti4322.tmp\\hlp87F4.tmp\\HeatPump.htm

<=21DOCTYPE HTML PUBLIC =22-//W3C//DTD HTML 4.0 Transitional//EN=22>
<HTML><HEAD><TITLE>Heat pump system V1.0</TITLE>
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
<META name=3DGENERATOR content=3D=22MSHTML 9.00.8112.16447=22></HEAD>
<BODY bgColor=3D=23ffffff vLink=3D=23800080 link=3D=230000ff>
<P style=3D=22MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px=22 class=3DUeberschrift1>H=
eat pump 
system V1.0</P>
<HR style=3D=22MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px=22 SIZE=3D1 noShade>

<TABLE border=3D1 cellSpacing=3D0 borderColor=3D=23ffffff borderColorLight=
=3D=23ffffff 
borderColorDark=3D=23ffffff cellPadding=3D2 width=3D=22100%=22 bgColor=3D=23=
cccccc>
  <TBODY>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>Symbol:</P></TD>
    <TD bgColor=3D=23ffffff vAlign=3Dtop colSpan=3D3><IMG src=3D=22HeatPump=
=5Csymbol.png=22 
      width=3D124 height=3D124></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>Ident:</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop colSpan=3D3>
      <P class=3DSymbolTab>GreenBuilding.HeatPump.HeatPump</P></TD></TR>
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
      <P class=3DSymbolTab>Reference volume flow of circulation pump</P></TD=
>
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
      <P class=3DSymbolTab>1-phase connection of circulation pump to Grid</P=
></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>CPGrid1</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>1-phase connection of source pump to Grid</P></TD=
>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>SPGrid1</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>1-phase connection of compressor to Grid</P></TD>=

    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>COMPGrid1</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Return pipe</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>ReturnHP</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>flow pipe</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>FlowHP</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Ambient Connection Connection</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>AmbientConditions</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Switch on/off of HP</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>HPon</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Switch on/off of circulation pump</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>CPon</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>I/O-switch for source pump</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>SPon</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Switch on/off de-icing process for air heat 
pumps</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>DEICINGon</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Actual COP of heat pump</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>COP</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>Parameters:</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>If true, auxiliary heater is installed</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>AuxHeat</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Phase number auxiliary heating system is connecte=
d 
      to</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>AUXPhase</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Phase number circulation pump is connected to</P>=
</TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>CPPhase</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
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
      <P class=3DSymbolTab>Phase number of source pump grid connection 
      (ventilator, brine pump)</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>SourcePhase</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Phase number of HP-compressor</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>CompPhase</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Specific heat capacity of heating medium</P></TD>=

    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>cpMed</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Density of heating medium</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>rhoMed</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Heating medium volume of HP</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>VHP</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Ambient temperature</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>TAmbient</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Heat loss rate of HP-isolation</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>QlossRate</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>File name for heat pump characteristics</P></TD>=

    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>HPFile</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Table name for source and flow temperature depend=
ing 
      heat power output</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>QHeatTablep</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Table name for source and flow temperature depend=
ing 
      COP of HP</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>COPTable</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Power factor of compressor</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>CosPhiCOMP</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Heat power of auxiliary heating system</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>AuxHeatPower</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Minimum source temperature for heat pump</P></TD>=

    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>TSourceMin</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Maximum source temperature for heat pump</P></TD>=

    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>TSourceMax</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Minimum flow temperature for heat pump</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>TFlowMin</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Maximum flow temperature for heat pump</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>TFlowMax</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Average depth of ground environmental heat is tak=
en 
      of</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>depthGround</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Table name for CP-power behavior</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>CPTable</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Power factor of circulation pump</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>CosPhiCP</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Maximum volume flow of CP</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>qvMax</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Minimum volume flow of CP</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>qvMin</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Table name for volume flow depending power demand=
 of 
      source pump</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>SPTable</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Power factor of source pump</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>CosPhiSP</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Maximum volume flow of SP</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>qvSourceMax</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Minimum volume flow of SP</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>qvSourceMin</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Heat power switch-on time period</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>tHPStart</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Operation time delay of circulation pump</P></TD>=

    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>tCP</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Operation time delay for auxiliary heating 
system</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>tAUX</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Operation time delay of source pump</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>tSP</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>Results:</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Actual COP of heat pump</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>COP</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Actual auxiliary heat power</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>QHeatAux</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Heat output power of HP</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>QHeat</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Effective power of source pump</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>PSP</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Effective power of circulation pump</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>PCP</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Effective power of compressor</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>PCOMP</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Effective electrical power of auxiliary heating s=
ystem 
      (cos phi =3D 1)</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>PAUX</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Heat output of heat pump</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>EHeat</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Electrical energy demand of compressor</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>ECOMP</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Electrical energy demand of circulation pump</P><=
/TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>ECP</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Electrical energy demand of source pump</P></TD>=

    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>ESP</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR>
  <TR>
    <TD bgColor=3D=2395c9f0 vAlign=3Dtop width=3D=2215%=22>
      <P>&nbsp;</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>Electrical energy demand of auxiliary heating 
    system</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop>
      <P class=3DSymbolTab>EAUX</P></TD>
    <TD bgColor=3D=23efefef vAlign=3Dtop width=3D=2235%=22>
      <P>&nbsp;</P></TD></TR></TBODY></TABLE>
<P class=3DUeberschrift2>Description:</P>
<P style=3D=22MARGIN-TOP: 6pt; MARGIN-BOTTOM: 0px=22>Heat pumps are devices =
that 
transfer thermal energy from a source to a sink that is at a higher temperat=
ure 
than the source. To provide usable energy (heat) they use electrical energy =

which is converted into mechanical work for example by compressors. As heat =

source mostly environmental energy is used (e.g. ambient air, groundwater, w=
ell 
water, ground). They have to be controlled using external controllers regard=
ing 
heat power output and system efficiency. </P>
<P style=3D=22MARGIN-TOP: 6pt; MARGIN-BOTTOM: 0px=22>At first the system con=
figuration 
has to be defined in the parameter dialogue. So, it has to be characterized,=
 if 
the modeled heat pump should use ambient air as environmental heat source or=
 
not. Air heat pumps needs to be de-iced during heating process to completely=
 
ensure their functionality. In this process these devices are switched-off =

during heating and the operation mode is turned for a short time period. 
Enabling ambient air as heat source needs to focus on the maximum and minimu=
m 
source pump volume flow. Because the source pump of an air heat pump is a 
ventilator (instead of a circulation pump) its maximum volume flow is much =

higher than a normal electrical pump at least (more than 1000 m3/h comparing=
 to 
less than 10 m3/h). Make sure that these source pump parameters are defined =

correctly to avoid wrong system operation. To parameterize these values rega=
rd 
heat pump source file in model data directory. </P>
<P style=3D=22MARGIN-TOP: 6pt; MARGIN-BOTTOM: 0px=22>Besides the operation p=
arameter 
of the source pump the 'SourceAir'-parameter concerns also another parameter=
. 
So, if ground water, well water or even the ground itself should be used as =

environmental heat source it has to be defined in which depth of ground the =

energy is taken from. This depth of ground has to be defined in the 'HP powe=
r 
data' paramerer dialogue. An internal ground model then calculates heat sour=
ce 
temperature depending on depth of ground and season. If flat collectors or =

ground water in a specific depth should be used, insert this value. In case =
of 
modeling soil sensors, use an average ground depth as input parameter.</P>
<P style=3D=22MARGIN-TOP: 6pt; MARGIN-BOTTOM: 0px=22>Because heat pump syste=
ms are 
much more complex than other heating systems like condensing boilers or CHPs=
 the 
modeled system complexity had to be reduced due to simulation time reduction=
. 
Heat power output highly depends on inner system states and working medium =

characteristics. To reduce model complexity inner system processes were 
neglected completely. Instead of simulating inner process heat power output =
is 
calculated using measurement data of heat pump system manufactorers. These d=
ata 
are mostly available for every heat pump system. So the heat power output an=
d 
coefficient of performance (COP) of heat pump system is characterized depend=
ing 
heating system flow temperature and heat source temperature (air, ground wat=
er, 
ground). Exemplary data for a choice of heat pump systems is given in model =
data 
directory. If further systems should be simulated, please use these data fil=
es 
as design pattern. Please note that minimum and maximum temperatures used to=
 
define heat pump data have to be characterized in HP data parameter dialogue=
, 
too. Because of this approach source pump does not really interact with the =
heat 
pump system. But they partly have a non-neglectable electrical power demand,=
 so 
they are modeled as additional electrical energy consumers.</P>
<P style=3D=22MARGIN-TOP: 6pt; MARGIN-BOTTOM: 0px=22>Secondly, it has to be =
determined 
if an auxiliary, internal, electric heating system should be modeled. That w=
ay, 
heat power output can be increased when heat demand exceeds maximum heat pow=
er 
output of heat pump. Therefore, electrically produced heat power output has =
to 
be configured at HP data parameter dialogue.</P>
<P style=3D=22MARGIN-TOP: 6pt; MARGIN-BOTTOM: 0px=22>At last the numbers of =
phases 
have to be defined each electric system (circulation pump, auxiliary heating=
 
system, compressor, source pump) in the heat pump is connected to. This is =

important to assess, if these devices cause unsymmetric electrical loads in =
the 
grid or not.</P>
<P style=3D=22MARGIN-TOP: 6pt; MARGIN-BOTTOM: 0px=22>After this model config=
uration 
all connectors to be defined for the simulation are available to be connecte=
d to 
grid, HP controller and heating system. Make sure that all connectors are 
characterized to avoid numerical difficulties.</P>
<P style=3D=22MARGIN-TOP: 6pt; MARGIN-BOTTOM: 0px=22>Afterwards heating medi=
um and 
ambience properties as well as the power data file for circulation pump 
characterization have to be determined. Finally, user is given the possibili=
ty 
to vary internal dynamics of the heat pump model regarding heat production a=
nd 
internal systems operation. If there are no validated dynamics data for a 
special heat pump available, please use pre-defined ones.</P></BODY></HTML>=



----$iti$
Content-Type: image/png
Content-Transfer-Encoding: base64
Content-Location: HeatPump\\symbol.png

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

----$iti$--"),
		experiment(
			StopTime=0.999999999999994,
			StartTime=0,
			Interval=0.00199999999999999,
			MaxInterval="10",
			AbsTolerance="1e-06"));
end HeatPumpDC1;
