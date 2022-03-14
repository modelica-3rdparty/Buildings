within Buildings.Fluid.Storage.Plant;
model ChillerAndTank
  "(Draft) Model of a plant with a chiller and a tank where the tank can potentially be charged remotely"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
    final m1_flow_nominal = m2_flow_nominal,
    final m2_flow_nominal = mChi_flow_nominal + mTan_flow_nominal);

  parameter Boolean allowRemoteCharging = true
    "Turns the plant to a prosumer";

  parameter Modelica.Units.SI.MassFlowRate mChi_flow_nominal=1
    "Nominal mass flow rate for the chiller branch";
  parameter Modelica.Units.SI.MassFlowRate mTan_flow_nominal=1
    "Nominal mass flow rate for the tank branch";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=
    p_CHWS_nominal-p_CHWR_nominal
    "Nominal pressure difference";
  parameter Modelica.Units.SI.AbsolutePressure p_CHWS_nominal=800000
    "Nominal pressure of the CHW supply line";
  parameter Modelica.Units.SI.AbsolutePressure p_CHWR_nominal=300000
    "Nominal pressure of the CHW return line";
  parameter Modelica.Units.SI.Temperature T_CHWS_nominal=7+273.15
    "Nominal temperature of CHW supply";
  parameter Modelica.Units.SI.Temperature T_CHWR_nominal=12+273.15
    "Nominal temperature of CHW return";

  replaceable parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic perChi(
    QEva_flow_nominal=-1E6,
    COP_nominal=3,
    PLRMax=1,
    PLRMinUnl=0.3,
    PLRMin=0.3,
    etaMotor=1,
    mEva_flow_nominal=mChi_flow_nominal,
    mCon_flow_nominal=mChi_flow_nominal*1.2,
    TEvaLvg_nominal=280.15,
    capFunT={1,0,0,0,0,0},
    EIRFunT={1,0,0,0,0,0},
    EIRFunPLR={1,0,0},
    TEvaLvgMin=276.15,
    TEvaLvgMax=288.15,
    TConEnt_nominal=310.15,
    TConEntMin=303.15,
    TConEntMax=333.15)
    "Chiller performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{-100,82},{-80,102}})));

  Buildings.Fluid.FixedResistances.PressureDrop preDro2(
    redeclare package Medium = Medium2,
    final allowFlowReversal=true,
    final dp_nominal=dp_nominal/10,
    final m_flow_nominal=mTan_flow_nominal) "Flow resistance on tank branch"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-80,-80})));
  Modelica.Blocks.Interfaces.RealInput set_mPum1_flow
    "Primary pump mass flow rate setpoint" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,130}),  iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,100})));

  Buildings.Fluid.Movers.FlowControlled_m_flow pum1(
    redeclare package Medium = Medium2,
    per(pressure(dp=dp_nominal*{2,1.2,0}, V_flow=mChi_flow_nominal/1.2*{0,1.2,2})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=true,
    addPowerToMedium=false,
    m_flow_nominal=mChi_flow_nominal,
    m_flow_start=0,
    T_start=T_CHWR_nominal) "Primary CHW pump"
    annotation (Placement(transformation(extent={{-10,-42},{-30,-22}})));

  Modelica.Blocks.Interfaces.RealOutput mTan_flow
    "Mass flow rate through the tank" annotation (Dialog(group=
          "Time varying output signal"), Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,-110}),   iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={110,-20})));
  Buildings.Fluid.Movers.SpeedControlled_y pum2(
    redeclare package Medium = Medium2,
    per(pressure(dp=dp_nominal*{2,1.2,0}, V_flow=(mChi_flow_nominal +
            mTan_flow_nominal)/1.2*{0,1.2,2})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=true,
    addPowerToMedium=false,
    y_start=0,
    T_start=T_CHWR_nominal) "Secondary pump" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={80,-20})));

  Buildings.Fluid.Storage.Plant.BaseClasses.ReversiblePumpValveControl conPum2Gro
    if allowRemoteCharging "Control block for secondary pump-valve group"
    annotation (Placement(transformation(extent={{80,80},{60,102}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput booOnOff
    if allowRemoteCharging "Plant status: true = on; false = off"
                                                   annotation (Placement(
        transformation(extent={{120,70},{100,90}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput booFloDir
    if allowRemoteCharging
    "Flow direction: true = normal; false = reverse" annotation (Placement(
        transformation(extent={{120,90},{100,110}}),   iconTransformation(
          extent={{-140,-40},{-100,0}})));
  Modelica.Blocks.Interfaces.RealInput set_mTan_flow if allowRemoteCharging
    "Tank mass flow rate setpoint" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,130}),   iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,20})));

  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val1(
    redeclare package Medium = Medium2,
    use_inputFilter=true,
    y_start=0,
    l=1E-5,
    dpValve_nominal=0.1*dp_nominal,
    m_flow_nominal=m2_flow_nominal)
    if allowRemoteCharging
    "Valve in series to the pump (normal direction)"
    annotation (Placement(transformation(extent={{30,-20},{10,0}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val2(
    redeclare package Medium = Medium2,
    use_inputFilter=true,
    y_start=0,
    l=1E-5,
    dpValve_nominal=0.1*dp_nominal,
    m_flow_nominal=mTan_flow_nominal) if allowRemoteCharging
    "Valve in parallel to the secondary pump (reverse direction)"
    annotation (Placement(transformation(extent={{10,-80},{30,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiFloDirPum1
    if allowRemoteCharging "Switches off pum1 when tank charged remotely"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,90})));
  Modelica.Blocks.Sources.Constant conZero(k=0) if allowRemoteCharging
    "Constant y = 0"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,90})));
  Buildings.Fluid.Storage.Plant.BaseClasses.FluidThrough pasVal1(redeclare
      package Medium = Medium2)
    if not allowRemoteCharging "Replaces val1 when remote charging not allowed"
    annotation (Placement(transformation(extent={{30,-42},{10,-22}})));
  Modelica.Blocks.Routing.RealPassThrough pasSwiFloDirPum1
    if not allowRemoteCharging
    "Replaces swiFloDirPum1 when remote charging not allowed" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={28,90})));
  Modelica.Blocks.Interfaces.RealInput yPum2 if not allowRemoteCharging
                                             "Secondary pump speed input"
    annotation (Placement(transformation(extent={{120,10},{100,30}}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-80,110})));
  Buildings.Fluid.Chillers.ElectricEIR chi(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    final dp1_nominal=0,
    final dp2_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    p2_start=p_CHWS_nominal,
    T2_start=T_CHWS_nominal,
    final per=perChi)
    "Water cooled chiller (ports indexed 1 are on condenser side)"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant onChi(k=true)
    if not allowRemoteCharging "Placeholder, chiller always on"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Modelica.Blocks.Sources.Constant set_TEvaLvg(k=T_CHWS_nominal)
    "Evaporator leaving temperature setpoint" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,10})));
  Buildings.Fluid.Storage.Stratified tan(
    redeclare package Medium = Medium2,
    final allowFlowReversal=true,
    hTan=3,
    dIns=0.3,
    VTan=10,
    nSeg=7,
    show_T=true,
    m_flow_nominal=mTan_flow_nominal,
    p_start=p_CHWS_nominal,
    T_start=T_CHWS_nominal,
    TFlu_start=linspace(
        T_CHWR_nominal,
        T_CHWS_nominal,
        tan.nSeg)) "Tank"
    annotation (Placement(transformation(extent={{-40,-80},{-60,-60}})));
  Modelica.Fluid.Sensors.MassFlowRate sen_m_flow(
    redeclare package Medium = Medium2,
    final allowFlowReversal=true) "Flow rate sensor"
    annotation (Placement(transformation(extent={{-10,-80},{-30,-60}})));
  Buildings.Fluid.FixedResistances.CheckValve cheValPum1(
    redeclare package Medium = Medium2,
    m_flow_nominal=mChi_flow_nominal,
    dpValve_nominal=0.1*dp_nominal,
    dpFixed_nominal=0.1*dp_nominal) "Check valve with series resistance"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-70,-30})));
  Buildings.Fluid.FixedResistances.CheckValve cheValPum2(
    redeclare package Medium = Medium2,
    m_flow_nominal=m2_flow_nominal,
    dpValve_nominal=0.1*dp_nominal,
    dpFixed_nominal=0.1*dp_nominal) "Check valve" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,-20})));
