import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/citie_model.dart';
import 'package:weather_app/res/app_url.dart';
import 'package:weather_app/res/custom_widgets/app_text.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WeatherProvider>(context, listen: false).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppUrl.bgImage),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4), BlendMode.dstATop),
                filterQuality: FilterQuality.high)),
        child: Consumer<WeatherProvider>(
          builder: (context, provider, child) {
            //provider.getCurrentLocation();
            return provider.getLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : provider.weatherModel != null
                    ? ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Container(
                              alignment: Alignment.center,
                              width: MediaQuery.sizeOf(context).width,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 1),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  tileMode: TileMode.clamp,
                                  colors: [
                                    Colors.grey.withOpacity(0.2),
                                    Colors.black38.withOpacity(0.2),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Autocomplete<City>(
                                fieldViewBuilder: (context,
                                    textEditingController,
                                    focusNode,
                                    onFieldSubmitted) {
                                  return TextFormField(
                                    focusNode: focusNode,
                                    controller: textEditingController,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal),
                                    // onFieldSubmitted: onFieldSubmitted,
                                    decoration: const InputDecoration(
                                        isDense: true,
                                        hintText:
                                            'Enter location name of Pakistan',
                                        hintStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal),
                                        // suffixIcon: InkWell(
                                        //   onTap: () {},
                                        //   child: const Icon(
                                        //     Icons.search,
                                        //     color: Colors.white,
                                        //   ),
                                        // ),

                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none)),
                                  );
                                },
                                displayStringForOption: (city) => city.name,
                                optionsViewBuilder:
                                    (context, onSelected, options) {
                                  return ListView.builder(
                                      padding: const EdgeInsets.only(top: 2),
                                      itemCount: options.length,
                                      itemBuilder: (context, index) {
                                        var data = options.toList();
                                        return Material(
                                          child: InkWell(
                                            onTap: () {
                                              onSelected(data[index]);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              color: Colors.white,
                                              child: AppText(
                                                text: data[index].name,
                                                textColor: Colors.black,
                                                isStart: true,
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                },
                                optionsBuilder: (value) {
                                  if (value.text == '') {
                                    return const Iterable<City>.empty();
                                  }
                                  return provider.citiesModel!.cities
                                      .where((element) {
                                    return element.name
                                        .toLowerCase()
                                        .startsWith(value.text.toLowerCase());
                                  });
                                },
                                onSelected: (option) {
                                  provider.setSearchLocation(option.name);
                                  provider.fetchWeatherForecast();
                                },
                              )

                              /* TextField(
                      controller: provider.controller,
                      cursorColor: Colors.white,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.normal),
                      decoration: const InputDecoration(
                          isDense: true,
                          hintText: 'Enter location name of Pakistan',
                          hintStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                          // suffixIcon: InkWell(
                          //   onTap: () {},
                          //   child: const Icon(
                          //     Icons.search,
                          //     color: Colors.white,
                          //   ),
                          // ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none)),
                    ) */
                              ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.sizeOf(context).width,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 1),
                              gradient: LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                tileMode: TileMode.clamp,
                                colors: [
                                  Colors.grey.withOpacity(0.2),
                                  Colors.black38.withOpacity(0.2),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AppText(
                                      text: provider.getCityName ?? '',
                                      textSize: 18,
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    const Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ],
                                ),
                                AppText(
                                  text:
                                      '${provider.weatherModel!.current.feelslikeC}\u00B0',
                                  textSize: 24,
                                  textColor: Colors.white,
                                ),
                                AppText(
                                  text: provider
                                      .weatherModel!.current.condition.text,
                                  textColor: Colors.white,
                                  textSize: 16,
                                ),
                                AppText(
                                    text:
                                        'Humidity: ${provider.weatherModel!.current.humidity}')
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.sizeOf(context).width,
                            // padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 1),
                              gradient: LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                tileMode: TileMode.clamp,
                                colors: [
                                  Colors.grey.withOpacity(0.2),
                                  Colors.black38.withOpacity(0.2),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SizedBox(
                              height: 85,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: 6,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AppText(
                                          text: 'Now',
                                          textSize: 14,
                                          textColor: Colors.white,
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        const Icon(
                                          Icons.cloud_outlined,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        AppText(
                                          text: '27',
                                          textSize: 14,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                              alignment: Alignment.center,
                              width: MediaQuery.sizeOf(context).width,
                              // padding: const EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 1),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  tileMode: TileMode.clamp,
                                  colors: [
                                    Colors.grey.withOpacity(0.2),
                                    Colors.black38.withOpacity(0.2),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: provider.weatherModel!.forecast
                                      .forecastday.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AppText(
                                            text: DateFormat('EEEE').format(
                                                provider.weatherModel!.forecast
                                                    .forecastday[index].date),
                                            textSize: 15,
                                          ),
                                          SizedBox(
                                            width: 100,
                                            child: AppText(
                                              text: provider
                                                  .weatherModel!
                                                  .forecast
                                                  .forecastday[index]
                                                  .day
                                                  .condition
                                                  .text,
                                              textSize: 15,
                                            ),
                                          ),
                                          Image.network(
                                            'https:${provider.weatherModel!.forecast.forecastday[index].day.condition.icon}',
                                            width: 50,
                                            height: 50,
                                          ),
                                          AppText(
                                            text:
                                                '${provider.weatherModel!.forecast.forecastday[index].day.avgtempC.round()}\u00B0',
                                            textSize: 15,
                                          ),
                                        ],
                                      ),
                                    );
                                  })),
                        ],
                      )
                    : Center(
                        child: AppText(text: 'No data to display'),
                      );
          },
        ),
      ),
    );
  }
}
