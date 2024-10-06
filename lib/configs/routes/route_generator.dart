import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:final_flashcard/core/data/typedef.dart';
import 'package:final_flashcard/core/utils/custom_page_route.dart';
import 'package:final_flashcard/di/di_config.dart';
import 'package:final_flashcard/features/authentication/domain/use_case/login.dart';
import 'package:final_flashcard/features/authentication/domain/use_case/registration.dart';
import 'package:final_flashcard/features/authentication/domain/use_case/request_otp_password.dart';
import 'package:final_flashcard/features/authentication/domain/use_case/reset_password.dart';
import 'package:final_flashcard/features/authentication/domain/use_case/social_login.dart';
import 'package:final_flashcard/features/authentication/domain/use_case/verify_otp.dart';
import 'package:final_flashcard/features/authentication/presentation/bloc/login/login_bloc.dart';
import 'package:final_flashcard/features/authentication/presentation/bloc/register/register_bloc.dart';
import 'package:final_flashcard/features/authentication/presentation/pages/authetication_page.dart';
import 'package:final_flashcard/features/authentication/presentation/pages/login_page.dart';
import 'package:final_flashcard/features/authentication/presentation/pages/register_page.dart';
import 'package:final_flashcard/features/folder/domain/entities/folder.dart';
import 'package:final_flashcard/features/folder/domain/use_case/add_folder.dart';
import 'package:final_flashcard/features/folder/domain/use_case/get_user_folders.dart';
import 'package:final_flashcard/features/folder/presentation/bloc/folder/folder_bloc.dart';
import 'package:final_flashcard/features/folder/presentation/bloc/folder_detail_bloc/folder_detail_bloc.dart';
import 'package:final_flashcard/features/folder/presentation/bloc/folder_to_topic_bloc/folder_to_topic_bloc.dart';
import 'package:final_flashcard/features/folder/presentation/pages/add_folder_to_topic_page.dart';
import 'package:final_flashcard/features/folder/presentation/pages/folder_detail_page.dart';
import 'package:final_flashcard/features/home/presentation/bloc/home_bloc.dart';
import 'package:final_flashcard/features/home/presentation/widgets/main_bottom_navbar.dart';
import 'package:final_flashcard/features/learning/domain/use_cases/update_learning_statistics.dart';
import 'package:final_flashcard/features/learning/presentation/bloc/flashcard_learning_bloc/flashcard_learning_bloc.dart';
import 'package:final_flashcard/features/learning/presentation/bloc/matching_learning_bloc/matching_learning_bloc.dart';
import 'package:final_flashcard/features/learning/presentation/bloc/quiz_learning_bloc/quiz_learning_bloc.dart';
import 'package:final_flashcard/features/learning/presentation/bloc/typing_learning_bloc/typing_learning_bloc.dart';
import 'package:final_flashcard/features/learning/presentation/pages/quiz_learning_page.dart';
import 'package:final_flashcard/features/learning/presentation/pages/typing_learning_page.dart';
import 'package:final_flashcard/features/on_boarding/on_boarding_page.dart';
import 'package:final_flashcard/features/profile/domain/use_case/change_dark_mode.dart';
import 'package:final_flashcard/features/profile/domain/use_case/change_language.dart';
import 'package:final_flashcard/features/profile/domain/use_case/change_name.dart';
import 'package:final_flashcard/features/profile/domain/use_case/change_password.dart';
import 'package:final_flashcard/features/profile/domain/use_case/change_push_notification.dart';
import 'package:final_flashcard/features/profile/domain/use_case/change_save_offline.dart';
import 'package:final_flashcard/features/profile/domain/use_case/get_profile.dart';
import 'package:final_flashcard/features/profile/domain/use_case/logout.dart';
import 'package:final_flashcard/features/profile/domain/use_case/pick_profile_image.dart';
import 'package:final_flashcard/features/profile/domain/use_case/send_otp_new_email.dart';
import 'package:final_flashcard/features/profile/domain/use_case/verify_new_email.dart';
import 'package:final_flashcard/features/profile/domain/use_case/verify_password.dart';
import 'package:final_flashcard/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:final_flashcard/features/rankings/domain/use_case/get_rankings.dart';
import 'package:final_flashcard/features/rankings/presentation/bloc/rankings_bloc.dart';
import 'package:final_flashcard/features/rankings/presentation/pages/rankings_page.dart';
import 'package:final_flashcard/features/search/domain/use_case/fetch_search_topics.dart';
import 'package:final_flashcard/features/search/presentation/bloc/search_bloc.dart';
import 'package:final_flashcard/features/splash/domain/use_case/get_configuration.dart';
import 'package:final_flashcard/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:final_flashcard/features/splash/presentation/pages/splash_page.dart';
import 'package:final_flashcard/features/topic/domain/entities/topic.dart';
import 'package:final_flashcard/features/topic/domain/entities/vocabulary.dart';
import 'package:final_flashcard/features/topic/domain/use_case/delete_topic.dart';
import 'package:final_flashcard/features/topic/domain/use_case/favorite_vocabulary.dart';
import 'package:final_flashcard/features/topic/domain/use_case/get_recently_learned.dart';
import 'package:final_flashcard/features/topic/domain/use_case/get_topic_details.dart';
import 'package:final_flashcard/features/topic/domain/use_case/get_user_topics.dart';
import 'package:final_flashcard/features/topic/domain/use_case/save_topic_to_local.dart';
import 'package:final_flashcard/features/topic/presentation/bloc/add_topic_bloc/add_topic_bloc.dart';
import 'package:final_flashcard/features/topic/presentation/bloc/add_topic_folder_bloc/add_topic_folder_bloc.dart';
import 'package:final_flashcard/features/topic/presentation/bloc/topic/topic_bloc.dart';
import 'package:final_flashcard/features/topic/presentation/bloc/topic_details/topic_details_bloc.dart';
import 'package:final_flashcard/features/topic/presentation/pages/add_topic_page.dart';
import 'package:final_flashcard/features/topic/presentation/pages/add_topic_to_folder_page.dart';
import 'package:final_flashcard/features/learning/presentation/pages/flashcard_learning_page.dart';
import 'package:final_flashcard/features/topic/presentation/pages/topic_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../features/learning/presentation/pages/matching_learning_page.dart';