equation
  connect(conPum2Gro.yVal1, val1.y) annotation (Line(points={{66,78.9},{66,56},
          {20,56},{20,2}},         color={0,0,127}));
  connect(conPum2Gro.us_mTan_flow, set_mTan_flow) annotation (Line(points={{81,
          95.4},{90,95.4},{90,118},{80,118},{80,130}}, color={0,0,127}));
  connect(pum2.y, conPum2Gro.yPum2) annotation (Line(points={{80,-8},{80,20},{
          70,20},{70,78.9}}, color={0,0,127}));
  connect(swiFloDirPum1.u2, booFloDir) annotation (Line(points={{-10,102},{-10,112},
          {96,112},{96,100},{110,100}},   color={255,0,255}));
  connect(swiFloDirPum1.u1, set_mPum1_flow) annotation (Line(points={{-2,102},{-2,
          108},{40,108},{40,130}}, color={0,0,127}));
  connect(pum1.m_flow_in,swiFloDirPum1. y)
    annotation (Line(points={{-20,-20},{-20,72},{-10,72},{-10,78}},
                                                 color={0,0,127}));
  connect(conZero.y,swiFloDirPum1. u3) annotation (Line(points={{-50,101},{-50,108},
          {-18,108},{-18,102}},
                              color={0,0,127}));
  connect(pasSwiFloDirPum1.u, set_mPum1_flow) annotation (Line(points={{28,101},
          {28,108},{40,108},{40,130}},    color={0,0,127}));
  connect(pasSwiFloDirPum1.y, pum1.m_flow_in) annotation (Line(points={{28,79},
          {28,72},{-20,72},{-20,-20}}, color={0,0,127}));
  connect(pum2.y, yPum2)
    annotation (Line(points={{80,-8},{80,20},{110,20}},      color={0,0,127}));
  connect(pum2.port_a, port_a2)
    annotation (Line(points={{90,-20},{90,-60},{100,-60}}, color={0,127,255}));
  connect(val2.port_b, port_a2) annotation (Line(points={{30,-70},{90,-70},{90,
          -60},{100,-60}}, color={0,127,255}));
  connect(conPum2Gro.booOnOff, booOnOff) annotation (Line(points={{82,82.2},{82,
          82},{96,82},{96,80},{110,80}}, color={255,0,255}));
  connect(conPum2Gro.booFloDir, booFloDir) annotation (Line(points={{82,86.6},{
          82,86},{96,86},{96,100},{110,100}}, color={255,0,255}));
  connect(pum1.port_b, chi.port_a2) annotation (Line(points={{-30,-32},{-40,-32},
          {-40,4}},        color={0,127,255}));
  connect(chi.on, booFloDir) annotation (Line(points={{-62,13},{-62,12},{-72,12},
          {-72,112},{96,112},{96,100},{110,100}}, color={255,0,255}));
  connect(onChi.y, chi.on) annotation (Line(points={{-78,40},{-72,40},{-72,13},
          {-62,13}},color={255,0,255}));
  connect(set_TEvaLvg.y, chi.TSet) annotation (Line(points={{-79,10},{-79,7},{
          -62,7}},     color={0,0,127}));
  connect(chi.port_a1, port_a1) annotation (Line(points={{-60,16},{-64,16},{-64,
          60},{-100,60}}, color={0,127,255}));
  connect(chi.port_b1, port_b1) annotation (Line(points={{-40,16},{-32,16},{-32,
          60},{100,60}}, color={0,127,255}));
  connect(val1.y_actual, conPum2Gro.yVal1_actual) annotation (Line(points={{15,-3},
          {14,-3},{14,68},{46,68},{46,99.8},{59,99.8}},     color={0,0,127}));
  connect(sen_m_flow.m_flow, mTan_flow) annotation (Line(points={{-20,-59},{-20,
          -56},{0,-56},{0,-110}},     color={0,0,127}));
  connect(sen_m_flow.m_flow, conPum2Gro.um_mTan_flow) annotation (Line(points={{-20,-59},
          {-20,-56},{0,-56},{0,70},{44,70},{44,108},{88,108},{88,99.8},{81,99.8}},
                            color={0,0,127}));
  connect(preDro2.port_a, tan.port_b)
    annotation (Line(points={{-80,-90},{-80,-92},{-66,-92},{-66,-70},{-60,-70}},
                                                   color={0,127,255}));
  connect(sen_m_flow.port_b, tan.port_a)
    annotation (Line(points={{-30,-70},{-40,-70}},
                                                 color={0,127,255}));
  connect(port_b2, preDro2.port_b) annotation (Line(points={{-100,-60},{-80,-60},
          {-80,-70}}, color={0,127,255}));
  connect(chi.port_b2, cheValPum1.port_a)
    annotation (Line(points={{-60,4},{-70,4},{-70,-20}}, color={0,127,255}));
  connect(cheValPum1.port_b, port_b2) annotation (Line(points={{-70,-40},{-70,
          -60},{-100,-60}}, color={0,127,255}));
  connect(val2.port_a, pum1.port_a) annotation (Line(points={{10,-70},{4,-70},{
          4,-32},{-10,-32}}, color={0,127,255}));
  connect(sen_m_flow.port_a, pum1.port_a) annotation (Line(points={{-10,-70},{4,
          -70},{4,-32},{-10,-32}}, color={0,127,255}));
  connect(pasVal1.port_b, pum1.port_a)
    annotation (Line(points={{10,-32},{-10,-32}}, color={0,127,255}));
  connect(val1.port_b, pum1.port_a) annotation (Line(points={{10,-10},{4,-10},{
          4,-32},{-10,-32}}, color={0,127,255}));
  connect(pum2.port_b, cheValPum2.port_a)
    annotation (Line(points={{70,-20},{60,-20}}, color={0,127,255}));
  connect(pasVal1.port_a, cheValPum2.port_b) annotation (Line(points={{30,-32},
          {34,-32},{34,-20},{40,-20}}, color={0,127,255}));
  connect(val1.port_a, cheValPum2.port_b) annotation (Line(points={{30,-10},{34,
          -10},{34,-20},{40,-20}}, color={0,127,255}));
  connect(conPum2Gro.yVal2, val2.y) annotation (Line(points={{62,78.9},{62,4},{
          94,4},{94,-44},{20,-44},{20,-58}}, color={0,0,127}));
  connect(conPum2Gro.yVal2_actual, val2.y_actual) annotation (Line(points={{59,
          95.4},{54,95.4},{54,96},{48,96},{48,6},{96,6},{96,-46},{60,-46},{60,
          -63},{25,-63}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),       graphics={Line(
          points={{-30,-110},{30,-110}},
          color={28,108,200},
          pattern=LinePattern.Dash,
          visible=allowRemoteCharging), Polygon(
          points={{30,-110},{10,-104},{10,-116},{30,-110}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=allowRemoteCharging),
        Line(points={{-60,0},{-60,-60},{0,-60},{0,-20},{60,-20},{60,0}},
                                                                       color={0,
              0,0}),
        Line(points={{-100,0},{-60,0},{-60,60},{60,60},{60,0},{100,0}},
                                                                  color={0,0,0}),
        Ellipse(
          extent={{-22,80},{22,38}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,-8},{20,-70}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-30,-90},{30,-90}},color={28,108,200}),
        Polygon(
          points={{-30,-90},{-10,-84},{-10,-96},{-30,-90}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(points={{16,74},{-20,66}},color={0,0,0}),
        Line(points={{-20,54},{14,44}},color={0,0,0})}),         Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,120}})),
    Documentation(info="<html>
<p>
This plant model has a chiller and a stratified tank.
By setting <code>allowRemoteCharging = false</code>,
this model is effectively replacing a common pipe with a tank.
By setting <code>allowRemoteCharging = true</code>,
the tank can be charged by the CHW network instead of its own chiller.
</p>
<p>
When remote charging is enabled, the plant's operation mode is determined by
two boolean inputs:
</p>
<ul>
<li>
<code>booFloDir</code> determines the direction flow direction of the plant.
It has reverse flow when and only when the tank is being charged remotely.
</li>
<li>
<code>booOnOff</code> determines whether the plant outputs CHW to the network.
When it is off, the plant still allows the tank to be charged remotely
(if the flow direction is set to reverse at the same time).
</li>
</ul>
<p>
When remote charging is allowed, the secondary pump and two conditionally-enabled
control valves are controlled by
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.BaseClasses.ReversiblePumpValveControl\">
Buildings.Fluid.Storage.Plant.BaseClasses.ReversiblePumpValveControl</a> as such:
</p>
<ul>
<li>
The pump is controlled to track a flow rate setpoint of the tank
(can be both positive [discharging] or negative [charging])
under the following conditions:
<ul>
<li>
The plant is on, AND
</li>
<li>
the flow direction is \"normal\" (<code>= true</code>), AND
</li>
<li>
<code>val2</code> (in parallel to the pump) is at most 5% open.
</li>
</ul>
Otherwise the pump is off.
</li>
<li>
The valve in series with the pump (<code>val1</code>) is controlled to open fully
under the same conditions that allow the pump to be on.
Otherwise the valve is closed.
</li>
<li>
The valve in parallel with the pump (<code>val2</code>) is controlled
to track a negative flow rate setpoint of the tank (charging)
under the following conditions:
<ul>
<li>
The flow direction is \"reverse\" (<code>= false</code>), AND
</li>
<li>
<code>val1</code> (in series to the pump) is at most 5% open.
</li>
</ul>
Otherwise the valve is closed.
Not that it is NOT closed when the plant is \"off\".
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
February 18, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end ChillerAndTank;