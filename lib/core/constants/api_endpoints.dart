// ignore_for_file: constant_identifier_names

import 'package:cybersquare/globals.dart';


  final bool isProduction = Config.isProduction;
  final String url_base2 = Config.urlBase2;
  final String url_identity_service = Config.urlIdentityService;
  final String ulr_course_webview = Config.urlCourseWebview;
  final String url_activity_webview = Config.urlActivityWebview;
  final String url_cslab = Config.urlCsLab;
  final String url_base_image = Config.urlBaseImage;



const String ulr_socket = "wss://nodeapp.dev99lms.com";
//cs.dev99lms.com/candidate/#/candidateCourseViewWebView/:courseMappingId/:resourceId/:color/:courseId/:userLoginId/:token
// Prod	nodeapp.baabtra.com
const String url_domain ="companySubscription/MobileApp?companyId=580611aa265b597bf5cf2c09";
//const String url_login = "Login99lms/";
const String url_login = "lmsAuth/lmsToken/";
// const String url_logout = "logout/";
const String url_logout = "lmsAuth/logout/";
const String url_checkdomain = "lmsAuth/checkDomainExits/";
const String url_load_log_user_data = "lmsAuth/loadlogUserdata/";
const String url_forgot_password = "serv_fetch_otp_login_details";
const String url_sent_otp = "serv_send_otp_for_login";
const String url_otp_validation = "otp_validation_for_login";
const String url_side_menu = "menu/LoadMenus/";
const String url_courses_list = "course/loadCoursesForCandidates"; //getCourseSyllabus4CandidateView99lms //loadCoursesForCandidates
// const String url_courses_details = "getCourseSyllabus4CandidateView99lms/";
const String url_courses_details = "course/getCourseSyllabus4CandidateView99lms"; //"loadCourseDetails/";//
//const String url_favorite_course = "makeCourseFavorit/";
const String url_favorite_course = "course/makeCourseFavorit/";
const String url_get_academic_years = "/academicYear"; //company/companyid/academicYear
const String url_get_projects_list = "projects/getProjectsForCandidates/";
const String url_get_projects_details = "projects/getProjectDetails/";
const String url_get_progress_report_list = "getTermExamResultsForStudents/";
const String url_get_progress_report_details = "getUsersProgressReport/";
const String url_get_live_classroom_list = "liveClassRoom/fetchLiveSessionsForParticipants/";
const String url_get_digital_fest_list = "getEventsForCandidate?";
const String url_enroll_event = "createNewProjectForEvent/";
const String url_get_particular_event_details = "getEventDetails?";
const String url_academicYearId = "academicYearId=";
const String url_companyId = "companyId=";
const String url_userLoginId = "userLoginId=";
const String url_project_types = "getProjectCategories/";
const String url_edit_projectDetails = "projects/updateProjectParameterByCandidate/";
const String url_add_project_presentation = "projects/updateStudentFileUploadDetailsInProjectMapping/";
const String url_file_upload = "common/CourseFileUpload/";
const String url_get_technologies = "common/getTechnologies/";
const String url_get_materials = 'projects/ProjectMaterials/';
const String url_remove_file = "projects/removeProjectFile/";
const String url_update_project_cover_img = "projects/updateProjectCoverImage/";
const String url_get_classes = "loadStudentAgeCategoryClassRoom?";
const String url_get_divisions = "getDivisionDetails?";
const String url_search_users = "fetchUsersByDynamicSearch/";
// const String url_todo_pending_task = "getCandidateElementsByDate/";
const String url_todo_pending_task = "course/getCandidateElementsByDate";
const String url_edit_project_presentation = "projects/editProjectFile/";
// const String url_task_details = "getResourceCandidateSide/";
const String url_task_details = "course/getResourceCandidateSide";
//const String url_submit_task = "saveAnswer99lms/";
const String url_submit_task = "course/saveAnswer99lms/";

const String url_news_events = "events/fetchNewsAndEvents/";
const String url_activities = "activity/fnGetActivitiesForCandidates/";
const String url_get_user_profile = "students/loadProfileData/";
const String url_update_user_profile = "students/updateProfileDetails/";
const String url_change_password = "lmsAuth/changeuserPassword/";
const String url_get_nationality = "masters/nationality";
const String url_get_religion = "masters/religion";
const String url_get_mothertongue = "masters/mothertongue";
const String url_scorecard = "students/loadUserProfileDetails/";
const String url_academic_profile = "getAcademicProfilesForStudent/";
const String url_academic_profile_details = "getAcademicProfilesOnProfileId/";
// const String url_course_progress = "loadCandidateCourseStatus/";
const String url_course_progress = "course/loadCandidateCourseStatus";
const String url_scorecard_course_details = "course/fnViewDetailedScoreCard/?ucMappingId=";
const String url_subject_list = "masters/loadSubject/";
const String url_users_list = "students/LoadUsersUnderRole/";
const String url_get_activity = "activity/viewActivity/?activityMappingId=";

const String url_get_exam_result = "exam/getExamResults/";
const String url_update_profile_pic = "students/servUpdateProfilePicture/";

const String url_load_training_sessions = "trainer/studentSession";

//IMAGE PATH

const String path_project_cover_image = "projectCoverImages/";
const String path_project_image = "candidateProjectFiles/images";
//
//SIDE MENU

const String url_visual_coding = "https://vc2.cybersquare.org";
const String url_visual_coding_jr = "https://vc2jr.cybersquare.org";
const String url_app_inventor = "https://ai2.cybersquare.org";
const String url_geeky_bird = "https://99lmsfileuploadfolder.s3.ap-south-1.amazonaws.com/uploaded/games/demogames/maths/geekybirdNumeric/index.html";
const String url_geeky_bird_programable = "https://99lmsfileuploadfolder.s3.ap-south-1.amazonaws.com/uploaded/games/demogames/customizeGeekyBird/index.html";
const String url_code_combat = "https://abc.99lms.com/play";


const String state_cslab = "home.main.cslab";
const String state_profile = "home.main.userProfile";
const String state_live_classroom = "home.main.liveClassRoom";
const String state_my_activities = "home.main.myactivities";
const String state_scoreCard= "home.main.scoreCard";
const String state_progress_report = "home.main.progressreport";
const String state_program_game = "home.main.programGame";
const String state_param_visual_coding_jr = "vc2Jr";
const String state_param_app_inventor = "mitAI";
const String state_param_geeky_bird = "gBird";
const String state_param_geeky_bird_programable = "gBirdProgrammable";
const String state_projects = "home.main.projects";
const String state_academic_profile = "home.main.academicprofiles";
const String state_digital_fest = "home.main.events";
const String state_web_hosting = "home.main.view-web-hosting";
//
const String state_lms_ide = "home.main.lmsIde";