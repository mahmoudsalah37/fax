import 'package:fax/styles/page/all/app_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

List<dynamic> data, dataSearch;
GlobalKey<FormState> globalKeyAddAndUpdate, globalKeyloading;
bool isCheckAll;
AppConfig ac;
String strSearch, linkPath, modelName, pageName, selectedStatus;
const List<String> statusList = <String>['pending', 'completed'];
List<int> checks = List<int>();
ScrollController controllerBody;
const String strAddNewItem = 'Add New item';
const String strUpdateItem = 'Edit item';
const String strViewItem = 'View item';
double resWidthPage = 0.0;
DateFormat yearFormater = new DateFormat('yyyy');
DateFormat dataFormater = new DateFormat().add_yMd();
DateFormat monthFormater = new DateFormat('mm');
double get getBodyTableHeight {
  return ac.rH(100.0) - 210.0;
}

var scrollThumbBuilder = (Color backgroundColor,
    Animation<double> thumbAnimation,
    Animation<double> labelAnimation,
    double height,
    {BoxConstraints labelConstraints,
    Text labelText}) {
  return FadeTransition(
    opacity: thumbAnimation,
    child: Container(
      height: height,
      width: 20.0,
      color: backgroundColor,
    ),
  );
};
Color scrollbarColor = Colors.blue;

const String strSNo = 'S No',
    strContext = 'Context',
    strClassification = 'Classification',
    strHowToMonitor = 'How To Monitor',
    strComment = 'Comment',
    strInterestedParties = 'Interested Parties',
    strNeedsAndExpection = 'Needs And Expectation',
    strHowToMeet = 'How To Meet',
    strEvidence = 'Evidence',
    strAction = 'Action',
    strInitiatedDate = 'Initiated Date',
    strSource = 'Source',
    strDeadline = 'DeadLine',
    strResponsibility = 'Responsibility',
    strStatus = 'Status',
    strDate = 'Date',
    strRequiredChange = 'Required Change',
    strInitiatedBy = 'Initiated By',
    strReasonForChange = 'Reason For Change',
    strRequiedResources = 'Required Resources',
    strImpact = 'Impact',
    strActionToControl = 'Action To Control',
    strDesign = 'Design',
    strCode = 'Code',
    strReason = 'Reason',
    strImpactOnDesign = 'Impact On Design',
    strRequiredAction = 'Required Action',
    strApprovedBy = 'Approved By',
    strResultToBeAchieved = 'Result To Be Achieved',
    strReviewResult = 'Review Result',
    strVerificationResult = 'Verification Result',
    strValidationResult = 'Validation Result',
    strNecessaryAction = 'Necessary Action',
    strDesignCode = 'Design Code',
    strFunctionalAndPerformanceRequirements =
        'Functional And Performance Requirements',
    strInformationFromPreviousDesign = 'Information From Previous Design',
    strRegulatoryRequirements = 'Regulatory Requirements',
    strOther = 'Other',
    strInputVersusOutput = 'Input Versus Output',
    strRequiredMonitoring = 'Required Monitoring',
    strAcceptanceCriteria = 'Acceptance Criteria',
    strProduct = 'Product',
    strRequiredProcessStages = 'Required Process Stages',
    strRequiredVerificationActivities = 'Required Verification Activities',
    strRequiredValidationActivities = 'Required Validation Activities',
    strRequiredApproval = 'Required Approval',
    strRequiredControl = 'Required Control',
    strDepartment = 'Department',
    strObjective = 'Objective',
    strTargetDate = 'Target Date',
    strWhatToBeCommunicated = 'What To Be Communicated',
    strWhen = 'When',
    strToWhom = 'To Whom',
    strByWhom = 'By Whom',
    strHow = 'How',
    strRiskDescription = 'Risk Description',
    strImpactSignificance = 'Impact & Significance',
    strLikelihood = 'Likelihood',
    strConsequence = 'Consequence',
    strRate = 'Rate',
    strRiskOwner = 'Risk Owner',
    strMitigationAction = 'Mitigation Action',
    strIssueDate = 'Issue Date',
    strDocumentName = 'Document Name',
    strDocumentNumber = 'Document Number',
    strDocumentType = 'Document Type',
    strMedia = 'Media',
    strVersionReversionNumber = 'Version/Reversion Number',
    strRevisionDate = 'Revision Date',
    strPreparedBy = 'Prepared By',
    strDestribution = 'Destribution',
    strProviderName = 'Provider Name',
    strServiceProduct = 'Service/Product',
    strContactPerson = 'Contact Person',
    strEmail = 'Email',
    strTel = 'Tel',
    strEvaluationDate = 'Evaluation Date',
    strQualityOfProductOrService = 'Quality Of Product Or Service',
    strAdherenceToDeliverySchedule = 'Adherence To Delivery Schedule',
    strPricingCompetitiveness = 'Pricing Competitiveness',
    strCredibility = 'Credibility',
    strResponsivenessAndCooperation = 'Responsiveness And Cooperation',
    strSupplierAuditResult = 'Supplier Audit Result',
    strEvaluatedBy = 'Evaluated By',
    strTotalScore = 'Total Score',
    strAdditional1 = 'Additional1',
    strRate1 = 'Rate1',
    strAdditional2 = 'Additional2',
    strRate2 = 'Rate2',
    strSourceOfNonConformities = 'Source Of Non Conformities',
    strNcDescription = 'NcDescription',
    strRootCause = 'Root Cause',
    strCorrectiveAction = 'Corrective Action',
    strPlannedAuditDate = 'Planned Audit Date',
    strAuditSubject = 'Audit Subject',
    strAuditCertiria = 'Audit Certiria',
    strAuditee = 'Auditee',
    strAuditor = 'Auditor',
    strFinding = 'Finding',
    strCorrection = 'Correction',
    strVerificationOfCorrectiveAction = 'Verification Of Corrective Action',
    strEmployeeName = 'Employee Name',
    strAuditingQualifications = 'Auditing Qualifications',
    strQuestionnaireTitle = 'Questionnaire Title',
    strCustomerName = 'Customer Name',
    strFeedbackDate = 'Feedback Date',
    strResponseDate = 'Response Date',
    strComplaintsubject = 'Complaint subject',
    strReceivedDate = 'Received Date',
    strMeetingInputs = 'Meeting Inputs',
    strMeetingOutputActions = 'Meeting Output/Actions',
    strMeetingAgenda = 'Meeting Agenda',
    strAgreedActions = 'Agreed Actions',
    strEquipmentName = 'Equipment Name',
    strModelNumber = 'Model Number',
    strIdentificationNumber = 'Identification Number',
    strLastCalibrationDate = 'Last Calibration Date',
    strCalibratedBy = 'Calibrated By',
    strNextCalibrationDate = 'Next Calibration Date',
    strPreventiveMaintenanceDate = 'Preventive Maintenance Date',
    strRemarks = 'Remarks';
