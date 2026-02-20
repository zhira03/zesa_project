import 'package:WattTrade/components/animatedAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Marketplace extends StatefulWidget {
  const Marketplace({super.key});

  @override
  State<Marketplace> createState() => _MarketplaceState();
}

class _MarketplaceState extends State<Marketplace> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AnimatedThemedAppBar(
          title:'MarketPlace'
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [

              // search bar section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.white60),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: "Search Location or name",
                          hintStyle: TextStyle(color: Colors.white60),
                          border: InputBorder.none,
                        ),
                      ),
                    )
                  ]
                )
              ),

              // ave price, kwh available and active users bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: const [
                        Text("Avg Price", style: TextStyle(color: Colors.white60)),
                        SizedBox(height: 5),
                        Text("\$0.12/kWh", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))
                      ],
                    ),
                    Column(
                      children: const [
                        Text("kWh Available", style: TextStyle(color: Colors.white60)),
                        SizedBox(height: 5),
                        Text("1500 kWh", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))
                      ],
                    ),
                    Column(
                      children: const [
                        Text("Active Users", style: TextStyle(color: Colors.white60)),
                        SizedBox(height: 5),
                        Text("250 Users", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))
                      ]
                    )
                  ]
                )
              )
            ],
          ),
        ),
      )
    );
  }
}