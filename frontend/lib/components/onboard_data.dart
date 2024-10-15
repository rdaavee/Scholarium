import 'package:isHKolarium/components/onboard_info.dart';
import 'package:isHKolarium/config/assets/app_images.dart';

class OnboardData {
  List<OnboardInfo> items = [
    OnboardInfo(
      title: "Welcome to isHKolarium",
      description:
          "Easily manage your scholar duties in one place. Access your schedule, track your progress, and stay organized with a streamlined platform built for both scholars and teachers.",
      image: AppImages.onboardingImgFirst,
    ),
    OnboardInfo(
      title: "Effortless Scheduling & Tracking",
      description:
          "View your duty schedules at a glance and mark tasks as completed in just a few taps. Stay on top of your responsibilities and maintain a clear record of your achievements.",
      image: AppImages.onboardingImgSecond,
    ),
    OnboardInfo(
      title: "Ready to Get Started?",
      description:
          "Simplify your scholar duties with isHKolarium. Let’s get you set up for success and start managing your tasks efficiently today!",
      image: AppImages.onboardingImgThird,
    ),
  ];
}