class RouteGenerator {
  static const String splash = '/';
  static const String onBoarding = '/onBoarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String commonBottomNavbar = '/commonBottomNavbar';
  static const String authentication = '/authentication';
  static const String addTopic = '/addTopic';
  static const String folderDetail = '/folderDetail';
  static const String addTopicToFolder = '/addTopicToFolder';
  static const String addFolderToTopic = '/addFolderToTopic';
  static const String topicDetails = '/topicDetails';
  static const String learningFlashcard = '/learningFlashcard';
  static const String learningQuiz = '/learningQuiz';
  static const String learningTyping = '/learningTyping';
  static const String learningMatching = '/learningMatching';
  static const String learningRankings = '/learningRankings';

  static Route<dynamic>? generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case learningRankings:
        final args = settings.arguments as DataMap;
        final topic = args['TOPIC'] as Topic;
        return CustomPageRoute(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => RankingsBloc(
                  getIt.get<GetRankingsUseCase>(),
                )..add(
                    GetRankings(
                      topic: topic,
                    ),
                  ),
              ),
            ],
            child: const RankingsPage(),
          ),
        );
      case learningMatching:
        final args = settings.arguments as DataMap;
        final topic = args['TOPIC'] as Topic;
        final selectedVocabularies = args['VOCABULARIES'] as List<Vocabulary>;
        return CustomPageRoute(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => MatchingLearningBloc(
                  getIt.get<UpdateLearningStatisticsUseCase>(),
                )..add(
                    InitMatchingLearning(
                      topic: topic,
                      selectedVocabularies: selectedVocabularies,
                    ),
                  ),
              ),
            ],
            child: const MatchingLearningPage(),
          ),
        );
      case learningTyping:
        final args = settings.arguments as DataMap;
        final topic = args['TOPIC'] as Topic;
        final selectedVocabularies = args['VOCABULARIES'] as List<Vocabulary>;
        return CustomPageRoute(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => TypingLearningBloc(
                  getIt.get<UpdateLearningStatisticsUseCase>(),
                )..add(
                    InitTypingLearning(
                      topic: topic,
                      selectedVocabularies: selectedVocabularies,
                    ),
                  ),
              ),
            ],
            child: TypingLearningPage(
              termLocale: topic.termLocale ?? '',
              definitionLocale: topic.definitionLocale ?? '',
              questionCount: selectedVocabularies.length,
            ),
          ),
        );
      case learningQuiz:
        final args = settings.arguments as DataMap;
        final topic = args['TOPIC'] as Topic;
        final selectedVocabularies = args['VOCABULARIES'] as List<Vocabulary>;
        return CustomPageRoute(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => QuizLearningBloc(
                  getIt.get<UpdateLearningStatisticsUseCase>(),
                )..add(
                    InitQuizLearning(
                      topic: topic,
                      selectedVocabularies: selectedVocabularies,
                    ),
                  ),
              )
            ],
            child: QuizLearningPage(
              termLocale: topic.termLocale ?? '',
              definitionLocale: topic.definitionLocale ?? '',
              questionCount: selectedVocabularies.length,
            ),
          ),
        );
      case learningFlashcard:
        final args = settings.arguments as DataMap;
        final topic = args['TOPIC'] as Topic;
        final selectedVocabularies = args['VOCABULARIES'] as List<Vocabulary>;
        return CustomPageRoute(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<FlashcardLearningBloc>(
                create: (_) => FlashcardLearningBloc(
                  getIt.get<UpdateLearningStatisticsUseCase>(),
                )..add(
                    InitFlashcardLearning(
                      topic: topic,
                      selectedVocabularies: selectedVocabularies,
                    ),
                  ),
              ),
            ],
            child: FlashcardLearningPage(
              termLocale: topic.termLocale ?? '',
              definitionLocale: topic.definitionLocale ?? '',
            ),
          ),
        );
      case topicDetails:
        final args = settings.arguments as DataMap;
        final topicId = args['TOPIC_ID'] as int;
        final termLanguage = args['TERM_LANGUAGE'] as String;
        final definitionLanguage = args['DEFINITION_LANGUAGE'] as String;
        final userId = args['USER_ID'] as int;
        return CustomPageRoute(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<TopicDetailsBloc>(
                create: (_) => TopicDetailsBloc(
                  getIt.get<GetTopicDetailsUseCase>(),
                  getIt.get<SaveTopicToLocalUseCase>(),
                  getIt.get<FavoriteVocabularyUseCase>(),
                  getIt.get<DeleteTopicUseCase>(),
                )..add(
                    GetTopicDetails(
                      topicId: topicId,
                      userId: userId,
                    ),
                  ),
              ),
            ],
            child: TopicDetailsPage(
              termLanguage: termLanguage,
              definitionLanguage: definitionLanguage,
            ),
          ),
        );
      case addFolderToTopic:
        final args = settings.arguments as DataMap;
        final topic = args['TOPIC'] as Topic;
        return CustomPageRoute(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<FolderToTopicBloc>(
                create: (_) => FolderToTopicBloc(
                  getIt.get(),
                  getIt.get(),
                  getIt.get(),
                )..add(
                    LoadAvailableFolders(topic: topic),
                  ),
              ),
            ],
            child: const AddFolderToTopicPage(),
          ),
        );
      case addTopicToFolder:
        final args = settings.arguments as DataMap;
        final folder = args['FOLDER'] as Folder;
        return MaterialPageRoute(
          builder: (_) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<AddTopicFolderBloc>(
                  create: (_) => AddTopicFolderBloc(
                    getIt.get(),
                    getIt.get(),
                  )..add(
                      GetAvailableTopics(
                        folder,
                      ),
                    ),
                ),
              ],
              child: const AddTopicToFolderPage(),
            );
          },
        );
      case folderDetail:
        final args = settings.arguments as DataMap;
        final folder = args['FOLDER'] as Folder;
        return CustomPageRoute(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<FolderDetailBloc>(
                create: (_) => FolderDetailBloc(
                  getIt.get(),
                  getIt.get(),
                  getIt.get(),
                  getIt.get(),
                )..add(
                    LoadFolderDetail(
                      folderId: folder.id!,
                    ),
                  ),
              ),
            ],
            child: FolderDetailPage(
              folder: folder,
            ),
          ),
        );
      case addTopic:
        final args = settings.arguments as DataMap;
        final addTopicBloc = args['ADD_TOPIC_BLOC'] as AddTopicBloc;
        final topic = args['TOPIC'] as Topic?;
        return MaterialPageRoute<AddTopicBloc?>(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: addTopicBloc,
              ),
            ],
            child: AddTopicPage(
              topic: topic,
            ),
          ),
        );
      case authentication:
        return MaterialPageRoute(
          builder: (context) => const AuthenticationPage(),
        );
      case register:
        return CustomPageRoute(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<RegisterBloc>(
                create: (_) => RegisterBloc(
                  getIt.get<RegistrationUseCase>(),
                ),
              ),
            ],
            child: const RegisterPage(),
          ),
        );
      case splash:
        return CustomPageRoute(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<SplashBloc>(
                create: (_) => SplashBloc(
                  getIt.get<GetConfigurationUseCase>(),
                ),
              ),
            ],
            child: const SplashPage(),
          ),
        );
      case login:
        return CustomPageRoute(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<LoginBloc>(
                create: (_) => LoginBloc(
                  getIt.get<LoginUseCase>(),
                  getIt.get<RequestOtpPassword>(),
                  getIt.get<VerifyOtp>(),
                  getIt.get<ResetPassword>(),
                  getIt.get<GoogleSignIn>(),
                  getIt.get<SocialLogin>(),
                ),
              ),
            ],
            child: const LoginPage(),
          ),
        );
      case onBoarding:
        return CustomPageRoute(
          child: const OnBoardingPage(),
        );
      case commonBottomNavbar:
        return CustomPageRoute(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<ProfileBloc>(
                create: (_) => ProfileBloc(
                  getIt.get<Logout>(),
                  getIt.get<ChangeDarkMode>(),
                  getIt.get<GetProfile>(),
                  getIt.get<ChangeLanguage>(),
                  getIt.get<ChangePushNotification>(),
                  getIt.get<ChangeSaveOffline>(),
                  getIt.get<PickProfileImage>(),
                  getIt.get<ChangeNameUseCase>(),
                  getIt.get<VerifyPasswordUseCase>(),
                  getIt.get<SendOtpNewEmailUseCase>(),
                  getIt.get<VerifyNewEmailUseCase>(),
                  getIt.get<ChangePasswordUseCase>(),
                  getIt.get<Connectivity>(),
                ),
              ),
              BlocProvider<TopicBloc>(
                create: (_) => TopicBloc(
                  getIt.get<GetUserTopicUseCase>(),
                  getIt.get<GetRecentlyLearnedUseCase>(),
                ),
              ),
              BlocProvider<FolderBloc>(
                create: (_) => FolderBloc(
                  getIt.get<AddFolderUseCase>(),
                  getIt.get<GetUserFoldersUseCase>(),
                ),
              ),
              BlocProvider<HomeBloc>(
                create: (_) => HomeBloc(
                  getIt.get<Connectivity>(),
                ),
              ),
              BlocProvider<SearchBloc>(
                create: (_) => SearchBloc(
                  getIt.get<FetchSearchTopicsUseCase>(),
                ),
              ),
            ],
            child: const MainBottomNavbar(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(),
        );
    }
  }
}
