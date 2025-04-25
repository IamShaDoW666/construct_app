import 'package:digicon/constants/keys.dart';
import 'package:digicon/constants/routes.dart';
import 'package:digicon/providers/theme_provider.dart';
import 'package:digicon/services/network.dart';
import 'package:digicon/utils/common.dart';
import 'package:digicon/utils/debug.dart';
import 'package:flutter/material.dart';
import 'package:digicon/data/models.dart';
import 'package:digicon/services/api_service.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class ImageListScreen extends StatefulWidget {
  const ImageListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ImageListScreenState createState() => _ImageListScreenState();
}

class _ImageListScreenState extends State<ImageListScreen> {
  DateTimeRange? selectedDateRange;
  String searchQuery = '';
  late Future<List<Batch>> _batchesFuture;

  @override
  void initState() {
    super.initState();
    _batchesFuture = fetchBatches();
  }

  // Future<List<Media>> fetchBatches() async {
  //   try {
  //     final res = await ApiService.getImages();
  //     return res;
  //   } catch (e) {
  //     throw Exception('Error fetching images: $e');
  //   }
  // }

  Future<List<Batch>> fetchBatches() async {
    final res = await ApiService.getBatches();
    return res;
  }

  void _pickDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: selectedDateRange,
    );
    if (picked != null && picked != selectedDateRange) {
      setState(() {
        selectedDateRange = picked;
      });
    }
  }

  List<Batch> _filterBatches(List<Batch> batches) {
    return batches.where((batch) {
      final title = batch.name?.toLowerCase() ?? '';
      final query = searchQuery.toLowerCase();
      final matchesQuery =
          title.contains(query) ||
          batch.reference!.toLowerCase().contains(query);

      final createdAt = batch.createdAt;
      final matchesDate =
          selectedDateRange == null ||
          (createdAt.isAfter(selectedDateRange!.start) &&
              createdAt.isBefore(
                selectedDateRange!.end.add(Duration(days: 1)),
              ));

      return matchesQuery && matchesDate;
    }).toList();
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: context.cardColor,
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: _pickDateRange,
            tooltip: 'Filter by date',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('All Batches'),
        actions: [
          IconButton(
            iconSize: 32,
            icon:
                !themeProvider.isDarkMode
                    ? Icon(Icons.dark_mode)
                    : Icon(Icons.light_mode),
            onPressed: () {
              themeProvider.toggleTheme();
              setState(() {});
            },
          ),
          IconButton(
            iconSize: 32,
            icon: const Icon(Icons.logout),
            onPressed: () {
              removeKey(Constants.jwtKey);
              context.go(AppRoutes.login);
              setState(() {});
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(AppRoutes.batchCreate).then((didChange) {
            if (didChange != null && didChange == true) {
              setState(() {});
              _batchesFuture = fetchBatches();
            }
          });
        },
        child: Icon(Icons.add),
      ),

      body: FutureBuilder<List<Batch>>(
        future: _batchesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Request timed out"));
          }

          final batches = snapshot.data ?? [];
          final filteredBatches = _filterBatches(batches);

          return Column(
            children: [
              _buildSearchBar(),
              if (selectedDateRange != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        'From: ${selectedDateRange!.start.toLocal().toIso8601String().substring(0, 10)}'
                        '  To: ${selectedDateRange!.end.toLocal().toIso8601String().substring(0, 10)}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.clear),
                        tooltip: 'Clear date filter',
                        onPressed: () {
                          setState(() {
                            selectedDateRange = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // ElevatedButton.icon(
                  //   onPressed: () {
                  //     // Navigate to the image picker screen
                  //     context.push(AppRoutes.batchCreate).then((didChange) {
                  //       if (didChange != null && didChange == true) {
                  //         setState(() {});
                  //         _batchesFuture = fetchBatches();
                  //       }
                  //     });
                  //   },
                  //   label: Text('Add'),
                  //   icon: Icon(Icons.add_circle),
                  //   iconAlignment: IconAlignment.end,
                  // ).paddingOnly(right: 16, bottom: 8, top: 8),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    tooltip: 'Refresh',
                    onPressed: () {
                      setState(() {
                        _batchesFuture = fetchBatches();
                      });
                    },
                  ).paddingOnly(right: 16, bottom: 8, top: 8),
                ],
              ),
              Expanded(
                child:
                    filteredBatches.isEmpty
                        ? Center(child: Text('No images found.'))
                        : ListView.builder(
                          itemCount: filteredBatches.length,
                          itemBuilder: (context, index) {
                            final batch = filteredBatches[index];
                            return Card(
                              margin: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          batch.reference ?? 'No reference',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Media: ${batch.media.length}',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Created at: ${formatDateTime(batch.createdAt)}',
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Created by: ${batch.createdBy.name}',
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.remove_red_eye,
                                        size: 24,
                                      ),
                                      onPressed: () {
                                        context
                                            .push(
                                              AppRoutes.batchDetails,
                                              extra: batch,
                                            )
                                            .then((didChange) {
                                              if (didChange != null &&
                                                  didChange == true) {
                                                setState(() {});
                                                _batchesFuture = fetchBatches();
                                              }
                                            });
                                      },
                                    ),
                                  ],
                                ).paddingAll(8),
                              ),
                            );
                          },
                        ),
              ),
            ],
          );
        },
      ),
    );
  }
}
