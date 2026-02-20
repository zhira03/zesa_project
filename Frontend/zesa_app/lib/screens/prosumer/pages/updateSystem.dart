import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SystemUpdate extends StatefulWidget {
  final int panelCount;
  final double panelSize;
  final String panelType;
  final int batteryCount;
  final double batteryCapacity;
  final String batteryType;
  final int inverterCount;
  final double inverterCapacity;
  final String inverterType;

  const SystemUpdate({super.key, required this.panelCount, required this.panelSize, required this.panelType, required this.batteryCount, required this.batteryCapacity, required this.batteryType, required this.inverterCount, required this.inverterCapacity, required this.inverterType});

  @override
  State<SystemUpdate> createState() => _SystemUpdateState();
}

class _SystemUpdateState extends State<SystemUpdate> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: (){Navigator.pop(context);}, 
                      icon: Icon(Icons.arrow_back_outlined)),
                    Column(
                      children: [
                        Text("Solar System Details"),
                        // Text("Manage your installation information",
                        //   style: TextStyle(
                        //     fontSize: 12,
                        //     color: Colors.grey
                        //   ),
                        // )
                      ],
                    ),
                    TextButton(
                      onPressed: (){
                          setState(() {
                            _isEditing = !_isEditing;
                          });
                      }, 
                      child: Text(_isEditing ? "Save" : "Edit")
                    )
                  ],
                ),
                const SizedBox(height: 20,),
                
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1C2B3A), Color(0xFF162235)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color.fromARGB(255, 9, 80, 15).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(FluentIcons.weather_sunny_32_filled, color: Colors.lightGreen),
                          Column(
                            children: [
                              Text("Total System Capacity"),
                              Text("${(widget.panelCount * widget.panelSize) / 1000} kW"),
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 68, 102, 136),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: const Color.fromARGB(255, 23, 63, 26).withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text("Panel Capacity"),
                                    Text("${(widget.panelCount * widget.panelSize) / 1000} kW"),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 68, 102, 136),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: const Color.fromARGB(255, 9, 80, 15).withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text("Storage Capacity"),
                                    Text("${(widget.batteryCount * widget.batteryCapacity) / 1000} KAh"),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                
                // Battery Info Section
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 68, 102, 136),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color.fromARGB(255, 23, 63, 26).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(FluentIcons.battery_10_20_filled, color: Colors.lightGreen),
                          title: Text("Battery Details"),
                          subtitle: Text("Energy storage system details"),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Battery Type"),
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 51, 53, 56),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white,
                              width: 0.5,
                            ),
                          ),
                          child:Text(widget.batteryType)
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Battery Capacity per Unit")
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 51, 53, 56),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white,
                              width: 0.5,
                            ),
                          ),
                          child:Text("${widget.batteryCapacity} KAh")
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Number of Battery Units")
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 51, 53, 56),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white,
                              width: 0.5,
                            ),
                          ),
                          child:Text(widget.batteryCount.toString())
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color.fromARGB(184, 93, 202, 108), Color.fromARGB(255, 9, 49, 11)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color.fromARGB(255, 9, 80, 15).withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.info_outline_rounded,
                                    color: Color(0xFFF59E0B),
                                    size: 15,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "Total Battery Capacity: ${widget.batteryCount * widget.batteryCapacity} KAh",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),


                const SizedBox(height: 20),
                //panel info section
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 68, 102, 136),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color.fromARGB(255, 23, 63, 26).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(FluentIcons.weather_sunny_32_filled, color: Colors.lightGreen),
                          title: Text("Panel Details"),
                          subtitle: Text("Solar panel system details"),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Panel Type"),
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 51, 53, 56),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white,
                              width: 0.5,
                            ),
                          ),
                          child:Text(widget.panelType)
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Panel Size per Unit")
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 51, 53, 56),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white,
                              width: 0.5,
                            ),
                          ),
                          child:Text("${widget.panelSize} W")
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Number of Panels")
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 51, 53, 56),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white,
                              width: 0.5,
                            ),
                          ),
                          child:Text(widget.panelCount.toString())
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color.fromARGB(184, 93, 202, 108), Color.fromARGB(255, 9, 49, 11)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color.fromARGB(255, 9, 80, 15).withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.info_outline_rounded,
                                    color: Color(0xFFF59E0B),
                                    size: 15,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "Total Panel Capacity: ${(widget.panelCount * widget.panelSize) / 1000} kW",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                //inverter section
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 68, 102, 136),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color.fromARGB(255, 23, 63, 26).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.bolt, color: Colors.lightGreen),
                          title: Text("Inverter Details"),
                          subtitle: Text("Power conversion system details"),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Inverter Type"),
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 51, 53, 56),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white,
                              width: 0.5,
                            ),
                          ),
                          child:Text(widget.inverterType)
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Inverter Capacity per Unit")
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 51, 53, 56),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white,
                              width: 0.5,
                            ),
                          ),
                          child:Text("${widget.inverterCapacity} kW")
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Number of Inverter Units")
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 51, 53, 56),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white,
                              width: 0.5,
                            ),
                          ),
                          child:Text(widget.inverterCount.toString())
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color.fromARGB(184, 93, 202, 108), Color.fromARGB(255, 9, 49, 11)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color.fromARGB(255, 9, 80, 15).withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.info_outline_rounded,
                                    color: Color(0xFFF59E0B),
                                    size: 15,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "Total Inverter Capacity: ${widget.inverterCount * widget.inverterCapacity} kW",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                _isEditing 
                  ? Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 68, 102, 136),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color.fromARGB(255, 23, 63, 26).withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text("Editing mode enabled"),
                          Text("Make your changes and click \"Save\" to update your solar system details. These changes will be reflected in your energy production calculations and marketplace listings.")
                        ],
                      )
                    )
                  : Container(),
              ]
            ),
          ),
        )
      )
    );
  }
}