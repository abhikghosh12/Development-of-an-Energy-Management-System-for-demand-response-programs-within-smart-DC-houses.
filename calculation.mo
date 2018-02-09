// CP: 65001
// SimulationX Version: 3.7.2.40674 x64
within ;
model calculation "calculation.mo"
	input Modelica.Blocks.Interfaces.RealInput HEATGRID(
		quantity="Basics.Power",
		displayUnit="kW") " power for heating of house" annotation(
		Placement(
			transformation(
				origin={60,55},
				extent={{-20,-20},{20,20}},
				rotation=-90),
			iconTransformation(
				origin={-100,50},
				extent={{-20,-20},{20,20}},
				rotation=-90)),
		Dialog(
			group="Electrical Power",
			tab="Results",
			showAs=ShowAs.Result));
	input Modelica.Blocks.Interfaces.RealInput housegrid(
		quantity="Basics.Power",
		displayUnit="kW") " power for appliances in  house" annotation(
		Placement(
			transformation(
				origin={60,55},
				extent={{-20,-20},{20,20}},
				rotation=-90),
			iconTransformation(
				origin={100,50},
				extent={{-20,-20},{20,20}},
				rotation=-90)),
		Dialog(
			group="Electrical Power",
			tab="Results",
			showAs=ShowAs.Result));
	input Modelica.Blocks.Interfaces.RealInput househeatgrid(
		quantity="Basics.Power",
		displayUnit="kW") " power for appliances and heatpumpin  house" annotation(
		Placement(
			transformation(
				origin={60,55},
				extent={{-20,-20},{20,20}},
				rotation=-90),
			iconTransformation(
				origin={-50,100},
				extent={{-20,-20},{20,20}},
				rotation=-90)),
		Dialog(
			group="Electrical Power",
			tab="Results",
			showAs=ShowAs.Result));
	input Modelica.Blocks.Interfaces.RealInput totalload_DC(
		quantity="Basics.Power",
		displayUnit="kW") " power for appliances and heatpumpin  house" annotation(
		Placement(
			transformation(
				origin={60,55},
				extent={{-20,-20},{20,20}},
				rotation=-90),
			iconTransformation(
				origin={100,-50},
				extent={{-20,-20},{20,20}},
				rotation=-90)),
		Dialog(
			group="Electrical Power",
			tab="Results",
			showAs=ShowAs.Result));
	input Modelica.Blocks.Interfaces.RealInput totalload_AC(
		quantity="Basics.Power",
		displayUnit="kW") " power for appliances and heatpumpin  house" annotation(
		Placement(
			transformation(
				origin={60,55},
				extent={{-20,-20},{20,20}},
				rotation=-90),
			iconTransformation(
				origin={50,100},
				extent={{-20,-20},{20,20}},
				rotation=-90)),
		Dialog(
			group="Electrical Power",
			tab="Results",
			showAs=ShowAs.Result));
	input Modelica.Blocks.Interfaces.RealInput PowerConsumptionAC(quantity="Basics.PERCENTAGE") " Power Consumption for house" annotation(
		Placement(
			transformation(
				origin={60,55},
				extent={{-20,-20},{20,20}},
				rotation=-90),
			iconTransformation(
				origin={0,100},
				extent={{-20,-20},{20,20}},
				rotation=-90)),
		Dialog(
			group="Electrical Power",
			tab="Results",
			showAs=ShowAs.Result));
	input Modelica.Blocks.Interfaces.RealInput PowerConsumptionDC(quantity="Basics.PERCENTAGE") " Power Consumption for house" annotation(
		Placement(
			transformation(
				origin={60,55},
				extent={{-20,-20},{20,20}},
				rotation=-90),
			iconTransformation(
				origin={-100,0},
				extent={{-20,-20},{20,20}},
				rotation=-90)),
		Dialog(
			group="Electrical Power",
			tab="Results",
			showAs=ShowAs.Result));
	input Modelica.Blocks.Interfaces.RealInput gridConsumptionAC(
		quantity="Basics.Power",
		displayUnit="kW") " power for consumptionof house" annotation(
		Placement(
			transformation(
				origin={60,55},
				extent={{-20,-20},{20,20}},
				rotation=-90),
			iconTransformation(
				origin={100,0},
				extent={{-20,-20},{20,20}},
				rotation=-90)),
		Dialog(
			group="Electrical Power",
			tab="Results",
			showAs=ShowAs.Result));
	input Modelica.Blocks.Interfaces.RealInput gridConsumptionDC(
		quantity="Basics.Power",
		displayUnit="kW") " power for consumptionof house" annotation(
		Placement(
			transformation(
				origin={60,55},
				extent={{-20,-20},{20,20}},
				rotation=-90),
			iconTransformation(
				origin={50,-100},
				extent={{-20,-20},{20,20}},
				rotation=-90)),
		Dialog(
			group="Electrical Power",
			tab="Results",
			showAs=ShowAs.Result));
	input Modelica.Blocks.Interfaces.RealInput summation(
		quantity="Basics.Power",
		displayUnit="kW") " power for consumptionof house" annotation(
		Placement(
			transformation(
				origin={60,55},
				extent={{-20,-20},{20,20}},
				rotation=-90),
			iconTransformation(
				origin={-50,-100},
				extent={{-20,-20},{20,20}},
				rotation=-90)),
		Dialog(
			group="Electrical Power",
			tab="Results",
			showAs=ShowAs.Result));
	Real selfconsumptionDC(quantity="Basics.Percentage") "Self Consumption of PV Array" annotation(Dialog(
		group="Power",
		tab="Results",
		showAs=ShowAs.Result));
	Real GridfeedingDC(
		quantity="Basics.Power",
		displayUnit="kW") "power send to the grid" annotation(Dialog(
		group="Power",
		tab="Results",
		showAs=ShowAs.Result));
	Real selfconsumptionAC(quantity="Basics.Percentage") "Self Consumption of PV Array" annotation(Dialog(
		group="Power",
		tab="Results",
		showAs=ShowAs.Result));
	Real GridfeedingAC(
		quantity="Basics.Power",
		displayUnit="kW") "power send to the grid" annotation(Dialog(
		group="Power",
		tab="Results",
		showAs=ShowAs.Result));
	Real summ(
		quantity="Basics.Power",
		displayUnit="kW") "power send to the grid" annotation(Dialog(
		group="Power",
		tab="Results",
		showAs=ShowAs.Result));
	Real ECP_DC(
		quantity="Basics.Energy",
		displayUnit="kWh") "Electrical energy " annotation(Dialog(
		group="Energy",
		tab="Results",
		showAs=ShowAs.Result));
	Real ECP_AC(
		quantity="Basics.Energy",
		displayUnit="kWh") "Electrical energy " annotation(Dialog(
		group="Energy",
		tab="Results",
		showAs=ShowAs.Result));
	Real energyload_AC(
		quantity="Basics.Energy",
		displayUnit="kWh") "Electrical energy " annotation(Dialog(
		group="Energy",
		tab="Results",
		showAs=ShowAs.Result));
	Real energyload_DC(
		quantity="Basics.Energy",
		displayUnit="kWh") "Electrical energy " annotation(Dialog(
		group="Energy",
		tab="Results",
		showAs=ShowAs.Result));
	equation
		der(energyload_DC)=totalload_DC;
		der(energyload_AC)=totalload_AC;
			der(ECP_DC)=GridfeedingDC;
			der(ECP_AC)=GridfeedingAC;
				der(selfconsumptionDC) = PowerConsumptionDC;
				der(summ)=summation;
				der(GridfeedingDC)=gridConsumptionDC;
				der(selfconsumptionAC) = PowerConsumptionAC;
				der(GridfeedingAC)=gridConsumptionAC;
	annotation(
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		Line(
			points={{-35,-10},{-27,-10}},
			color={0,0,127}),
		viewinfo[0](
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
				viewSettings(
					relZoom=108,
					scrollPos(
						x=270,
						y=0)),
				runtimeClass="CSimView",
				tabGroup=0,
				tabFrame=0,
				tabAlignment=0,
				typename="ModelViewInfo"),
			simViewInfos[3](
				runtimeClass="CSimXModelicaView",
				tabGroup=0,
				tabFrame=0,
				tabAlignment=0,
				typename="ViewInfo"),
			typename="ModelInfo"),
		experiment(
			StopTime=86400,
			StartTime=0,
			Tolerance=1e-006,
			Interval=1,
			MaxInterval="10",
			AbsTolerance="1e-06"));
end calculation;
