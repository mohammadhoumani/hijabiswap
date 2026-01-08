import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijabiswap/modules/activity/activity_controller.dart';
import 'package:hijabiswap/modules/activity/widgets/acticvity_skeleton_loader.dart';
import 'package:hijabiswap/modules/activity/widgets/recieved_req_card.dart';
import 'package:hijabiswap/modules/activity/widgets/sent_request_card.dart';
import 'package:hijabiswap/widgets/empty_state.dart';
import 'package:hijabiswap/utils/size_utils.dart';

class ActivityView extends GetView<ActivityController> {
  const ActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Activity',
          style: GoogleFonts.poppins(
            fontSize: SizeUtils.scaleY(17),
            fontWeight: FontWeight.bold,
            color: themeData.colorScheme.primary,
          ),
        ),
      ),

      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeUtils.scaleX(16),
              vertical: SizeUtils.scaleY(16),
            ),
            child: Container(
              height: SizeUtils.scaleY(48),
              decoration: BoxDecoration(
                color: themeData.colorScheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(SizeUtils.scaleY(25)),
              ),
              child: TabBar(
                controller: controller.tabController,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      themeData.colorScheme.primary,
                      themeData.colorScheme.primary.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(SizeUtils.scaleY(22)),
                  boxShadow: [
                    BoxShadow(
                      color: themeData.colorScheme.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                labelStyle: GoogleFonts.inter(
                  fontSize: SizeUtils.scaleY(13),
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: GoogleFonts.inter(
                  fontSize: SizeUtils.scaleY(13),
                  fontWeight: FontWeight.w500,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: themeData.colorScheme.onSurface
                    .withOpacity(0.6),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.paperPlane,
                          size: SizeUtils.scaleY(14),
                        ),
                        SizedBox(width: SizeUtils.scaleX(8)),
                        Text("Sent"),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.inbox,
                          size: SizeUtils.scaleY(14),
                        ),
                        SizedBox(width: SizeUtils.scaleX(8)),
                        Text("Received"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                // Sent Requests Tab
                Obx(() {
                  if (controller.isLoadingSent.value) {
                    return const ActivitySkeletonLoader();
                  }

                  if (controller.sentError.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            controller.sentError.value,
                            style: GoogleFonts.inter(
                              fontSize: SizeUtils.scaleY(14),
                              color: themeData.colorScheme.error,
                            ),
                          ),
                          SizedBox(height: SizeUtils.scaleY(12)),
                          ElevatedButton.icon(
                            onPressed: controller.fetchSentRequests,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  final filtered = controller.filterByStatus(
                    controller.sentRequests,
                    controller.sentStatusFilter.value,
                  );

                  final content =
                      filtered.isEmpty
                          ? EmptyState(
                            icon: FontAwesomeIcons.paperPlane,
                            title: 'No sent requests yet',
                            message:
                                'You haven\'t requested any items. Explore and start swapping.',
                            actionLabel: 'Refresh',
                            onAction: controller.fetchSentRequests,
                          )
                          : RefreshIndicator(
                            onRefresh: () async {
                              controller.fetchSentRequests();
                            },
                            child: ListView.separated(
                              padding: EdgeInsets.only(
                                top: SizeUtils.scaleY(8),
                                bottom: SizeUtils.scaleY(16),
                              ),
                              itemCount: filtered.length,
                              separatorBuilder:
                                  (_, __) =>
                                      SizedBox(height: SizeUtils.scaleY(8)),
                              itemBuilder: (context, index) {
                                final req = filtered[index];
                                return SentRequestCard(
                                  request: req,
                                  cancelLoading: controller.cancelLoading,
                                  onCancel:
                                      () => controller.cancelRequest(req.id),
                                );
                              },
                            ),
                          );

                  return Column(
                    children: [
                      _StatusFilterChips(
                        selected: controller.sentStatusFilter,
                        onSelected: controller.setSentStatusFilter,
                      ),
                      Expanded(child: content),
                    ],
                  );
                }),
                // Received Requests Tab
                Obx(() {
                  if (controller.isLoadingReceived.value) {
                    return const ActivitySkeletonLoader();
                  }

                  if (controller.receivedError.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            controller.receivedError.value,
                            style: GoogleFonts.inter(
                              fontSize: SizeUtils.scaleY(14),
                              color: themeData.colorScheme.error,
                            ),
                          ),
                          SizedBox(height: SizeUtils.scaleY(12)),
                          ElevatedButton.icon(
                            onPressed: controller.fetchReceivedRequests,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  final filtered = controller.filterByStatus(
                    controller.receivedRequests,
                    controller.receivedStatusFilter.value,
                  );

                  final content =
                      filtered.isEmpty
                          ? EmptyState(
                            icon: FontAwesomeIcons.inbox,
                            title: 'No received requests yet',
                            message:
                                'No one requested your items yet. Share more to get interest.',
                            actionLabel: 'Refresh',
                            onAction: controller.fetchReceivedRequests,
                          )
                          : RefreshIndicator(
                            onRefresh: () async {
                              controller.fetchReceivedRequests();
                            },
                            child: ListView.separated(
                              padding: EdgeInsets.only(
                                top: SizeUtils.scaleY(8),
                                bottom: SizeUtils.scaleY(16),
                              ),
                              itemCount: filtered.length,
                              separatorBuilder:
                                  (_, __) =>
                                      SizedBox(height: SizeUtils.scaleY(8)),
                              itemBuilder: (context, index) {
                                final req = filtered[index];
                                return ReceivedRequestCard(
                                  request: req,
                                  acceptLoading: controller.acceptLoading,
                                  rejectLoading: controller.rejectLoading,
                                  onAccept:
                                      () => controller.acceptRequest(req.id),
                                  onReject:
                                      () => controller.rejectRequest(req.id),
                                );
                              },
                            ),
                          );

                  return Column(
                    children: [
                      _StatusFilterChips(
                        selected: controller.receivedStatusFilter,
                        onSelected: controller.setReceivedStatusFilter,
                      ),
                      Expanded(child: content),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const _statusOptions = <Map<String, String>>[
  {'value': 'all', 'label': 'All'},
  {'value': 'pending', 'label': 'Pending'},
  {'value': 'accepted', 'label': 'Accepted'},
  {'value': 'confirmed', 'label': 'Confirmed'},
  {'value': 'completed', 'label': 'Completed'},
  {'value': 'rejected', 'label': 'Rejected'},
  {'value': 'cancelled', 'label': 'Cancelled'},
];

class _StatusFilterChips extends StatelessWidget {
  final RxString selected;
  final ValueChanged<String> onSelected;

  const _StatusFilterChips({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: SizeUtils.scaleX(16),
          vertical: SizeUtils.scaleY(8),
        ),
        child: Row(
          children:
              _statusOptions.map((opt) {
                final value = opt['value']!;
                final isSelected = selected.value == value;
                return Padding(
                  padding: EdgeInsets.only(right: SizeUtils.scaleX(8)),
                  child: ChoiceChip(
                    label: Text(
                      opt['label']!,
                      style: GoogleFonts.inter(
                        fontSize: SizeUtils.scaleY(12),
                        fontWeight: FontWeight.w600,
                        color:
                            isSelected
                                ? Colors.white
                                : theme.colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (_) => onSelected(value),
                    selectedColor: theme.colorScheme.primary,
                    backgroundColor: theme.colorScheme.primary.withOpacity(
                      0.08,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(SizeUtils.scaleY(18)),
                      side: BorderSide(
                        color:
                            isSelected
                                ? theme.colorScheme.primary
                                : theme.dividerColor,
                      ),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
