import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stream_gold_rate/src/features/gold/data/fake_gold_api.dart';

class GoldScreen extends StatefulWidget {
  const GoldScreen({super.key});

  @override
  State<GoldScreen> createState() => _GoldScreenState();
}

class _GoldScreenState extends State<GoldScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              Text('Live Kurs:',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 20),
              // Verwende einen StreamBuilder, um den Goldpreis live anzuzeigen
              StreamBuilder<double>(
                stream: getGoldPriceStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Zustand: Ladend
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    // Zustand: Daten (Goldpreis vorhanden)
                    final goldPrice = snapshot.data!;
                    return Text(
                      NumberFormat.simpleCurrency(locale: 'de_DE')
                          .format(goldPrice),
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(
                              color: Theme.of(context).colorScheme.primary),
                    );
                  } else if (snapshot.hasError) {
                    // Zustand: Error
                    return Text('Fehler: ${snapshot.error}');
                  } else {
                    // Zustand: Keine Daten und kein Fehler (sollte hier eigentlich nicht eintreten)
                    return const Text('Keine Daten vorhanden');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Image(
          image: AssetImage('assets/bars.png'),
          width: 100,
        ),
        Text('Gold', style: Theme.of(context).textTheme.headlineLarge),
      ],
    );
  }
}
