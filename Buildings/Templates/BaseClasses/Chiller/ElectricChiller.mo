within Buildings.Templates.BaseClasses.Chiller;
model ElectricChiller
  extends Buildings.Templates.Interfaces.Chiller(
    final typ=Buildings.Templates.Types.Chiller.ElectricChiller);
              Fluid.Chillers.ElectricEIR chi(
    final per=per,
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    final allowFlowReversal1=allowFlowReversal1,
    final allowFlowReversal2=allowFlowReversal2,
    final show_T=show_T,
    final from_dp1=from_dp1,
    final dp1_nominal=0,
    final linearizeFlowResistance1=linearizeFlowResistance1,
    final deltaM1=deltaM1,
    final from_dp2=from_dp2,
    final dp2_nominal=0,
    final linearizeFlowResistance2=linearizeFlowResistance2,
    final deltaM2=deltaM2,
    final homotopyInitialization=homotopyInitialization,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final m1_flow_small=m1_flow_small,
    final m2_flow_small=m2_flow_small,
    final tau1=tau1,
    final tau2=tau2,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p1_start=p1_start,
    final T1_start=T1_start,
    final X1_start=X1_start,
    final C1_start=C1_start,
    final C1_nominal=C1_nominal,
    final p2_start=p2_start,
    final T2_start=T2_start,
    final X2_start=X2_start,
    final C2_start=C2_start,
    final C2_nominal=C2_nominal) "Chiller"
    annotation (Placement(transformation(extent={{-10,-8},{10,12}})));
  inner replaceable Buildings.Templates.BaseClasses.Valve.None val_1
    constrainedby Buildings.Templates.Interfaces.Valve
    annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},
      rotation=90,
      origin={-20,30})));
  inner replaceable Buildings.Templates.BaseClasses.Pump.None pum_1
    constrainedby Buildings.Templates.Interfaces.Pump
    annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},
      rotation=270,
      origin={20,30})));
  inner replaceable Buildings.Templates.BaseClasses.Pump.None pum_2
    constrainedby Buildings.Templates.Interfaces.Pump
    annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},
      rotation=90,
      origin={-20,-30})));
  inner replaceable Buildings.Templates.BaseClasses.Valve.None val_2
    constrainedby Buildings.Templates.Interfaces.Valve
    annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},
      rotation=270,
      origin={20,-30})));
equation
  connect(port_b2, pum_2.port_b) annotation (Line(points={{-100,-60},{-20,-60},{
          -20,-40}}, color={0,127,255}));
  connect(pum_2.port_a, chi.port_b2)
    annotation (Line(points={{-20,-20},{-20,-4},{-10,-4}}, color={0,127,255}));
  connect(chi.port_a2, val_2.port_b)
    annotation (Line(points={{10,-4},{20,-4},{20,-20}}, color={0,127,255}));
  connect(val_2.port_a, port_a2)
    annotation (Line(points={{20,-40},{20,-60},{100,-60}}, color={0,127,255}));
  connect(chi.port_b1, pum_1.port_a)
    annotation (Line(points={{10,8},{20,8},{20,20}}, color={0,127,255}));
  connect(pum_1.port_b, port_b1)
    annotation (Line(points={{20,40},{20,60},{100,60}}, color={0,127,255}));
  connect(port_a1, val_1.port_a)
    annotation (Line(points={{-100,60},{-20,60},{-20,40}}, color={0,127,255}));
  connect(val_1.port_b, chi.port_a1)
    annotation (Line(points={{-20,20},{-20,8},{-10,8}}, color={0,127,255}));
  connect(busCon.val_1, val_1.busCon) annotation (Line(
      points={{0.1,100.1},{0.1,80},{-60,80},{-60,30},{-30,30}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(busCon.pum_1, pum_1.busCon) annotation (Line(
      points={{0.1,100.1},{0.1,80},{60,80},{60,30},{30,30}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(busCon.val_2, pum_2.busCon) annotation (Line(
      points={{0.1,100.1},{0.1,80},{-60,80},{-60,-30},{-30,-30}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(busCon.pum_2, val_2.busCon) annotation (Line(
      points={{0.1,100.1},{0.1,80},{60,80},{60,-30},{30,-30}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(busCon.out.on, chi.on) annotation (Line(
      points={{0,100},{0,80},{-60,80},{-60,5},{-12,5}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(busCon.out.TSet, chi.TSet) annotation (Line(
      points={{0,100},{0,80},{-60,80},{-60,-1},{-12,-1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(busCon.inp.P, chi.P) annotation (Line(
      points={{0,100},{0,80},{60,80},{60,11},{11,11}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ElectricChiller;