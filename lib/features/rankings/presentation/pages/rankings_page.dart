import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:final_flashcard/configs/common/global_color.dart';
import 'package:final_flashcard/core/utils/ui_helpers.dart';
import 'package:final_flashcard/features/rankings/domain/entities/rankings.dart';
import 'package:final_flashcard/features/rankings/presentation/bloc/rankings_bloc.dart';
import 'package:final_flashcard/features/topic/presentation/widgets/circular_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RankingsPage extends StatefulWidget {
  const RankingsPage({super.key});

  @override
  State<RankingsPage> createState() => _RankingsPageState();
}

class _RankingsPageState extends State<RankingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: GlobalColors.primaryColor,
          ),
          onPressed: () {
            navigator?.pop();
          },
        ),
        title: BlocConsumer<RankingsBloc, RankingsState>(
          listener: (_, state) {
            if (state is RankingsError) {
              UIHelpers.showAwesomeDialog(
                context: context,
                title: 'error'.tr,
                message: state.data.error.tr,
                type: DialogType.error,
              );
            }
          },
          builder: (_, state) {
            final topic = state.data.topic;
            if (topic != null) {
              return Text(
                '${'rankings'.tr} ${topic.title ?? ''}',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  color: GlobalColors.primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext cntext) {
    return SafeArea(
      child: Column(
        children: [
          const Gap(20),
          _buildTopThree(),
          const Gap(16),
          _buildTheRest(),
        ],
      ),
    );
  }

  Widget _buildTopThree() {
    return BlocBuilder<RankingsBloc, RankingsState>(
      builder: (_, state) {
        final rankings = state.data.rankings;
        final rankingsLength = rankings.length;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (rankingsLength >= 2)
                _buildTopThreeItem(rankings[1], index: 2)
              else
                const Spacer(),
              if (rankingsLength >= 1)
                _buildTopThreeItem(rankings[0], index: 1)
              else
                const Spacer(),
              if (rankingsLength >= 3)
                _buildTopThreeItem(rankings[2], index: 3)
              else
                const Spacer(),
            ],
          ),
        );
      },
    );
  }

  Expanded _buildTopThreeItem(Rankings rankings, {int? index}) {
    return Expanded(
      child: Column(
        children: [
          CircularAvatar(
            url: rankings.topicLearningStatistics?.user?.image ?? '',
            size: 80,
            topRightBadge: index,
            completePercentage:
                rankings.topicLearningStatistics?.percentageCompleted ?? 0.0,
          ),
          const Gap(10),
          Text(
            rankings.topicLearningStatistics?.user?.name ?? '',
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 16,
              color: GlobalColors.primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Gap(10),
          Text(
            secondsToTime(rankings.topicLearningStatistics?.secondsSpent ?? 0),
            style: GoogleFonts.outfit(
              fontSize: 16,
              color: GlobalColors.primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String secondsToTime(int seconds) {
    final int hour = seconds ~/ 3600;
    final int minute = (seconds % 3600) ~/ 60;
    final int second = seconds % 60;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}';
  }

  Widget _buildTheRest() {
    return BlocBuilder<RankingsBloc, RankingsState>(
      builder: (_, state) {
        final rankings = state.data.rankings;
        final rankingsLength = rankings.length;
        return Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: GlobalColors.primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding:
                const EdgeInsets.symmetric(vertical: 16).copyWith(left: 16),
            child: ListView.builder(
              itemCount: rankingsLength,
              itemBuilder: (_, index) {
                if (index < 3) {
                  return const SizedBox.shrink();
                }
                return _buildRankingCard(
                  index,
                  rankings,
                  rankingsLength,
                );
              },
            ),
          ),
        );
      },
    );
  }

  Container _buildRankingCard(
      int index, List<Rankings> rankings, int rankingsLength) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '${index + 1}',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 16,
              color: GlobalColors.primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    CircularAvatar(
                      url: rankings[index]
                              .topicLearningStatistics
                              ?.user
                              ?.image ??
                          '',
                      size: 40,
                    ),
                    const Gap(10),
                    Expanded(
                      child: Text(
                        rankings[index].topicLearningStatistics?.user?.name ??
                            '',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          color: GlobalColors.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CircularProgressIndicator(
                              value: rankings[index]
                                      .topicLearningStatistics
                                      ?.percentageCompleted ??
                                  0.0,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  GlobalColors.primaryColor),
                              backgroundColor:
                                  GlobalColors.primaryColor.withOpacity(0.1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(10),
                  ],
                ),
                if (index != rankingsLength - 1) ...[
                  const Gap(8),
                  const Divider(
                    color: GlobalColors.primaryColor,
                    height: 0,
                    thickness: 0.5,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
