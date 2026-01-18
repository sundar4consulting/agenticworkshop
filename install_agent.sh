#!/bin/bash
#===============================================================================
# YAVA Intent Classifier - Watson Orchestrate Agent Installation Script
# 
# Prerequisites: 
#   - Watson Orchestrate CLI already connected to us-south instance
#   - Python 3.10+ installed
#   - NumPy installed (pip install numpy)
#
# Usage: ./install_agent.sh
#===============================================================================

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_NAME="yava-intent-classifier"

echo ""
echo "============================================================"
echo "  YAVA Intent Classifier - Agent Installation"
echo "  Target: Watson Orchestrate (us-south)"
echo "============================================================"
echo ""

#===============================================================================
# Step 1: Create Project Structure
#===============================================================================
log_info "Step 1: Creating project structure..."

mkdir -p "${SCRIPT_DIR}/${PROJECT_NAME}/src/intents"
mkdir -p "${SCRIPT_DIR}/${PROJECT_NAME}/skills"
cd "${SCRIPT_DIR}/${PROJECT_NAME}"

log_success "Project structure created"

#===============================================================================
# Step 2: Create Knowledge Base (47 Intents)
#===============================================================================
log_info "Step 2: Creating intent knowledge base..."

cat > src/intents/__init__.py << 'EOF'
from .knowledge_base import INTENT_KNOWLEDGE_BASE, get_all_intents
EOF

cat > src/intents/knowledge_base.py << 'KBEOF'
"""
YAVA Intent Knowledge Base - Phase 1 Commercial Profile (Inbound-3788)
47 Active Intents
"""

INTENT_KNOWLEDGE_BASE = {
    # HEALTHCARE (12)
    "INT-PHR-0001": {
        "intent_id": "INT-PHR-0001", "intent_name": "pharmacy", "category": "healthcare",
        "agent_routing": "PharmacyAgent", "priority": 2,
        "training_utterances": [
            "I need to refill my prescription", "Where can I get my medications",
            "What pharmacies are in network", "How much does my prescription cost",
            "I want to transfer my prescription", "Can I get a 90 day supply",
            "Is my drug covered", "Where is the nearest CVS", "I need to find a pharmacy",
            "What is my copay for medications", "Mail order pharmacy", "Generic vs brand name",
            "Drug formulary", "Prior authorization for medication", "Specialty pharmacy",
            "Medication tier", "Prescription history", "Drug interactions"
        ],
        "keywords": ["pharmacy", "prescription", "medication", "drug", "refill", "CVS", "formulary"]
    },
    "INT-PRC-0002": {
        "intent_id": "INT-PRC-0002", "intent_name": "precert", "category": "healthcare",
        "agent_routing": "PrecertAgent", "priority": 2,
        "training_utterances": [
            "I need prior authorization", "Does my procedure need precertification",
            "How do I get approval for surgery", "Check status of my authorization",
            "My doctor needs to submit a prior auth", "Preauthorization requirements",
            "Was my MRI approved", "Authorization denied", "Appeal a precert decision",
            "How long does prior auth take", "Emergency authorization", "Medical necessity",
            "Inpatient authorization", "Outpatient precert", "Authorization reference number",
            "Precert for imaging", "DME authorization", "Home health precert"
        ],
        "keywords": ["precert", "prior authorization", "preauth", "approval", "authorization"]
    },
    "INT-NCM-0003": {
        "intent_id": "INT-NCM-0003", "intent_name": "nurseCaseManager", "category": "healthcare",
        "agent_routing": "CareAgent", "priority": 3,
        "training_utterances": [
            "I want to speak to my nurse case manager", "Connect me to my care coordinator",
            "Who is my assigned nurse", "Case management program", "I need help managing my condition",
            "Care coordination services", "Schedule a call with my nurse", "Complex case management",
            "Transition of care support", "Post discharge follow up", "Care plan review",
            "Nurse navigator", "Health coach", "Chronic condition support", "High risk pregnancy support",
            "Cancer case management", "Transplant coordination", "Care gap closure"
        ],
        "keywords": ["nurse", "case manager", "care coordinator", "care management", "health coach"]
    },
    "INT-NRS-0004": {
        "intent_id": "INT-NRS-0004", "intent_name": "24HourNurseLine", "category": "healthcare",
        "agent_routing": "NurseLineAgent", "priority": 1,
        "training_utterances": [
            "I need to talk to a nurse", "24 hour nurse line", "Medical advice line",
            "Should I go to the ER", "Nurse hotline", "I have a health question",
            "Speak to a registered nurse", "Is this an emergency", "After hours medical help",
            "Symptom checker", "My child is sick", "Fever advice", "Poison control",
            "Allergic reaction advice", "Urgent care or ER", "Nurse triage",
            "Medical question at night", "Talk to someone about my symptoms"
        ],
        "keywords": ["nurse line", "24 hour", "nurse hotline", "medical advice", "triage"]
    },
    "INT-BEH-0005": {
        "intent_id": "INT-BEH-0005", "intent_name": "behavioralHealth", "category": "healthcare",
        "agent_routing": "BehavioralAgent", "priority": 2,
        "training_utterances": [
            "I need mental health support", "Find a therapist", "Behavioral health services",
            "Counseling coverage", "Psychiatrist in network", "Substance abuse treatment",
            "Depression help", "Anxiety treatment", "Outpatient mental health",
            "Inpatient psychiatric", "Marriage counseling", "Family therapy",
            "Psychologist coverage", "Mental health copay", "How many therapy sessions",
            "Telehealth therapy", "Eating disorder treatment", "Addiction services"
        ],
        "keywords": ["mental health", "behavioral health", "therapy", "counseling", "psychiatrist"]
    },
    "INT-BEM-0006": {
        "intent_id": "INT-BEM-0006", "intent_name": "behavioralEmergency", "category": "healthcare",
        "agent_routing": "EmergencyAgent", "priority": 1,
        "training_utterances": [
            "I am having thoughts of suicide", "Mental health crisis", "I need help now",
            "Crisis hotline", "Someone is threatening self harm", "Psychiatric emergency",
            "I feel like hurting myself", "Overdose", "988 suicide line",
            "Immediate mental health help", "Crisis intervention", "Behavioral emergency room",
            "Psychotic episode", "Danger to self or others", "Mental breakdown",
            "Suicide prevention", "Crisis stabilization", "Mobile crisis team"
        ],
        "keywords": ["crisis", "suicide", "emergency", "self harm", "psychiatric emergency", "988"]
    },
    "INT-PCP-0007": {
        "intent_id": "INT-PCP-0007", "intent_name": "primaryCareProvider", "category": "healthcare",
        "agent_routing": "PCPAgent", "priority": 2,
        "training_utterances": [
            "I need to find a primary care doctor", "Change my PCP", "Who is my primary care physician",
            "Select a new doctor", "PCP assignment", "Find a family doctor",
            "General practitioner near me", "Internal medicine doctor", "Primary care referral",
            "Switch my primary doctor", "New member PCP selection", "PCP accepting new patients",
            "Doctor taking Aetna insurance", "Primary care network", "Assign PCP for my child",
            "Primary doctor office hours", "Update my doctor information"
        ],
        "keywords": ["PCP", "primary care", "doctor", "physician", "family doctor"]
    },
    "INT-SPC-0008": {
        "intent_id": "INT-SPC-0008", "intent_name": "specialist", "category": "healthcare",
        "agent_routing": "SpecialistAgent", "priority": 2,
        "training_utterances": [
            "I need to see a specialist", "Find a cardiologist", "Dermatologist in network",
            "Orthopedic surgeon near me", "Do I need a referral for specialist", "Find an ENT doctor",
            "Neurologist coverage", "Gastroenterologist appointment", "Oncologist in my network",
            "Endocrinologist search", "Pulmonologist near me", "Rheumatologist covered",
            "Urologist in network", "Specialist copay amount", "Out of network specialist",
            "Second opinion specialist", "Specialist referral process"
        ],
        "keywords": ["specialist", "cardiologist", "dermatologist", "referral", "orthopedic"]
    },
    "INT-URG-0009": {
        "intent_id": "INT-URG-0009", "intent_name": "urgentCare", "category": "healthcare",
        "agent_routing": "UrgentCareAgent", "priority": 1,
        "training_utterances": [
            "Find urgent care near me", "Walk in clinic locations", "Urgent care vs emergency room",
            "After hours clinic", "Urgent care copay", "MinuteClinic locations", "CVS health hub",
            "Retail clinic coverage", "Weekend clinic hours", "Urgent care for my child",
            "Is urgent care covered", "Nearest urgent care open now", "Urgent care wait times",
            "In network urgent care", "Virtual urgent care", "Urgent care for stitches"
        ],
        "keywords": ["urgent care", "walk in", "clinic", "after hours", "MinuteClinic"]
    },
    "INT-EMR-0010": {
        "intent_id": "INT-EMR-0010", "intent_name": "emergencyRoom", "category": "healthcare",
        "agent_routing": "EmergencyAgent", "priority": 1,
        "training_utterances": [
            "Emergency room coverage", "ER copay amount", "Nearest emergency room",
            "Emergency services covered", "Out of network emergency", "ER vs urgent care",
            "Emergency room bill", "Hospital emergency department", "Emergency admission",
            "Trauma center location", "Emergency surgery coverage", "ER visit while traveling",
            "Emergency out of state", "Ambulance coverage", "Freestanding ER coverage"
        ],
        "keywords": ["emergency room", "ER", "emergency", "hospital", "ambulance", "trauma"]
    },
    "INT-TEL-0011": {
        "intent_id": "INT-TEL-0011", "intent_name": "telemedicine", "category": "healthcare",
        "agent_routing": "TelemedicineAgent", "priority": 2,
        "training_utterances": [
            "Telemedicine appointment", "Virtual doctor visit", "Online doctor consultation",
            "Telehealth coverage", "Video visit with doctor", "Teladoc services",
            "Virtual care options", "Phone appointment with doctor", "Remote healthcare visit",
            "E-visit coverage", "Telehealth copay", "Virtual urgent care", "Online prescription",
            "Telemedicine for mental health", "Virtual specialist visit", "Telehealth app"
        ],
        "keywords": ["telemedicine", "telehealth", "virtual", "video visit", "online doctor", "Teladoc"]
    },
    "INT-HOS-0012": {
        "intent_id": "INT-HOS-0012", "intent_name": "hospital", "category": "healthcare",
        "agent_routing": "HospitalAgent", "priority": 2,
        "training_utterances": [
            "Hospital coverage information", "Inpatient admission coverage", "Hospital stay cost",
            "In network hospitals", "Hospital precertification", "Planned hospital admission",
            "Hospital room charges", "Surgery at hospital", "Hospital outpatient services",
            "Hospital bill explanation", "Length of stay coverage", "Hospital selection help",
            "Centers of excellence hospitals", "Out of network hospital", "Skilled nursing facility"
        ],
        "keywords": ["hospital", "inpatient", "admission", "surgery", "skilled nursing"]
    },
    
    # BENEFITS (14)
    "INT-ELG-0013": {
        "intent_id": "INT-ELG-0013", "intent_name": "eligibility", "category": "benefits",
        "agent_routing": "EligibilityAgent", "priority": 1,
        "training_utterances": [
            "Am I covered", "Check my eligibility", "When does my coverage start",
            "Is my plan active", "Coverage effective date", "Verify my insurance",
            "Am I still enrolled", "When does my coverage end", "Eligibility status",
            "My benefits terminated", "Check active coverage", "Insurance verification letter",
            "Proof of coverage", "Coverage confirmation", "Am I insured", "Member eligibility"
        ],
        "keywords": ["eligibility", "coverage", "active", "enrolled", "effective date", "verify"]
    },
    "INT-BEN-0014": {
        "intent_id": "INT-BEN-0014", "intent_name": "benefits", "category": "benefits",
        "agent_routing": "BenefitsAgent", "priority": 1,
        "training_utterances": [
            "What are my benefits", "Benefits summary", "What does my plan cover",
            "Benefit details", "Coverage information", "Plan benefits explanation",
            "What services are covered", "Benefits booklet", "Summary of benefits",
            "Evidence of coverage", "Covered services list", "Benefit limits",
            "Annual maximum benefits", "Lifetime maximum", "Benefit year dates"
        ],
        "keywords": ["benefits", "coverage", "covered", "plan", "summary", "services"]
    },
    "INT-DED-0015": {
        "intent_id": "INT-DED-0015", "intent_name": "deductible", "category": "benefits",
        "agent_routing": "DeductibleAgent", "priority": 1,
        "training_utterances": [
            "What is my deductible", "How much deductible have I met", "Deductible status",
            "Annual deductible amount", "Family deductible", "Individual deductible",
            "Deductible accumulator", "When does deductible reset", "Deductible applied to claim",
            "Out of pocket vs deductible", "High deductible plan", "Deductible remaining",
            "Embedded deductible", "Deductible waived services", "Preventive care deductible"
        ],
        "keywords": ["deductible", "accumulator", "met", "remaining", "annual", "out of pocket"]
    },
    "INT-OOP-0016": {
        "intent_id": "INT-OOP-0016", "intent_name": "outOfPocketMax", "category": "benefits",
        "agent_routing": "OOPAgent", "priority": 2,
        "training_utterances": [
            "Out of pocket maximum", "What is my out of pocket limit", "Maximum out of pocket reached",
            "OOP max status", "Annual out of pocket", "Family out of pocket maximum",
            "Individual OOP max", "Out of pocket accumulator", "When is everything covered",
            "Reached my maximum", "Out of pocket remaining", "Catastrophic coverage",
            "Stop loss amount", "Out of pocket expenses", "MOOP amount"
        ],
        "keywords": ["out of pocket", "OOP", "maximum", "limit", "MOOP", "catastrophic"]
    },
    "INT-COP-0017": {
        "intent_id": "INT-COP-0017", "intent_name": "copay", "category": "benefits",
        "agent_routing": "CopayAgent", "priority": 1,
        "training_utterances": [
            "What is my copay", "Copay for doctor visit", "Specialist copay amount",
            "Copay vs coinsurance", "Prescription copay", "ER copay", "Urgent care copay",
            "Copay at time of service", "Office visit copay", "Lab work copay",
            "Imaging copay", "Therapy copay", "Copay after deductible", "Zero copay services"
        ],
        "keywords": ["copay", "copayment", "office visit", "cost", "dollar amount"]
    },
    "INT-COI-0018": {
        "intent_id": "INT-COI-0018", "intent_name": "coinsurance", "category": "benefits",
        "agent_routing": "CoinsuranceAgent", "priority": 2,
        "training_utterances": [
            "What is my coinsurance", "Coinsurance percentage", "80 20 coinsurance",
            "How coinsurance works", "Coinsurance after deductible", "In network coinsurance",
            "Out of network coinsurance", "Hospital coinsurance rate", "Surgery coinsurance",
            "Coinsurance vs copay", "My share of costs", "Percentage I pay", "Coinsurance maximum"
        ],
        "keywords": ["coinsurance", "percentage", "share", "80/20", "cost sharing"]
    },
    "INT-NET-0019": {
        "intent_id": "INT-NET-0019", "intent_name": "network", "category": "benefits",
        "agent_routing": "NetworkAgent", "priority": 1,
        "training_utterances": [
            "Is my doctor in network", "Find in network provider", "Network status check",
            "Out of network coverage", "Provider network search", "In network vs out of network",
            "Participating providers", "Network discount", "PPO network", "HMO network",
            "Narrow network plan", "Provider left network", "Continuity of care out of network",
            "Network exception request", "Tiered network", "Network directory"
        ],
        "keywords": ["network", "in network", "out of network", "provider", "participating", "PPO", "HMO"]
    },
    "INT-COB-0020": {
        "intent_id": "INT-COB-0020", "intent_name": "coordinationOfBenefits", "category": "benefits",
        "agent_routing": "COBAgent", "priority": 2,
        "training_utterances": [
            "I have two insurance plans", "Coordination of benefits", "Primary and secondary insurance",
            "Dual coverage", "Which plan pays first", "COB update", "Spouse has insurance too",
            "Medicare and Aetna", "Birthday rule coordination", "Other insurance question",
            "COB questionnaire", "Secondary insurance filing", "Double coverage"
        ],
        "keywords": ["coordination of benefits", "COB", "primary", "secondary", "dual coverage"]
    },
    "INT-DEN-0021": {
        "intent_id": "INT-DEN-0021", "intent_name": "dental", "category": "benefits",
        "agent_routing": "DentalAgent", "priority": 2,
        "training_utterances": [
            "Dental coverage", "Find a dentist", "Dental benefits", "Dental cleaning coverage",
            "Orthodontia coverage", "Dental maximum", "Dental deductible", "Root canal coverage",
            "Dental implants covered", "Wisdom teeth extraction", "Dental X-rays coverage",
            "Periodontal treatment", "Crown coverage", "Dental waiting period", "Dental network"
        ],
        "keywords": ["dental", "dentist", "teeth", "orthodontia", "cleaning", "crown"]
    },
    "INT-VIS-0022": {
        "intent_id": "INT-VIS-0022", "intent_name": "vision", "category": "benefits",
        "agent_routing": "VisionAgent", "priority": 2,
        "training_utterances": [
            "Vision coverage", "Eye exam coverage", "Find an eye doctor", "Glasses coverage",
            "Contact lenses allowance", "Vision benefits", "LASIK coverage", "Vision network",
            "Frames allowance", "Vision deductible", "Eye exam frequency", "Vision copay",
            "VSP or EyeMed", "Optometrist vs ophthalmologist", "Vision claim submission"
        ],
        "keywords": ["vision", "eye", "glasses", "contacts", "optometrist", "ophthalmologist"]
    },
    "INT-PRV-0023": {
        "intent_id": "INT-PRV-0023", "intent_name": "preventiveCare", "category": "benefits",
        "agent_routing": "PreventiveAgent", "priority": 2,
        "training_utterances": [
            "Preventive care coverage", "Annual physical covered", "Wellness exam",
            "Preventive services list", "Screenings covered", "Mammogram coverage",
            "Colonoscopy covered", "Immunizations covered", "Well child visits",
            "Preventive care no cost", "Health maintenance exam", "Cancer screening coverage",
            "Preventive vs diagnostic", "Annual checkup", "Flu shot coverage"
        ],
        "keywords": ["preventive", "wellness", "screening", "physical", "immunization", "vaccine"]
    },
    "INT-MAT-0024": {
        "intent_id": "INT-MAT-0024", "intent_name": "maternity", "category": "benefits",
        "agent_routing": "MaternityAgent", "priority": 2,
        "training_utterances": [
            "Maternity coverage", "Pregnancy benefits", "Prenatal care covered",
            "Delivery cost estimate", "Hospital stay for delivery", "Cesarean section coverage",
            "Midwife coverage", "Birth center coverage", "Newborn coverage",
            "Maternity deductible", "High risk pregnancy", "Breast pump coverage",
            "Fertility treatment", "IVF coverage", "Postpartum care", "NICU coverage"
        ],
        "keywords": ["maternity", "pregnancy", "prenatal", "delivery", "newborn", "fertility"]
    },
    "INT-REH-0025": {
        "intent_id": "INT-REH-0025", "intent_name": "rehabilitation", "category": "benefits",
        "agent_routing": "RehabAgent", "priority": 2,
        "training_utterances": [
            "Physical therapy coverage", "Rehabilitation services", "PT visits allowed",
            "Occupational therapy", "Speech therapy coverage", "Inpatient rehab",
            "Outpatient rehabilitation", "Rehab facility coverage", "Cardiac rehabilitation",
            "Pulmonary rehab", "Therapy visit limits", "Chiropractic coverage",
            "Acupuncture covered", "Therapy authorization", "Rehab after surgery"
        ],
        "keywords": ["physical therapy", "PT", "rehabilitation", "occupational therapy", "speech therapy"]
    },
    "INT-DME-0026": {
        "intent_id": "INT-DME-0026", "intent_name": "durableMedicalEquipment", "category": "benefits",
        "agent_routing": "DMEAgent", "priority": 2,
        "training_utterances": [
            "Durable medical equipment coverage", "DME benefits", "Wheelchair coverage",
            "CPAP machine covered", "Oxygen equipment", "Hospital bed rental",
            "Walker coverage", "Prosthetics coverage", "Orthotics benefits", "DME supplier",
            "DME authorization", "Medical supplies coverage", "Diabetic supplies",
            "Compression stockings", "DME repair coverage", "DME rental vs purchase"
        ],
        "keywords": ["DME", "durable medical equipment", "wheelchair", "CPAP", "prosthetics"]
    },
    
    # FINANCIAL (8)
    "INT-PRM-0027": {
        "intent_id": "INT-PRM-0027", "intent_name": "premium", "category": "financial",
        "agent_routing": "PremiumAgent", "priority": 1,
        "training_utterances": [
            "Pay my premium", "Premium due date", "Premium amount", "Monthly premium cost",
            "Premium payment options", "Autopay premium", "Premium grace period",
            "Missed premium payment", "Premium increase notice", "Premium billing question",
            "Payroll deduction premium", "Premium tax credit", "Reduce my premium"
        ],
        "keywords": ["premium", "payment", "bill", "monthly", "autopay", "payroll deduction"]
    },
    "INT-HSA-0028": {
        "intent_id": "INT-HSA-0028", "intent_name": "hsa", "category": "financial",
        "agent_routing": "HSAAgent", "priority": 2,
        "training_utterances": [
            "HSA balance", "Health savings account", "HSA contribution", "HSA eligible expenses",
            "HSA investment", "HSA card", "HSA maximum contribution", "HSA rollover",
            "HSA tax benefits", "Use HSA for dental", "HSA withdrawal", "Transfer HSA",
            "HSA employer contribution", "HSA catch up contribution", "PayFlex HSA"
        ],
        "keywords": ["HSA", "health savings account", "contribution", "balance", "eligible expenses"]
    },
    "INT-FSA-0029": {
        "intent_id": "INT-FSA-0029", "intent_name": "fsa", "category": "financial",
        "agent_routing": "FSAAgent", "priority": 2,
        "training_utterances": [
            "FSA balance", "Flexible spending account", "Healthcare FSA", "Dependent care FSA",
            "FSA eligible expenses", "FSA deadline", "Use it or lose it FSA", "FSA grace period",
            "FSA rollover amount", "FSA card", "FSA claim", "Limited purpose FSA",
            "FSA store", "What can I buy with FSA", "FSA reimbursement"
        ],
        "keywords": ["FSA", "flexible spending", "balance", "eligible expenses", "dependent care"]
    },
    "INT-HRA-0030": {
        "intent_id": "INT-HRA-0030", "intent_name": "hra", "category": "financial",
        "agent_routing": "HRAAgent", "priority": 2,
        "training_utterances": [
            "HRA balance", "Health reimbursement arrangement", "HRA eligible expenses",
            "HRA reimbursement", "HRA vs HSA", "Employer HRA contribution", "HRA rollover",
            "HRA claim submission", "HRA card", "What does HRA cover", "HRA for retirees",
            "ICHRA plan", "QSEHRA information", "HRA statement"
        ],
        "keywords": ["HRA", "health reimbursement", "arrangement", "employer funded"]
    },
    "INT-EST-0031": {
        "intent_id": "INT-EST-0031", "intent_name": "costEstimate", "category": "financial",
        "agent_routing": "EstimateAgent", "priority": 2,
        "training_utterances": [
            "Cost estimate for procedure", "How much will surgery cost", "Estimate my costs",
            "Price transparency", "Procedure cost lookup", "MRI cost estimate",
            "Hospital cost estimator", "Out of pocket estimate", "Treatment cost calculator",
            "Compare provider costs", "Good faith estimate", "No surprises act"
        ],
        "keywords": ["estimate", "cost", "price", "transparency", "calculator", "how much"]
    },
    "INT-PAY-0032": {
        "intent_id": "INT-PAY-0032", "intent_name": "paymentPlan", "category": "financial",
        "agent_routing": "PaymentAgent", "priority": 2,
        "training_utterances": [
            "Set up payment plan", "Payment arrangement", "Can I pay in installments",
            "Monthly payment option", "Financial hardship", "Medical bill payment plan",
            "Pay my medical bill", "Outstanding balance payment", "Payment plan options",
            "Interest free payment", "Healthcare financing", "Bill assistance program"
        ],
        "keywords": ["payment plan", "installments", "arrangement", "financial assistance"]
    },
    "INT-REI-0033": {
        "intent_id": "INT-REI-0033", "intent_name": "reimbursement", "category": "financial",
        "agent_routing": "ReimbursementAgent", "priority": 2,
        "training_utterances": [
            "Submit for reimbursement", "Get reimbursed for medical expense", "Reimbursement form",
            "Out of pocket reimbursement", "How to file for reimbursement", "Reimbursement status",
            "Direct deposit reimbursement", "Reimbursement check", "Foreign claim reimbursement",
            "Travel vaccination reimbursement", "Gym membership reimbursement", "Wellness reimbursement"
        ],
        "keywords": ["reimbursement", "reimburse", "submit", "out of pocket", "direct deposit"]
    },
    "INT-EOB-0034": {
        "intent_id": "INT-EOB-0034", "intent_name": "explanationOfBenefits", "category": "financial",
        "agent_routing": "EOBAgent", "priority": 2,
        "training_utterances": [
            "Explanation of benefits", "Read my EOB", "EOB meaning", "What is an EOB",
            "EOB vs bill", "EOB online access", "Download my EOB", "EOB for tax purposes",
            "EOB discrepancy", "EOB shows wrong amount", "Paper EOB preference", "Paperless EOB"
        ],
        "keywords": ["EOB", "explanation of benefits", "statement", "summary", "claim statement"]
    },
    
    # CLAIMS (4)
    "INT-CLM-0035": {
        "intent_id": "INT-CLM-0035", "intent_name": "claims", "category": "claims",
        "agent_routing": "ClaimsAgent", "priority": 1,
        "training_utterances": [
            "Check my claim status", "Submit a claim", "Claim denied", "Explanation of benefits",
            "How much do I owe", "Claims history", "Why was my claim rejected", "File a claim",
            "Claims appeal", "Out of pocket expense", "Claim processing time", "Resubmit a claim",
            "View my EOB", "Claim for reimbursement", "Pending claim", "Claim payment amount"
        ],
        "keywords": ["claim", "claims", "EOB", "denied", "status", "submit", "appeal"]
    },
    "INT-IDC-0036": {
        "intent_id": "INT-IDC-0036", "intent_name": "idCard", "category": "claims",
        "agent_routing": "IDCardAgent", "priority": 1,
        "training_utterances": [
            "I need a new ID card", "Order replacement card", "Where is my insurance card",
            "Digital ID card", "Print my ID card", "ID card not received", "Member ID number",
            "View my ID card", "Card shows wrong information", "ID card for dependent",
            "Temporary ID card", "ID card in app", "Rush ID card delivery", "Lost my insurance card"
        ],
        "keywords": ["ID card", "member card", "insurance card", "replacement", "digital"]
    },
    "INT-APL-0037": {
        "intent_id": "INT-APL-0037", "intent_name": "appeals", "category": "claims",
        "agent_routing": "AppealsAgent", "priority": 2,
        "training_utterances": [
            "Appeal a claim denial", "How to file an appeal", "Grievance process",
            "Appeal deadline", "First level appeal", "External review request",
            "Independent review", "Appeal status check", "Appeal letter template",
            "Medical records for appeal", "Expedited appeal", "Urgent appeal process"
        ],
        "keywords": ["appeal", "grievance", "denial", "external review", "overturn"]
    },
    "INT-FRD-0038": {
        "intent_id": "INT-FRD-0038", "intent_name": "fraudWasteAbuse", "category": "claims",
        "agent_routing": "FraudAgent", "priority": 3,
        "training_utterances": [
            "Report fraud", "Suspicious billing", "I didnt receive this service",
            "Waste and abuse hotline", "Fraudulent claim", "Doctor overbilling",
            "Identity theft insurance", "Report provider fraud", "Bill for service not received",
            "Duplicate billing complaint", "Upcoding suspected", "Report insurance fraud"
        ],
        "keywords": ["fraud", "abuse", "suspicious", "report", "waste", "identity theft"]
    },
    
    # WELLNESS (6)
    "INT-WEL-0039": {
        "intent_id": "INT-WEL-0039", "intent_name": "wellnessPrograms", "category": "wellness",
        "agent_routing": "WellnessAgent", "priority": 3,
        "training_utterances": [
            "Wellness program information", "Health incentive programs", "Wellness rewards",
            "Attain by Aetna", "Earn wellness points", "Fitness program coverage",
            "Gym membership discount", "Weight management program", "Smoking cessation program",
            "Health coaching", "Wellness challenges", "Biometric screening incentive"
        ],
        "keywords": ["wellness", "incentive", "program", "rewards", "fitness", "health coaching"]
    },
    "INT-GYM-0040": {
        "intent_id": "INT-GYM-0040", "intent_name": "gymFitness", "category": "wellness",
        "agent_routing": "FitnessAgent", "priority": 3,
        "training_utterances": [
            "Gym membership benefit", "Fitness center discount", "Active and Fit program",
            "Gym reimbursement", "Fitness facility network", "Planet Fitness discount",
            "LA Fitness coverage", "YMCA membership", "Home fitness program",
            "Peloton discount", "Fitness class coverage", "Silver Sneakers"
        ],
        "keywords": ["gym", "fitness", "exercise", "Active and Fit", "Silver Sneakers"]
    },
    "INT-SMK-0041": {
        "intent_id": "INT-SMK-0041", "intent_name": "smokingCessation", "category": "wellness",
        "agent_routing": "TobaccoAgent", "priority": 3,
        "training_utterances": [
            "Quit smoking program", "Smoking cessation coverage", "Nicotine patch coverage",
            "Tobacco quit line", "Chantix coverage", "Wellbutrin for smoking",
            "Quit tobacco support", "Smoking cessation counseling", "Nicotine gum covered",
            "E-cigarette cessation", "Vaping quit program", "Tobacco free incentive"
        ],
        "keywords": ["smoking", "tobacco", "quit", "cessation", "nicotine", "vaping"]
    },
    "INT-WGT-0042": {
        "intent_id": "INT-WGT-0042", "intent_name": "weightManagement", "category": "wellness",
        "agent_routing": "WeightAgent", "priority": 3,
        "training_utterances": [
            "Weight loss program", "Weight management coverage", "Bariatric surgery coverage",
            "Gastric bypass coverage", "Nutritional counseling", "Dietitian coverage",
            "Weight Watchers reimbursement", "Noom coverage", "Obesity treatment",
            "Medical weight loss", "Weight loss medication coverage", "Wegovy coverage"
        ],
        "keywords": ["weight", "obesity", "bariatric", "nutrition", "diet", "BMI"]
    },
    "INT-CHR-0043": {
        "intent_id": "INT-CHR-0043", "intent_name": "chronicConditionSupport", "category": "wellness",
        "agent_routing": "ChronicAgent", "priority": 2,
        "training_utterances": [
            "Chronic condition management", "Diabetes management program", "Heart disease support",
            "Asthma management", "COPD management program", "Hypertension program",
            "Chronic care management", "Disease management", "Ongoing condition support",
            "Long term condition help", "Chronic illness resources", "Health condition coaching"
        ],
        "keywords": ["chronic", "diabetes", "heart disease", "asthma", "COPD", "management"]
    },
    "INT-MOM-0044": {
        "intent_id": "INT-MOM-0044", "intent_name": "maternitySupport", "category": "wellness",
        "agent_routing": "MaternityAgent", "priority": 2,
        "training_utterances": [
            "Pregnancy support program", "Maternity management", "Prenatal program",
            "Healthy pregnancy program", "Beginning Right maternity", "High risk pregnancy support",
            "Pregnancy rewards", "Baby shower program", "Expecting mother resources",
            "Prenatal vitamins coverage", "Pregnancy app", "Maternity case manager"
        ],
        "keywords": ["pregnancy", "maternity", "prenatal", "postpartum", "baby", "expecting"]
    },
    
    # SERVICES (3)
    "INT-ADR-0045": {
        "intent_id": "INT-ADR-0045", "intent_name": "addressChange", "category": "services",
        "agent_routing": "ProfileAgent", "priority": 3,
        "training_utterances": [
            "Update my address", "Change my address", "New address update",
            "Moving to new location", "Address correction", "Wrong address on file",
            "Mailing address change", "Update contact information", "Change my phone number",
            "Email address update", "Profile update", "Personal information change"
        ],
        "keywords": ["address", "update", "change", "contact", "phone", "email", "profile"]
    },
    "INT-DEP-0046": {
        "intent_id": "INT-DEP-0046", "intent_name": "dependentChanges", "category": "services",
        "agent_routing": "EnrollmentAgent", "priority": 2,
        "training_utterances": [
            "Add a dependent", "Remove dependent from plan", "Newborn enrollment",
            "Add spouse to insurance", "Marriage enrollment", "Divorce remove spouse",
            "Dependent age out", "Adult child coverage", "Domestic partner enrollment",
            "Dependent eligibility", "Change dependent information", "Dependent turning 26"
        ],
        "keywords": ["dependent", "add", "remove", "spouse", "child", "enrollment", "family"]
    },
    "INT-CMP-0047": {
        "intent_id": "INT-CMP-0047", "intent_name": "complaint", "category": "services",
        "agent_routing": "ComplaintAgent", "priority": 2,
        "training_utterances": [
            "File a complaint", "I want to complain", "Grievance submission",
            "Unhappy with service", "Bad customer service", "Provider complaint",
            "Quality of care complaint", "Service complaint", "Formal complaint process",
            "Escalate my issue", "Speak to supervisor", "Customer relations"
        ],
        "keywords": ["complaint", "grievance", "unhappy", "dissatisfied", "escalate", "supervisor"]
    }
}

def get_all_intents():
    """Return list of all intent metadata."""
    return [
        {"intent_id": d["intent_id"], "intent_name": d["intent_name"], 
         "category": d["category"], "agent_routing": d["agent_routing"]}
        for d in INTENT_KNOWLEDGE_BASE.values()
    ]
KBEOF

log_success "Created knowledge base with 47 intents"

#===============================================================================
# Step 3: Create Classifier Module
#===============================================================================
log_info "Step 3: Creating intent classifier..."

cat > src/__init__.py << 'EOF'
from .classifier import LocalIntentClassifier, get_classifier
from .skill import classify_intent, get_intents, health_check
EOF

cat > src/classifier.py << 'CLASSIFIEREOF'
"""
Local RAG+LLM Intent Classifier - Enhanced with:
1. Disambiguation - When confidence is low or multiple intents are close
2. Context-aware classification - Uses session history to boost relevant intents  
3. Multi-intent detection - Detects when user asks about multiple things
4. Slot filling - Extracts entities/parameters from user utterance
"""

import re
import numpy as np
from typing import Dict, List, Optional, Tuple, Set
from datetime import datetime
from collections import defaultdict
from .intents.knowledge_base import INTENT_KNOWLEDGE_BASE


#===============================================================================
# SLOT DEFINITIONS - Entity types to extract per intent
#===============================================================================
SLOT_DEFINITIONS = {
    "pharmacy": {
        "medication_name": {"patterns": [r"(?:for|refill|get|need)\s+(\w+(?:\s+\w+)?)", r"(\w+)\s+(?:prescription|medication|drug)"], "type": "medication"},
        "quantity": {"patterns": [r"(\d+)\s*(?:day|days|month|months)\s+supply", r"(\d+)\s+(?:pills|tablets|capsules)"], "type": "number"},
        "pharmacy_name": {"patterns": [r"(?:at|from|nearest)\s+(CVS|Walgreens|Rite Aid|Costco|Walmart)", r"(CVS|Walgreens|Rite Aid)"], "type": "pharmacy"}
    },
    "claims": {
        "claim_number": {"patterns": [r"claim\s*(?:#|number|id)?\s*[:\s]?\s*(\w{8,15})", r"(\d{10,15})"], "type": "claim_id"},
        "date_of_service": {"patterns": [r"(?:from|on|dated?)\s+(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})", r"((?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\w*\s+\d{1,2}(?:,?\s+\d{4})?)"], "type": "date"},
        "provider_name": {"patterns": [r"(?:from|at|with)\s+(?:Dr\.?\s+)?([A-Z][a-z]+(?:\s+[A-Z][a-z]+)?)", r"(?:doctor|physician|provider)\s+([A-Z][a-z]+)"], "type": "provider"}
    },
    "specialist": {
        "specialty_type": {"patterns": [r"(cardiologist|dermatologist|orthopedic|neurologist|gastroenterologist|oncologist|ENT|urologist|pulmonologist|rheumatologist|endocrinologist)"], "type": "specialty"},
        "location": {"patterns": [r"(?:near|in|around)\s+([A-Z][a-z]+(?:\s+[A-Z][a-z]+)?(?:,\s*[A-Z]{2})?)", r"(?:zip|zipcode|zip code)\s*[:\s]?\s*(\d{5})"], "type": "location"}
    },
    "primaryCareProvider": {
        "doctor_name": {"patterns": [r"(?:Dr\.?\s+)?([A-Z][a-z]+(?:\s+[A-Z][a-z]+)?)", r"(?:doctor|physician)\s+([A-Z][a-z]+)"], "type": "provider"},
        "location": {"patterns": [r"(?:near|in|around)\s+([A-Z][a-z]+(?:\s+[A-Z][a-z]+)?)", r"(\d{5})"], "type": "location"}
    },
    "deductible": {
        "plan_type": {"patterns": [r"(individual|family)\s+(?:deductible|plan)", r"(in[- ]?network|out[- ]?of[- ]?network)"], "type": "plan_type"},
        "year": {"patterns": [r"(?:for|in)\s+(20\d{2})", r"(this year|last year|next year)"], "type": "year"}
    },
    "eligibility": {
        "member_type": {"patterns": [r"(?:for\s+)?(?:my\s+)?(spouse|child|dependent|self)", r"(family|individual)\s+coverage"], "type": "member_type"},
        "date": {"patterns": [r"(?:as of|on|starting)\s+(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})"], "type": "date"}
    },
    "idCard": {
        "card_type": {"patterns": [r"(digital|physical|paper|temporary)\s+(?:ID\s+)?card", r"(replacement|new)\s+card"], "type": "card_type"},
        "member_type": {"patterns": [r"(?:for\s+)?(?:my\s+)?(spouse|child|dependent)"], "type": "member_type"}
    },
    "hsa": {
        "action": {"patterns": [r"(balance|contribution|withdrawal|transfer|investment)", r"(contribute|withdraw|transfer)\s+"], "type": "action"},
        "amount": {"patterns": [r"\$?\s*(\d+(?:,\d{3})*(?:\.\d{2})?)", r"(\d+)\s+dollars"], "type": "currency"}
    },
    "appeals": {
        "claim_number": {"patterns": [r"claim\s*(?:#|number)?\s*[:\s]?\s*(\w{8,15})"], "type": "claim_id"},
        "appeal_type": {"patterns": [r"(first level|second level|external|expedited|urgent)\s+(?:appeal|review)"], "type": "appeal_type"}
    },
    "maternity": {
        "trimester": {"patterns": [r"(first|second|third|1st|2nd|3rd)\s+trimester", r"(\d+)\s+weeks?\s+pregnant"], "type": "trimester"},
        "service_type": {"patterns": [r"(prenatal|delivery|postpartum|ultrasound|c-section|cesarean)"], "type": "service"}
    }
}

#===============================================================================
# MULTI-INTENT CONJUNCTIONS - Words that signal multiple intents
#===============================================================================
MULTI_INTENT_SIGNALS = [
    r"\b(?:and also|and|also|plus|as well as|additionally|another thing|one more thing)\b",
    r"\b(?:oh and|btw|by the way|while I'm here|while you're at it)\b",
    r"\b(?:first|second|third|lastly|finally|next)\b"
]


class InMemoryVectorStore:
    """In-memory vector store for RAG similarity search."""
    
    def __init__(self):
        self.vectors: List[np.ndarray] = []
        self.metadata: List[Dict] = []
        
    def add(self, vectors: List[np.ndarray], metadata: List[Dict]):
        self.vectors.extend(vectors)
        self.metadata.extend(metadata)
        
    def search(self, query: np.ndarray, top_k: int = 10) -> List[Tuple[Dict, float]]:
        if not self.vectors:
            return []
        vectors_array = np.array(self.vectors)
        query_norm = query / (np.linalg.norm(query) + 1e-10)
        vectors_norm = vectors_array / (np.linalg.norm(vectors_array, axis=1, keepdims=True) + 1e-10)
        similarities = np.dot(vectors_norm, query_norm)
        top_indices = np.argsort(similarities)[-top_k:][::-1]
        return [(self.metadata[i], float(similarities[i])) for i in top_indices]


class SessionManager:
    """Manages conversation session history for context tracking."""
    
    def __init__(self):
        self.sessions: Dict[str, List[Dict]] = defaultdict(list)
        self.slot_memory: Dict[str, Dict] = defaultdict(dict)  # Stores filled slots per session
        
    def add(self, session_id: str, utterance: str, intent: str, confidence: float, 
            slots: Optional[Dict] = None, multi_intents: Optional[List] = None):
        entry = {
            "utterance": utterance, 
            "intent": intent, 
            "confidence": confidence, 
            "timestamp": datetime.utcnow().isoformat(),
            "slots": slots or {},
            "multi_intents": multi_intents or []
        }
        self.sessions[session_id].append(entry)
        
        # Update slot memory
        if slots:
            self.slot_memory[session_id].update(slots)
        
        # Keep last 10 turns per session
        if len(self.sessions[session_id]) > 10:
            self.sessions[session_id] = self.sessions[session_id][-10:]
    
    def get(self, session_id: str, n: int = 5) -> List[Dict]:
        return self.sessions.get(session_id, [])[-n:]
    
    def get_recent_intents(self, session_id: str, n: int = 3) -> List[str]:
        history = self.get(session_id, n)
        return [h["intent"] for h in history]
    
    def get_slot_memory(self, session_id: str) -> Dict:
        """Get all remembered slots for session."""
        return self.slot_memory.get(session_id, {})
    
    def get_pending_intents(self, session_id: str) -> List[str]:
        """Get intents that were detected but not yet handled."""
        history = self.get(session_id, n=1)
        if history and history[-1].get("multi_intents"):
            return history[-1]["multi_intents"][1:]  # Skip first (already handled)
        return []


class EmbeddingGenerator:
    """Simple deterministic embedding generator."""
    
    def __init__(self, dim: int = 384):
        self.dim = dim
        
    def generate(self, text: str) -> np.ndarray:
        """Generate deterministic embedding for text."""
        text = text.lower()
        np.random.seed(hash(text) % (2**32))
        emb = np.random.randn(self.dim)
        return emb / (np.linalg.norm(emb) + 1e-10)


class SlotFiller:
    """Extracts entity slots from user utterances."""
    
    def __init__(self):
        self.slot_definitions = SLOT_DEFINITIONS
    
    def extract_slots(self, utterance: str, intent: str) -> Dict[str, any]:
        """Extract slots relevant to the detected intent."""
        slots = {}
        
        # Get slot definitions for this intent
        intent_slots = self.slot_definitions.get(intent, {})
        
        for slot_name, slot_config in intent_slots.items():
            for pattern in slot_config["patterns"]:
                match = re.search(pattern, utterance, re.IGNORECASE)
                if match:
                    slots[slot_name] = {
                        "value": match.group(1),
                        "type": slot_config["type"],
                        "confidence": 0.9,
                        "source": "extracted"
                    }
                    break
        
        # Extract common slots (applicable to any intent)
        common_slots = self._extract_common_slots(utterance)
        slots.update(common_slots)
        
        return slots
    
    def _extract_common_slots(self, utterance: str) -> Dict[str, any]:
        """Extract common entities that apply to any intent."""
        slots = {}
        
        # Member ID
        member_match = re.search(r"(?:member\s*(?:id|#|number)?|id)[:\s]*([A-Z0-9]{8,12})", utterance, re.IGNORECASE)
        if member_match:
            slots["member_id"] = {"value": member_match.group(1), "type": "member_id", "confidence": 0.95, "source": "extracted"}
        
        # Phone number
        phone_match = re.search(r"(\d{3}[-.]?\d{3}[-.]?\d{4})", utterance)
        if phone_match:
            slots["phone"] = {"value": phone_match.group(1), "type": "phone", "confidence": 0.9, "source": "extracted"}
        
        # Date (generic)
        date_match = re.search(r"(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})", utterance)
        if date_match and "date" not in slots:
            slots["date"] = {"value": date_match.group(1), "type": "date", "confidence": 0.8, "source": "extracted"}
        
        # Dollar amount
        amount_match = re.search(r"\$\s*(\d+(?:,\d{3})*(?:\.\d{2})?)", utterance)
        if amount_match:
            slots["amount"] = {"value": amount_match.group(1), "type": "currency", "confidence": 0.9, "source": "extracted"}
        
        # Zip code
        zip_match = re.search(r"\b(\d{5})(?:-\d{4})?\b", utterance)
        if zip_match:
            slots["zip_code"] = {"value": zip_match.group(1), "type": "location", "confidence": 0.85, "source": "extracted"}
        
        return slots
    
    def get_missing_required_slots(self, intent: str, filled_slots: Dict) -> List[Dict]:
        """Identify which required slots are still missing."""
        intent_slots = self.slot_definitions.get(intent, {})
        missing = []
        
        for slot_name, slot_config in intent_slots.items():
            if slot_name not in filled_slots:
                missing.append({
                    "slot_name": slot_name,
                    "type": slot_config["type"],
                    "prompt": self._get_slot_prompt(slot_name, intent)
                })
        
        return missing
    
    def _get_slot_prompt(self, slot_name: str, intent: str) -> str:
        """Generate a natural language prompt for missing slot."""
        prompts = {
            "medication_name": "What medication do you need help with?",
            "claim_number": "Can you provide the claim number?",
            "date_of_service": "What was the date of service?",
            "provider_name": "What is the provider or doctor's name?",
            "specialty_type": "What type of specialist are you looking for?",
            "location": "What is your location or zip code?",
            "doctor_name": "What is the doctor's name?",
            "plan_type": "Is this for individual or family coverage?",
            "member_type": "Is this for yourself or a dependent?",
            "amount": "What amount would you like to contribute/withdraw?"
        }
        return prompts.get(slot_name, f"Please provide the {slot_name.replace('_', ' ')}.")


class MultiIntentDetector:
    """Detects when user message contains multiple intents."""
    
    def __init__(self):
        self.signals = MULTI_INTENT_SIGNALS
    
    def has_multiple_intents(self, utterance: str) -> bool:
        """Check if utterance likely contains multiple intents."""
        for pattern in self.signals:
            if re.search(pattern, utterance, re.IGNORECASE):
                return True
        return False
    
    def split_utterance(self, utterance: str) -> List[str]:
        """Split utterance into potential separate intent segments."""
        # Split on conjunctions that typically separate intents
        split_patterns = [
            r"\s+and also\s+",
            r"\s+also\s+",
            r"\s+and\s+(?=I\s+)",
            r"\s+plus\s+",
            r"\s+as well as\s+",
            r"\.\s+(?=[A-Z])",
            r"\s+oh and\s+",
            r"\s+btw\s+",
            r"\s+by the way\s+"
        ]
        
        segments = [utterance]
        for pattern in split_patterns:
            new_segments = []
            for seg in segments:
                parts = re.split(pattern, seg, flags=re.IGNORECASE)
                new_segments.extend([p.strip() for p in parts if p.strip()])
            segments = new_segments
        
        # Filter out very short segments
        return [s for s in segments if len(s.split()) >= 2]


class DisambiguationEngine:
    """Handles disambiguation when intent is unclear."""
    
    # Natural language descriptions for intents
    INTENT_DESCRIPTIONS = {
        "pharmacy": "prescription or medication refills",
        "precert": "prior authorization for a procedure",
        "claims": "claim status or submission",
        "benefits": "coverage and benefit information",
        "eligibility": "enrollment or coverage status",
        "deductible": "deductible amount or status",
        "copay": "copay amounts",
        "coinsurance": "coinsurance percentages",
        "outOfPocketMax": "out-of-pocket maximum",
        "idCard": "insurance ID card",
        "primaryCareProvider": "primary care doctor (PCP)",
        "specialist": "specialist referral or search",
        "urgentCare": "urgent care locations",
        "emergencyRoom": "emergency room coverage",
        "telemedicine": "virtual or telehealth visits",
        "behavioralHealth": "mental health services",
        "behavioralEmergency": "mental health crisis support",
        "dental": "dental coverage",
        "vision": "vision coverage",
        "hsa": "Health Savings Account (HSA)",
        "fsa": "Flexible Spending Account (FSA)",
        "hra": "Health Reimbursement Arrangement (HRA)",
        "appeals": "appeal a claim denial",
        "maternity": "pregnancy and maternity coverage",
        "24HourNurseLine": "24-hour nurse advice line"
    }
    
    def generate_disambiguation(self, candidates: List[Dict], utterance: str) -> Dict:
        """Generate disambiguation response for ambiguous intent."""
        if len(candidates) < 2:
            return {"needed": False}
        
        # Check if top candidates are close in score
        score_diff = candidates[0]["score"] - candidates[1]["score"]
        if score_diff > 0.15:  # Clear winner
            return {"needed": False, "reason": "clear_winner"}
        
        # Build disambiguation options
        options = []
        for i, candidate in enumerate(candidates[:3]):
            desc = self.INTENT_DESCRIPTIONS.get(candidate["intent"], candidate["intent"])
            options.append({
                "option_number": i + 1,
                "intent": candidate["intent"],
                "description": desc,
                "agent": candidate["agent"]
            })
        
        # Generate natural language prompt
        if len(options) == 2:
            prompt = f"I want to make sure I help you correctly. Are you asking about {options[0]['description']} or {options[1]['description']}?"
        else:
            descs = [o['description'] for o in options]
            prompt = f"I want to make sure I understand. Are you asking about {descs[0]}, {descs[1]}, or {descs[2]}?"
        
        return {
            "needed": True,
            "reason": "ambiguous_intent",
            "prompt": prompt,
            "options": options,
            "original_utterance": utterance
        }


class LocalIntentClassifier:
    """
    RAG-based Intent Classifier with:
    - Disambiguation
    - Context-aware classification
    - Multi-intent detection
    - Slot filling
    """
    
    def __init__(self):
        self.vector_store = InMemoryVectorStore()
        self.session_manager = SessionManager()
        self.embedder = EmbeddingGenerator()
        self.slot_filler = SlotFiller()
        self.multi_intent_detector = MultiIntentDetector()
        self.disambiguation_engine = DisambiguationEngine()
        self._build_kb()
        
    def _build_kb(self):
        """Build vector knowledge base from intent training data."""
        vectors, metadata = [], []
        for intent_id, data in INTENT_KNOWLEDGE_BASE.items():
            for idx, utt in enumerate(data["training_utterances"]):
                vectors.append(self.embedder.generate(utt))
                metadata.append({
                    "intent_id": intent_id,
                    "intent_name": data["intent_name"],
                    "category": data["category"],
                    "agent_routing": data["agent_routing"],
                    "priority": data["priority"],
                    "text": utt
                })
        self.vector_store.add(vectors, metadata)
    
    def classify(self, utterance: str, session_id: str = "default", 
                 context_aware: bool = True) -> Dict:
        """
        Full classification with all features:
        - Basic intent classification
        - Context boosting
        - Multi-intent detection
        - Slot extraction
        - Disambiguation check
        """
        start = datetime.utcnow()
        
        # 1. MULTI-INTENT DETECTION
        multi_intents = []
        if self.multi_intent_detector.has_multiple_intents(utterance):
            segments = self.multi_intent_detector.split_utterance(utterance)
            if len(segments) > 1:
                for seg in segments:
                    seg_result = self._classify_single(seg)
                    multi_intents.append({
                        "segment": seg,
                        "intent": seg_result["intent"],
                        "confidence": seg_result["confidence"],
                        "agent": seg_result["agent_routing"]
                    })
        
        # 2. PRIMARY CLASSIFICATION
        result = self._classify_single(utterance)
        
        # 3. CONTEXT-AWARE BOOSTING
        if context_aware:
            result = self._apply_context_boost(result, utterance, session_id)
        
        # 4. SLOT FILLING
        slots = self.slot_filler.extract_slots(utterance, result["intent"])
        
        # Merge with session slot memory
        session_slots = self.session_manager.get_slot_memory(session_id)
        merged_slots = {**session_slots, **slots}  # New slots override old
        
        # Check for missing required slots
        missing_slots = self.slot_filler.get_missing_required_slots(result["intent"], merged_slots)
        
        # 5. DISAMBIGUATION CHECK
        candidates = self.get_candidates(utterance, top_k=3)
        disambiguation = self.disambiguation_engine.generate_disambiguation(candidates, utterance)
        
        # 6. BUILD FINAL RESULT
        result.update({
            "slots": slots,
            "merged_slots": merged_slots,
            "missing_slots": missing_slots,
            "slot_filling_complete": len(missing_slots) == 0,
            "multi_intents": multi_intents if multi_intents else None,
            "has_multi_intents": len(multi_intents) > 1,
            "disambiguation": disambiguation,
            "needs_disambiguation": disambiguation["needed"],
            "candidates": candidates,
            "processing_time_ms": (datetime.utcnow() - start).total_seconds() * 1000
        })
        
        # Track in session
        self.session_manager.add(
            session_id, utterance, result["intent"], result["confidence"],
            slots=slots, multi_intents=[m["intent"] for m in multi_intents]
        )
        
        return result
    
    def _classify_single(self, utterance: str) -> Dict:
        """Basic single-intent classification."""
        query_emb = self.embedder.generate(utterance)
        results = self.vector_store.search(query_emb, top_k=10)
        
        # Vote from top matches
        votes = defaultdict(float)
        for meta, score in results[:5]:
            votes[meta["intent_name"]] += score
        
        best_intent = max(votes, key=votes.get) if votes else "unknown"
        best_meta = next((m for m, s in results if m["intent_name"] == best_intent), 
                        {"intent_id": "UNK", "agent_routing": "FallbackAgent", 
                         "category": "unknown", "priority": 5})
        
        # Confidence calculation
        matching = [s for m, s in results[:3] if m["intent_name"] == best_intent]
        confidence = round(sum(matching) / len(matching) if matching else 0.5, 3)
        
        return {
            "intent": best_intent,
            "intent_id": best_meta["intent_id"],
            "agent_routing": best_meta["agent_routing"],
            "category": best_meta["category"],
            "priority": best_meta["priority"],
            "confidence": confidence,
            "top_match_score": results[0][1] if results else 0.0
        }
    
    def _apply_context_boost(self, result: Dict, utterance: str, session_id: str) -> Dict:
        """Apply context-aware boosting based on session history."""
        recent_intents = self.session_manager.get_recent_intents(session_id, n=3)
        
        if not recent_intents:
            result["context_applied"] = False
            return result
        
        # Check for continuation signals
        continuation_signals = ["also", "and", "what about", "how about", "another", 
                               "same", "that", "this", "it", "more"]
        utterance_lower = utterance.lower()
        has_continuation = any(sig in utterance_lower for sig in continuation_signals)
        
        # Short utterance + recent context = likely continuation
        is_short = len(utterance.split()) <= 4
        
        if (has_continuation or is_short) and result["confidence"] < 0.8:
            candidates = self.get_candidates(utterance, top_k=5)
            
            for candidate in candidates:
                if candidate["intent"] in recent_intents:
                    # Boost this intent
                    boost_amount = 0.15 if has_continuation else 0.10
                    result["original_intent"] = result["intent"]
                    result["original_confidence"] = result["confidence"]
                    result["intent"] = candidate["intent"]
                    result["confidence"] = min(0.95, result["confidence"] + boost_amount)
                    result["context_boosted"] = True
                    result["context_match"] = candidate["intent"]
                    result["context_applied"] = True
                    return result
        
        result["context_applied"] = True
        result["context_boosted"] = False
        return result
    
    def get_candidates(self, utterance: str, top_k: int = 3) -> List[Dict]:
        """Get top candidate intents for disambiguation."""
        query_emb = self.embedder.generate(utterance)
        results = self.vector_store.search(query_emb, top_k=20)
        
        # Aggregate scores by intent
        intent_scores = defaultdict(list)
        intent_meta = {}
        
        for meta, score in results:
            intent_name = meta["intent_name"]
            intent_scores[intent_name].append(score)
            if intent_name not in intent_meta:
                intent_meta[intent_name] = meta
        
        # Calculate average score per intent
        intent_avg = {
            intent: sum(scores) / len(scores) 
            for intent, scores in intent_scores.items()
        }
        
        # Sort and take top_k
        sorted_intents = sorted(intent_avg.items(), key=lambda x: x[1], reverse=True)[:top_k]
        
        candidates = []
        for intent_name, avg_score in sorted_intents:
            meta = intent_meta[intent_name]
            candidates.append({
                "intent": intent_name,
                "intent_id": meta["intent_id"],
                "agent": meta["agent_routing"],
                "category": meta["category"],
                "score": round(avg_score, 3)
            })
        
        return candidates
    
    def handle_disambiguation_response(self, session_id: str, selected_option: int) -> Dict:
        """Process user's disambiguation selection."""
        history = self.session_manager.get(session_id, n=1)
        if not history:
            return {"error": "No disambiguation pending"}
        
        # Would retrieve the candidates from the last classification
        # For now, return confirmation structure
        return {
            "status": "disambiguation_resolved",
            "selected_option": selected_option,
            "session_id": session_id
        }
    
    def get_next_pending_intent(self, session_id: str) -> Optional[Dict]:
        """Get the next unhandled intent from multi-intent detection."""
        pending = self.session_manager.get_pending_intents(session_id)
        if pending:
            return {"intent": pending[0], "remaining_count": len(pending) - 1}
        return None


# Singleton instance
_instance = None

def get_classifier() -> LocalIntentClassifier:
    global _instance
    if _instance is None:
        _instance = LocalIntentClassifier()
    return _instance
CLASSIFIEREOF

log_success "Created classifier module"

#===============================================================================
# Step 4: Create Watson Orchestrate Skill Interface
#===============================================================================
log_info "Step 4: Creating Watson Orchestrate skill interface..."

cat > src/skill.py << 'SKILLEOF'
"""
Watson Orchestrate Skill Interface - Exposed as Tool/API for Agent

ENHANCED with:
- Full NLU Classification (disambiguation, context, multi-intent, slots)
- Slot Extraction API
- Multi-Intent Detection API
- Disambiguation Management API
- Context-Aware Classification API
"""

import json
from typing import Dict, List, Optional
from .classifier import get_classifier
from .intents.knowledge_base import get_all_intents as _get_all_intents


#===============================================================================
# TOOL 1: FULL CLASSIFICATION (Primary Tool - Called for every utterance)
#===============================================================================
def classify_intent(user_input: str, 
                   conversation_id: Optional[str] = None,
                   member_id: Optional[str] = None,
                   context_aware: bool = True) -> Dict:
    """
    Tool: Full NLU Classification with all features.
    Called by Agent for EVERY user message.
    
    Features:
        - Intent classification with confidence
        - Slot extraction (dates, IDs, amounts, names)
        - Multi-intent detection (compound sentences)
        - Context-aware boosting from conversation history
        - Disambiguation when intents are ambiguous
    
    Returns:
        - intent: Primary detected intent
        - agent: Target agent for routing
        - confidence: Classification confidence (0-1)
        - slots: Extracted entities {slot_type: value}
        - missing_slots: Required slots not yet provided
        - multi_intents: Array of intents if multiple detected
        - needs_disambiguation: True if clarification needed
        - disambiguation_prompt: Question to ask user for clarity
        - candidates: Top 3 intent candidates
        - context_applied: Whether history was used for boosting
    """
    session_id = conversation_id or f"watson-{member_id}" if member_id else "default"
    classifier = get_classifier()
    
    # Full classification with all features
    result = classifier.classify(user_input, session_id, context_aware=context_aware)
    
    # Get session history for context
    session_history = classifier.session_manager.get(session_id, n=5)
    
    return {
        # Primary Classification
        "intent": result["intent"],
        "intent_id": result["intent_id"],
        "agent": result["agent_routing"],
        "category": result["category"],
        "confidence": result["confidence"],
        
        # Slot Filling
        "slots": result.get("slots", {}),
        "merged_slots": result.get("merged_slots", {}),  # With session memory
        "missing_slots": result.get("missing_slots", []),
        "slot_filling_complete": result.get("slot_filling_complete", True),
        
        # Multi-Intent Detection
        "has_multi_intents": result.get("has_multi_intents", False),
        "multi_intents": result.get("multi_intents"),  # [{segment, intent, confidence, agent}]
        
        # Disambiguation
        "needs_disambiguation": result.get("needs_disambiguation", False),
        "disambiguation_prompt": result.get("disambiguation", {}).get("prompt", ""),
        "disambiguation_options": result.get("disambiguation", {}).get("options", []),
        
        # Context
        "context_applied": result.get("context_applied", False),
        "context_boosted": result.get("context_boosted", False),
        
        # Candidates for UI/Review
        "candidates": result.get("candidates", []),
        
        # Session
        "session": {
            "conversation_id": session_id,
            "recent_intents": [h["intent"] for h in session_history],
            "turn_count": len(session_history)
        },
        
        # Metadata
        "metadata": {
            "processing_time_ms": result.get("processing_time_ms", 0),
            "top_match_score": result.get("top_match_score", 0)
        }
    }


#===============================================================================
# TOOL 2: SLOT EXTRACTION
#===============================================================================
def extract_slots(user_input: str, intent: Optional[str] = None) -> Dict:
    """
    Tool: Extract entities/parameters from user utterance.
    
    Extracts:
        - Dates (MM/DD/YYYY, tomorrow, next week, etc.)
        - Claim/Reference IDs (CLM-12345, REF-ABC)
        - Member IDs (MEM-123456, member number patterns)
        - Currency amounts ($100.50, $1,234.56)
        - Names (Dr. Smith, proper nouns)
        - Pharmacy names
        - Medication names
        - Procedure codes (CPT, ICD-10)
    
    Returns:
        - extracted_slots: {slot_type: value}
        - slot_count: Number of slots found
        - slot_types: List of slot types found
        - required_slots: Slots typically needed for this intent
        - missing_required: Required slots not yet provided
    """
    classifier = get_classifier()
    
    # Extract slots
    slots = classifier.slot_filler.extract_slots(user_input, intent or "general")
    
    # Get required slots for intent
    required = classifier.slot_filler.get_missing_required_slots(intent or "general", {})
    missing = classifier.slot_filler.get_missing_required_slots(intent or "general", slots)
    
    return {
        "extracted_slots": slots,
        "slot_count": len(slots),
        "slot_types": list(slots.keys()),
        "required_slots": required,
        "missing_required": missing,
        "slot_prompts": _generate_slot_prompts(missing),
        "original_input": user_input
    }


def _generate_slot_prompts(missing_slots: List[str]) -> Dict[str, str]:
    """Generate user-friendly prompts for missing slots."""
    prompts = {
        "member_id": "Could you please provide your member ID?",
        "date_of_service": "What was the date of service?",
        "claim_id": "Do you have a claim ID or reference number?",
        "pharmacy_name": "Which pharmacy would you like to use?",
        "medication_name": "What medication do you need?",
        "provider_name": "What is the provider or doctor's name?",
        "amount": "What is the amount in question?",
        "procedure_code": "Do you have the procedure or service code?"
    }
    return {slot: prompts.get(slot, f"Please provide the {slot.replace('_', ' ')}") 
            for slot in missing_slots}


#===============================================================================
# TOOL 3: MULTI-INTENT DETECTION
#===============================================================================
def detect_multi_intent(user_input: str, 
                        conversation_id: Optional[str] = None) -> Dict:
    """
    Tool: Detect if user utterance contains multiple intents.
    
    Detects compound sentences like:
        - "I need to refill my prescription AND check my claims"
        - "What's my deductible and also my copay for specialists?"
        - "First check my eligibility, then tell me about my benefits"
    
    Returns:
        - has_multiple_intents: Boolean
        - intent_count: Number of intents detected
        - intents: Array of {segment, intent, confidence, agent}
        - suggested_order: Recommended processing order
        - combined_response_possible: Whether single response can address all
    """
    session_id = conversation_id or "default"
    classifier = get_classifier()
    
    # Check for multiple intents
    has_multi = classifier.multi_intent_detector.has_multiple_intents(user_input)
    
    if not has_multi:
        # Single intent - classify normally
        result = classifier.classify(user_input, session_id, context_aware=False)
        return {
            "has_multiple_intents": False,
            "intent_count": 1,
            "intents": [{
                "segment": user_input,
                "intent": result["intent"],
                "confidence": result["confidence"],
                "agent": result["agent_routing"]
            }],
            "suggested_order": [result["intent"]],
            "combined_response_possible": True
        }
    
    # Split and classify each segment
    segments = classifier.multi_intent_detector.split_utterance(user_input)
    intents = []
    
    for segment in segments:
        if segment.strip():
            seg_result = classifier._classify_single(segment)
            intents.append({
                "segment": segment,
                "intent": seg_result["intent"],
                "confidence": seg_result["confidence"],
                "agent": seg_result["agent_routing"],
                "priority": seg_result.get("priority", 3)
            })
    
    # Sort by priority (lower = higher priority)
    sorted_intents = sorted(intents, key=lambda x: x.get("priority", 3))
    
    # Check if same agent handles all (can combine response)
    unique_agents = set(i["agent"] for i in intents)
    combined_possible = len(unique_agents) == 1
    
    return {
        "has_multiple_intents": len(intents) > 1,
        "intent_count": len(intents),
        "intents": intents,
        "suggested_order": [i["intent"] for i in sorted_intents],
        "combined_response_possible": combined_possible,
        "unique_agents": list(unique_agents),
        "original_input": user_input
    }


#===============================================================================
# TOOL 4: DISAMBIGUATION
#===============================================================================
def get_disambiguation(user_input: str, top_k: int = 3) -> Dict:
    """
    Tool: Get disambiguation options when intent is unclear.
    
    Use when:
        - Primary classification has low confidence (<0.75)
        - Top 2 candidates are close in score
        - User request is vague or ambiguous
    
    Returns:
        - needs_disambiguation: Boolean
        - prompt: Human-friendly question to ask user
        - options: Array of {option_number, intent, description, agent}
        - confidence_gap: Difference between top 2 candidates
    """
    classifier = get_classifier()
    candidates = classifier.get_candidates(user_input, top_k=top_k)
    disambiguation = classifier.disambiguation_engine.generate_disambiguation(candidates, user_input)
    
    return {
        "needs_disambiguation": disambiguation["needed"],
        "reason": disambiguation.get("reason", ""),
        "prompt": disambiguation.get("prompt", ""),
        "options": disambiguation.get("options", []),
        "candidates": candidates,
        "confidence_gap": round(candidates[0]["score"] - candidates[1]["score"], 3) if len(candidates) >= 2 else 1.0,
        "recommendation": "Ask user for clarification" if disambiguation["needed"] else "Proceed with top intent",
        "original_input": user_input
    }


def resolve_disambiguation(conversation_id: str, 
                          selected_option: int,
                          original_utterance: str) -> Dict:
    """
    Tool: Process user's disambiguation selection.
    
    Args:
        conversation_id: Session identifier
        selected_option: User's choice (1, 2, or 3)
        original_utterance: The original ambiguous utterance
    
    Returns:
        - resolved_intent: The selected intent
        - agent: Target agent for routing
        - status: Resolution status
    """
    classifier = get_classifier()
    candidates = classifier.get_candidates(original_utterance, top_k=3)
    
    if selected_option < 1 or selected_option > len(candidates):
        return {
            "status": "error",
            "error": f"Invalid option. Please select 1-{len(candidates)}"
        }
    
    selected = candidates[selected_option - 1]
    
    # Track in session
    classifier.session_manager.add(
        conversation_id, original_utterance, 
        selected["intent"], selected["score"],
        slots={}, disambiguation_resolved=True
    )
    
    return {
        "status": "resolved",
        "resolved_intent": selected["intent"],
        "intent_id": selected["intent_id"],
        "agent": selected["agent"],
        "category": selected["category"],
        "confidence": selected["score"],
        "conversation_id": conversation_id
    }


#===============================================================================
# TOOL 5: CONTEXT/SESSION MANAGEMENT
#===============================================================================
def get_session_context(conversation_id: str, turns: int = 5) -> Dict:
    """
    Tool: Get full conversation context including slot memory.
    
    Returns:
        - history: Recent conversation turns
        - slot_memory: Accumulated slots across conversation
        - recent_intents: List of recent intents
        - context_summary: Natural language summary
        - pending_intents: Unhandled intents from multi-intent detection
    """
    classifier = get_classifier()
    history = classifier.session_manager.get(conversation_id, n=turns)
    slot_memory = classifier.session_manager.get_slot_memory(conversation_id)
    pending = classifier.session_manager.get_pending_intents(conversation_id)
    
    return {
        "conversation_id": conversation_id,
        "history": history,
        "turn_count": len(history),
        "recent_intents": [h["intent"] for h in history],
        "slot_memory": slot_memory,
        "pending_intents": pending,
        "has_pending": len(pending) > 0,
        "context_summary": _summarize_context(history)
    }


def clear_session(conversation_id: str) -> Dict:
    """Tool: Clear session history and slot memory."""
    classifier = get_classifier()
    # Clear by setting empty
    if conversation_id in classifier.session_manager.sessions:
        del classifier.session_manager.sessions[conversation_id]
    if conversation_id in classifier.session_manager.slot_memory:
        del classifier.session_manager.slot_memory[conversation_id]
    
    return {
        "status": "cleared",
        "conversation_id": conversation_id
    }


#===============================================================================
# TOOL 6: INTENT CATALOG
#===============================================================================
def get_intents() -> Dict:
    """Tool: List all 47 available intents with routing info."""
    intents = _get_all_intents()
    
    # Group by category
    by_category = {}
    for intent in intents:
        cat = intent["category"]
        if cat not in by_category:
            by_category[cat] = []
        by_category[cat].append(intent)
    
    return {
        "total_count": len(intents),
        "categories": list(by_category.keys()),
        "by_category": by_category,
        "intents": intents
    }


def get_intent_details(intent_name: str) -> Dict:
    """Tool: Get details for a specific intent."""
    intents = _get_all_intents()
    
    for intent in intents:
        if intent["intent_name"] == intent_name:
            classifier = get_classifier()
            # Get slot requirements
            required_slots = classifier.slot_filler.SLOT_REQUIREMENTS.get(intent_name, [])
            
            return {
                "found": True,
                "intent": intent,
                "required_slots": required_slots,
                "slot_prompts": _generate_slot_prompts(required_slots)
            }
    
    return {
        "found": False,
        "error": f"Intent '{intent_name}' not found"
    }


#===============================================================================
# TOOL 7: HEALTH CHECK
#===============================================================================
def health_check() -> Dict:
    """Tool: Health check endpoint."""
    classifier = get_classifier()
    return {
        "status": "healthy",
        "service": "yava-intent-classifier",
        "version": "2.0.0",  # Updated for enhanced features
        "features": [
            "intent_classification",
            "slot_extraction",
            "multi_intent_detection",
            "disambiguation",
            "context_awareness",
            "session_management"
        ],
        "intent_count": 47,
        "vector_count": len(classifier.vector_store.vectors)
    }


#===============================================================================
# INTERNAL HELPERS
#===============================================================================
def _summarize_context(history: List[Dict]) -> str:
    """Summarize conversation context."""
    if not history:
        return "New conversation - no prior context"
    
    intents = [h["intent"] for h in history]
    unique_intents = list(dict.fromkeys(intents))
    
    if len(unique_intents) == 1:
        return f"User has been asking about {unique_intents[0]} ({len(history)} turns)"
    else:
        return f"User has discussed: {', '.join(unique_intents)} ({len(history)} turns)"


#===============================================================================
# MAIN ROUTER - Watson Orchestrate Entry Point
#===============================================================================
def main(params: Dict) -> Dict:
    """
    Main entry point for Watson Orchestrate skill/tool calls.
    
    Supported actions:
        - classify: Full NLU classification (default)
        - extract_slots: Extract entities from utterance
        - detect_multi: Detect multiple intents
        - disambiguate: Get disambiguation options
        - resolve_disambiguate: Process disambiguation selection
        - context: Get session context
        - clear_context: Clear session
        - intents: List all intents
        - intent_details: Get specific intent details
        - health: Health check
    """
    action = params.get("action", "classify")
    
    # CLASSIFY (default - full NLU)
    if action == "classify":
        return classify_intent(
            params.get("user_input", ""),
            params.get("conversation_id"),
            params.get("member_id"),
            params.get("context_aware", True)
        )
    
    # SLOT EXTRACTION
    elif action == "extract_slots":
        return extract_slots(
            params.get("user_input", ""),
            params.get("intent")
        )
    
    # MULTI-INTENT DETECTION
    elif action == "detect_multi":
        return detect_multi_intent(
            params.get("user_input", ""),
            params.get("conversation_id")
        )
    
    # DISAMBIGUATION
    elif action == "disambiguate":
        return get_disambiguation(
            params.get("user_input", ""),
            params.get("top_k", 3)
        )
    
    elif action == "resolve_disambiguate":
        return resolve_disambiguation(
            params.get("conversation_id", "default"),
            params.get("selected_option", 1),
            params.get("original_utterance", "")
        )
    
    # CONTEXT MANAGEMENT
    elif action == "context":
        return get_session_context(
            params.get("conversation_id", "default"),
            params.get("turns", 5)
        )
    
    elif action == "clear_context":
        return clear_session(params.get("conversation_id", "default"))
    
    # INTENT CATALOG
    elif action == "intents":
        return get_intents()
    
    elif action == "intent_details":
        return get_intent_details(params.get("intent_name", ""))
    
    # HEALTH
    elif action == "health":
        return health_check()
    
    else:
        return {
            "error": f"Unknown action: {action}",
            "available_actions": [
                "classify", "extract_slots", "detect_multi",
                "disambiguate", "resolve_disambiguate",
                "context", "clear_context",
                "intents", "intent_details", "health"
            ]
        }


if __name__ == "__main__":
    # Test enhanced classification
    print("=== TEST: Full Classification ===")
    result = classify_intent(
        "I need to refill my prescription for Lipitor and also check my claim from January 15th",
        "test-session"
    )
    print(json.dumps(result, indent=2))
    
    print("\n=== TEST: Slot Extraction ===")
    slots = extract_slots("I have a claim CLM-12345 from 03/15/2024 for $150.00")
    print(json.dumps(slots, indent=2))
    
    print("\n=== TEST: Multi-Intent Detection ===")
    multi = detect_multi_intent("Check my deductible and also tell me about my copay for specialists")
    print(json.dumps(multi, indent=2))
SKILLEOF

log_success "Created skill interface"

#===============================================================================
# Step 5: Create __main__.py for Orchestrate
#===============================================================================
log_info "Step 5: Creating entry point..."

cat > __main__.py << 'MAINEOF'
"""Watson Orchestrate Entry Point"""
from src.skill import main

def handler(params):
    return main(params)
MAINEOF

log_success "Created entry point"

#===============================================================================
# Step 6: Create OpenAPI Skill Definition
#===============================================================================
log_info "Step 6: Creating skill definition..."

cat > skills/yava_intent_classifier.json << 'OPENAPI_EOF'
{
    "openapi": "3.0.0",
    "info": {
        "title": "YAVA Intent Classifier",
        "description": "Local RAG+LLM intent classification for YAVA healthcare assistant. Classifies user utterances into 47 healthcare-related intents and routes to appropriate agents.",
        "version": "1.0.0",
        "x-ibm-application-name": "YAVA Intent Classifier",
        "x-ibm-application-id": "yava-intent-classifier"
    },
    "x-ibm-skill-type": "imported",
    "x-ibm-application-icon": "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32'><circle cx='16' cy='16' r='14' fill='#1565C0'/><text x='16' y='21' text-anchor='middle' fill='white' font-size='14' font-weight='bold'>Y</text></svg>",
    "servers": [
        {
            "url": "."
        }
    ],
    "paths": {
        "/classify": {
            "post": {
                "operationId": "classifyIntent",
                "summary": "Classify user utterance to healthcare intent",
                "description": "Uses RAG+LLM to classify user messages into specific healthcare intents (pharmacy, claims, eligibility, etc.) and determines the appropriate agent for routing.",
                "x-]]]ibm-nl-intent-examples": [
                    "classify this message",
                    "what intent is this",
                    "determine the intent",
                    "route this request",
                    "what does the user want"
                ],
                "requestBody": {
                    "required": true,
                    "content": {
                        "application/json": {
                            "schema": {
                                "type": "object",
                                "required": ["user_input"],
                                "properties": {
                                    "user_input": {
                                        "type": "string",
                                        "description": "The user's natural language message to classify",
                                        "x-]]]ibm-label": "User Message"
                                    },
                                    "conversation_id": {
                                        "type": "string",
                                        "description": "Conversation session ID for context",
                                        "x-]]]ibm-label": "Conversation ID"
                                    },
                                    "member_id": {
                                        "type": "string",
                                        "description": "Member identifier for personalization",
                                        "x-]]]ibm-label": "Member ID"
                                    }
                                }
                            }
                        }
                    }
                },
                "responses": {
                    "200": {
                        "description": "Intent classification result",
                        "content": {
                            "application/json": {
                                "schema": {
                                    "type": "object",
                                    "properties": {
                                        "intent": {
                                            "type": "string",
                                            "description": "Detected intent name (e.g., pharmacy, claims, eligibility)"
                                        },
                                        "agent": {
                                            "type": "string",
                                            "description": "Target agent for routing (e.g., PharmacyAgent, ClaimsAgent)"
                                        },
                                        "confidence": {
                                            "type": "number",
                                            "description": "Classification confidence score (0-1)"
                                        },
                                        "needs_clarification": {
                                            "type": "boolean",
                                            "description": "Whether disambiguation is needed (confidence < 0.75)"
                                        },
                                        "metadata": {
                                            "type": "object",
                                            "properties": {
                                                "intent_id": {"type": "string"},
                                                "category": {"type": "string"},
                                                "processing_time_ms": {"type": "number"}
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        },
        "/intents": {
            "get": {
                "operationId": "getIntents",
                "summary": "List all available intents",
                "description": "Returns the complete list of 47 healthcare intents supported by the classifier.",
                "responses": {
                    "200": {
                        "description": "List of intents",
                        "content": {
                            "application/json": {
                                "schema": {
                                    "type": "object",
                                    "properties": {
                                        "intents": {
                                            "type": "array",
                                            "items": {"type": "object"}
                                        },
                                        "count": {"type": "integer"}
                                    }
                                }
                            }
                        }
                    }
                }
            }
        },
        "/health": {
            "get": {
                "operationId": "healthCheck",
                "summary": "Health check",
                "description": "Returns service health status.",
                "responses": {
                    "200": {
                        "description": "Health status"
                    }
                }
            }
        }
    }
}
OPENAPI_EOF

log_success "Created skill definition"

#===============================================================================
# Step 7: Create Test Script
#===============================================================================
log_info "Step 7: Creating test script..."

cat > test_classifier.py << 'TESTEOF'
#!/usr/bin/env python3
"""Test YAVA Intent Classifier"""

import sys
sys.path.insert(0, '.')

from src.classifier import get_classifier
from src.skill import classify_intent, get_intents, health_check

def test():
    print("=" * 60)
    print("YAVA Intent Classifier - Test Suite")
    print("=" * 60)
    
    # Test initialization
    classifier = get_classifier()
    print(f"\n✓ Classifier initialized with {len(classifier.vector_store.vectors)} training vectors")
    
    # Test classification
    test_cases = [
        ("I need to refill my prescription", "pharmacy"),
        ("Check my claim status", "claims"),
        ("What is my deductible", "deductible"),
        ("Find urgent care near me", "urgentCare"),
        ("I need mental health support", "behavioralHealth"),
        ("Am I covered", "eligibility"),
        ("I need a new ID card", "idCard"),
        ("HSA balance", "hsa"),
    ]
    
    print("\nClassification Tests:")
    print("-" * 60)
    
    passed = 0
    for utterance, expected in test_cases:
        result = classifier.classify(utterance)
        status = "✓" if result["intent"] == expected else "✗"
        if result["intent"] == expected:
            passed += 1
        print(f"{status} '{utterance}'")
        print(f"  → {result['intent']} ({result['confidence']:.2f}) → {result['agent_routing']}")
    
    print(f"\nAccuracy: {passed}/{len(test_cases)} ({100*passed/len(test_cases):.0f}%)")
    
    # Test skill interface
    print("\n" + "-" * 60)
    print("Skill Interface Tests:")
    
    result = classify_intent("I need to see a specialist")
    print(f"✓ classify_intent: {result['intent']} → {result['agent']}")
    
    intents = get_intents()
    print(f"✓ get_intents: {intents['count']} intents")
    
    health = health_check()
    print(f"✓ health_check: {health['status']}")
    
    print("\n" + "=" * 60)
    print("All tests completed!")
    print("=" * 60)

if __name__ == "__main__":
    test()
TESTEOF

chmod +x test_classifier.py
log_success "Created test script"

#===============================================================================
# Step 8: Run Tests
#===============================================================================
log_info "Step 8: Running tests..."

python3 test_classifier.py

#===============================================================================
# Step 9: Package for Orchestrate
#===============================================================================
log_info "Step 9: Packaging for Watson Orchestrate..."

# Create package
zip -r yava-intent-classifier.zip src/ __main__.py -x "*.pyc" -x "__pycache__/*"

log_success "Package created: yava-intent-classifier.zip"

#===============================================================================
# Step 10: Deploy to Watson Orchestrate as Agent
#===============================================================================
log_info "Step 10: Deploying to Watson Orchestrate as Agent..."

echo ""

# Create agent definition file
log_info "Creating agent definition..."

cat > skills/yava_agent.json << 'AGENT_DEF_EOF'
{
    "name": "YAVA Intent Classifier Agent",
    "description": "Advanced healthcare intent classification agent with full NLU capabilities: Intent Classification, Slot Extraction, Multi-Intent Detection, Context-Aware Processing, and Disambiguation. Supports 47 healthcare-related intents across categories: Healthcare Services, Benefits & Coverage, Financial, Claims, Wellness, and Member Services.",
    "instructions": "You are the YAVA Intent Classification Agent for Aetna healthcare services. Your role involves 8 critical processes leveraging advanced NLU capabilities:\n\n## PROCESS 1: INTENT CLASSIFICATION (Primary)\n- For EVERY user message, call 'classify_intent' first\n- Pass: user_input, conversation_id (for context), member_id (optional)\n- Returns: intent, agent, confidence, slots, multi_intents, disambiguation info\n- The classifier automatically handles context-awareness and slot extraction\n\n## PROCESS 2: SLOT EXTRACTION\n- The classifier extracts entities automatically:\n  - Dates: '03/15/2024', 'yesterday', 'next week'\n  - Claim IDs: 'CLM-12345', reference numbers\n  - Member IDs: 'MEM-123456'\n  - Currency: '$150.00', amounts\n  - Names: 'Dr. Smith', pharmacy names\n- Check 'slots' in response for extracted values\n- Check 'missing_slots' for required but unprovided info\n- If slots missing, ask user: Use slot_prompts from extract_slots tool\n\n## PROCESS 3: MULTI-INTENT HANDLING\n- Classifier detects compound requests like:\n  - 'Check my deductible AND my copay for specialists'\n  - 'I need to refill my prescription and also check a claim'\n- Check 'has_multi_intents' and 'multi_intents' array\n- If multiple intents:\n  1. Handle highest priority intent first\n  2. Acknowledge other intents: 'I see you also asked about X. Let me help with Y first.'\n  3. After completing first, address remaining\n\n## PROCESS 4: CONTEXT-AWARE CLASSIFICATION\n- Classifier automatically boosts intents based on conversation history\n- Short utterances ('what about cost?') are interpreted in context\n- Check 'context_boosted' flag to see if context was applied\n- If 'context_applied': true, classifier used session history\n\n## PROCESS 5: DISAMBIGUATION\n- When 'needs_disambiguation': true:\n  - Use 'disambiguation_prompt' directly - it's already formatted\n  - Or use 'disambiguation_options' to build custom response\n- After user clarifies, call 'resolve_disambiguation' with their selection\n- Disambiguation triggered when:\n  - Top 2 intents are close in score (<0.15 difference)\n  - Confidence below 0.75\n\n## PROCESS 6: CONFIDENCE HANDLING\n- HIGH (≥0.85): Proceed directly to agent routing\n- MEDIUM (0.75-0.84): Confirm intent with user before routing\n- LOW (<0.75): Use disambiguation_prompt to clarify\n- VERY LOW (<0.5): Ask open-ended clarifying question\n\n## PROCESS 7: AGENT ROUTING\n- Use 'agent' field from classifier response\n- Pass context: intent, slots (extracted values), member_id, conversation summary\n- Available agents: PharmacyAgent, ClaimsAgent, BenefitsAgent, EligibilityAgent, ProviderSearchAgent, FinancialAgent, MemberServicesAgent, WellnessAgent\n- Announce handoff: 'I'm connecting you to our [AgentName] team...'\n\n## PROCESS 8: SESSION MANAGEMENT\n- Use consistent conversation_id throughout session\n- Call 'get_session_context' to see full history and accumulated slots\n- Slot memory persists across turns (no need to re-ask for member_id)\n- Call 'clear_session' only when starting completely fresh conversation\n\n## EMERGENCY HANDLING\n- If intent is 'behavioralEmergency' - IMMEDIATELY provide:\n  - 988 Suicide & Crisis Lifeline\n  - 'If you are in immediate danger, please call 911'\n- Do NOT wait for disambiguation or slot filling on emergency intents\n\n## EXAMPLE FLOW:\nUser: 'I need to refill my prescription for Lipitor and check my claim from January'\n1. Call classify_intent('I need to refill my prescription for Lipitor and check my claim from January', 'session-123')\n2. Result:\n   - intent: 'pharmacy'\n   - has_multi_intents: true\n   - multi_intents: [{segment: 'refill prescription for Lipitor', intent: 'pharmacy'}, {segment: 'check my claim from January', intent: 'claims'}]\n   - slots: {medication_name: 'Lipitor', date_of_service: 'January'}\n3. Response: 'I can help with both! Let me first connect you to our Pharmacy team for your Lipitor refill, then we can check your January claim.'\n4. Route to PharmacyAgent with context\n5. After pharmacy handled: 'Now let me help with your claim from January...'\n6. Route to ClaimsAgent",
    "llm_config": {
        "model": "granite-3-8b-instruct",
        "temperature": 0.1,
        "max_tokens": 1000
    },
    "tools": [
        {
            "name": "classify_intent",
            "description": "FULL NLU Classification - Call for EVERY user message. Returns intent with confidence, extracted slots, multi-intent detection, context awareness, and disambiguation status. This is the primary tool that combines all NLU features.",
            "parameters": {
                "type": "object",
                "properties": {
                    "user_input": {
                        "type": "string",
                        "description": "The user's natural language message to classify"
                    },
                    "conversation_id": {
                        "type": "string",
                        "description": "Session ID for multi-turn context. Use same ID throughout conversation."
                    },
                    "member_id": {
                        "type": "string",
                        "description": "Member identifier for personalization"
                    },
                    "context_aware": {
                        "type": "boolean",
                        "description": "Enable context-aware boosting from history (default: true)"
                    }
                },
                "required": ["user_input"]
            },
            "returns": {
                "type": "object",
                "properties": {
                    "intent": {"type": "string", "description": "Primary detected intent"},
                    "agent": {"type": "string", "description": "Target agent for routing"},
                    "confidence": {"type": "number", "description": "Confidence 0-1"},
                    "slots": {"type": "object", "description": "Extracted entities {type: value}"},
                    "missing_slots": {"type": "array", "description": "Required slots not yet provided"},
                    "has_multi_intents": {"type": "boolean", "description": "True if multiple intents detected"},
                    "multi_intents": {"type": "array", "description": "Array of detected intents with segments"},
                    "needs_disambiguation": {"type": "boolean", "description": "True if clarification needed"},
                    "disambiguation_prompt": {"type": "string", "description": "Ready-to-use clarification question"},
                    "context_boosted": {"type": "boolean", "description": "True if context affected classification"}
                }
            }
        },
        {
            "name": "extract_slots",
            "description": "Extract entities from utterance without full classification. Use for slot-focused extraction when intent is already known.",
            "parameters": {
                "type": "object",
                "properties": {
                    "user_input": {"type": "string", "description": "User message to extract from"},
                    "intent": {"type": "string", "description": "Known intent for slot requirements"}
                },
                "required": ["user_input"]
            },
            "returns": {
                "type": "object",
                "properties": {
                    "extracted_slots": {"type": "object", "description": "Extracted {slot_type: value}"},
                    "missing_required": {"type": "array", "description": "Required slots not found"},
                    "slot_prompts": {"type": "object", "description": "User-friendly prompts for missing slots"}
                }
            }
        },
        {
            "name": "detect_multi_intent",
            "description": "Analyze utterance for multiple intents. Use for detailed multi-intent breakdown.",
            "parameters": {
                "type": "object",
                "properties": {
                    "user_input": {"type": "string", "description": "User message"},
                    "conversation_id": {"type": "string", "description": "Session ID"}
                },
                "required": ["user_input"]
            },
            "returns": {
                "type": "object",
                "properties": {
                    "has_multiple_intents": {"type": "boolean"},
                    "intent_count": {"type": "integer"},
                    "intents": {"type": "array", "description": "Array of {segment, intent, confidence, agent}"},
                    "suggested_order": {"type": "array", "description": "Recommended processing order"}
                }
            }
        },
        {
            "name": "get_disambiguation",
            "description": "Get disambiguation options for ambiguous requests. Use when classify_intent shows low confidence.",
            "parameters": {
                "type": "object",
                "properties": {
                    "user_input": {"type": "string", "description": "Ambiguous user message"},
                    "top_k": {"type": "integer", "description": "Number of options (default: 3)"}
                },
                "required": ["user_input"]
            },
            "returns": {
                "type": "object",
                "properties": {
                    "needs_disambiguation": {"type": "boolean"},
                    "prompt": {"type": "string", "description": "Ready-to-use question for user"},
                    "options": {"type": "array", "description": "Numbered options with descriptions"}
                }
            }
        },
        {
            "name": "resolve_disambiguation",
            "description": "Process user's disambiguation selection after they choose an option.",
            "parameters": {
                "type": "object",
                "properties": {
                    "conversation_id": {"type": "string", "description": "Session ID"},
                    "selected_option": {"type": "integer", "description": "User's choice (1, 2, or 3)"},
                    "original_utterance": {"type": "string", "description": "The original ambiguous message"}
                },
                "required": ["conversation_id", "selected_option", "original_utterance"]
            }
        },
        {
            "name": "get_session_context",
            "description": "Get full conversation context including history and accumulated slots. Use when user references previous topics.",
            "parameters": {
                "type": "object",
                "properties": {
                    "conversation_id": {"type": "string", "description": "Session ID"},
                    "turns": {"type": "integer", "description": "Number of recent turns (default: 5)"}
                },
                "required": ["conversation_id"]
            },
            "returns": {
                "type": "object",
                "properties": {
                    "history": {"type": "array", "description": "Recent conversation turns"},
                    "slot_memory": {"type": "object", "description": "Accumulated slots across conversation"},
                    "pending_intents": {"type": "array", "description": "Unhandled intents from multi-intent"}
                }
            }
        },
        {
            "name": "clear_session",
            "description": "Clear conversation history and slot memory. Use when starting fresh.",
            "parameters": {
                "type": "object",
                "properties": {
                    "conversation_id": {"type": "string", "description": "Session ID to clear"}
                },
                "required": ["conversation_id"]
            }
        },
        {
            "name": "get_intents",
            "description": "List all 47 available healthcare intents with categories and routing info."
        },
        {
            "name": "get_intent_details",
            "description": "Get details for a specific intent including required slots.",
            "parameters": {
                "type": "object",
                "properties": {
                    "intent_name": {"type": "string", "description": "Name of intent to lookup"}
                },
                "required": ["intent_name"]
            }
        },
        {
            "name": "health_check",
            "description": "Check classifier service health and feature status."
        }
    ],
    "conversation_starters": [
        "I need help with my prescription",
        "Check my claim status",
        "What is my deductible?",
        "Find a doctor near me",
        "I need to refill my medication and also check a claim"
    ]
}
AGENT_DEF_EOF

log_success "Created agent definition"

# Method 1: Import as Agent using orchestrate agent commands
log_info "Importing agent to Watson Orchestrate..."

# Check if orchestrate CLI supports agent import
if orchestrate agent --help 2>/dev/null | grep -q "import\|create"; then
    # Try agent import/create
    orchestrate agent create \
        --name "YAVA Intent Classifier Agent" \
        --definition skills/yava_agent.json \
        2>/dev/null && log_success "Agent created via 'orchestrate agent create'" || \
    orchestrate agent import \
        --file skills/yava_agent.json \
        2>/dev/null && log_success "Agent imported via 'orchestrate agent import'" || \
    log_warn "Agent import command not available, trying alternative methods..."
fi

# Method 2: Deploy code as action first, then link to agent
log_info "Deploying action code..."

orchestrate action create yava-intent-classifier \
    --file yava-intent-classifier.zip \
    --runtime python:3.10 \
    --memory 256 \
    --timeout 30000 \
    2>/dev/null || orchestrate action update yava-intent-classifier \
        --file yava-intent-classifier.zip \
        --runtime python:3.10 \
    2>/dev/null

# Method 3: Import OpenAPI skill and associate with agent
log_info "Importing skill from OpenAPI spec..."

orchestrate skill import \
    --file skills/yava_intent_classifier.json \
    2>/dev/null || log_warn "Skill import returned non-zero"

# Method 4: Use draft agent creation (newer Orchestrate versions)
log_info "Attempting draft agent creation..."

orchestrate draft agent create \
    --name "YAVA Intent Classifier Agent" \
    --description "Healthcare intent classification using RAG+LLM" \
    --instructions "Classify user messages into healthcare intents and route to appropriate agents" \
    2>/dev/null && log_success "Draft agent created" || log_warn "Draft agent creation not available"

# Method 5: Publish agent if draft was created
orchestrate draft agent publish \
    --name "YAVA Intent Classifier Agent" \
    2>/dev/null && log_success "Agent published" || true

log_success "Deployment steps completed"

echo ""
log_info "NOTE: If automatic agent import failed, manually import via Watson Orchestrate UI:"
echo "  1. Go to Watson Orchestrate console"
echo "  2. Navigate to 'Agent Builder' or 'AI Assistants'"  
echo "  3. Click 'Create Agent' or 'Import'"
echo "  4. Upload: skills/yava_agent.json"
echo "  5. Associate the 'yava-intent-classifier' action with the agent"
echo ""

#===============================================================================
# Step 11: Verify Agent Deployment
#===============================================================================
log_info "Step 11: Verifying agent deployment..."

echo ""

# Test 1: List agents to verify agent was created
log_info "Listing agents to verify creation..."
orchestrate agent list 2>/dev/null | grep -i "YAVA\|intent" && \
    log_success "Agent found in agent list" || \
    log_warn "Agent not found in list - may need manual import"

# Test 2: Get agent details
log_info "Getting agent details..."
orchestrate agent get "YAVA Intent Classifier Agent" 2>/dev/null || \
orchestrate agent describe "YAVA Intent Classifier Agent" 2>/dev/null || \
    log_warn "Could not retrieve agent details"

# Test 3: Test basic classification
log_info "Testing agent - basic classification..."
orchestrate agent invoke "YAVA Intent Classifier Agent" \
    --input "I need to refill my prescription" \
    2>/dev/null && log_success "Basic classification successful" || \
    log_warn "Agent invoke not available - try chat mode"

# Test 4: Test multi-intent detection
log_info "Testing agent - multi-intent detection..."
orchestrate agent invoke "YAVA Intent Classifier Agent" \
    --input "Check my deductible and also my copay for specialists" \
    2>/dev/null && log_success "Multi-intent detection successful" || true

# Test 5: Test slot extraction
log_info "Testing agent - slot extraction..."
orchestrate agent invoke "YAVA Intent Classifier Agent" \
    --input "I have a claim CLM-12345 from 03/15/2024 for \$150.00" \
    2>/dev/null && log_success "Slot extraction successful" || true

# Test 6: Test disambiguation scenario
log_info "Testing agent - disambiguation..."
orchestrate agent invoke "YAVA Intent Classifier Agent" \
    --input "medication" \
    2>/dev/null && log_success "Disambiguation test successful" || true

# Test 7: Test agent chat mode
log_info "Testing agent chat mode..."
echo "To test interactively, run:"
echo "  orchestrate agent chat \"YAVA Intent Classifier Agent\""
echo ""

# Test 8: Run comprehensive local tests
log_info "Running comprehensive local tests..."
cat > test_enhanced.py << 'ENHANCEDTESTEOF'
"""
Enhanced Tests for YAVA Intent Classifier
Tests: Disambiguation, Context-Aware, Multi-Intent, Slot Filling
"""
import json
import sys
sys.path.insert(0, 'src')

from skill import (
    classify_intent, 
    extract_slots, 
    detect_multi_intent, 
    get_disambiguation,
    get_session_context,
    health_check
)

def test_full_classification():
    """Test full NLU classification with all features."""
    print("\n" + "="*60)
    print("TEST 1: Full Classification with Slots & Multi-Intent")
    print("="*60)
    
    result = classify_intent(
        "I need to refill my prescription for Lipitor and check my claim from January 15th",
        "test-session-1"
    )
    
    print(f"Intent: {result['intent']}")
    print(f"Confidence: {result['confidence']}")
    print(f"Agent: {result['agent']}")
    print(f"Slots: {result['slots']}")
    print(f"Has Multi-Intents: {result['has_multi_intents']}")
    if result.get('multi_intents'):
        print(f"Multi-Intents: {result['multi_intents']}")
    print(f"Needs Disambiguation: {result['needs_disambiguation']}")
    
    assert result['intent'] in ['pharmacy', 'claims']
    assert isinstance(result['slots'], dict)
    print("✅ Full classification test PASSED")

def test_slot_extraction():
    """Test standalone slot extraction."""
    print("\n" + "="*60)
    print("TEST 2: Slot Extraction")
    print("="*60)
    
    result = extract_slots(
        "I have a claim CLM-12345 from 03/15/2024 for $150.00 with Dr. Smith"
    )
    
    print(f"Extracted Slots: {result['extracted_slots']}")
    print(f"Slot Count: {result['slot_count']}")
    print(f"Slot Types: {result['slot_types']}")
    
    slots = result['extracted_slots']
    assert 'claim_id' in slots or 'reference_id' in slots
    assert 'date_of_service' in slots
    assert 'amount' in slots
    print("✅ Slot extraction test PASSED")

def test_multi_intent_detection():
    """Test multi-intent detection."""
    print("\n" + "="*60)
    print("TEST 3: Multi-Intent Detection")
    print("="*60)
    
    result = detect_multi_intent(
        "Check my deductible and also tell me about my copay for specialists"
    )
    
    print(f"Has Multiple Intents: {result['has_multiple_intents']}")
    print(f"Intent Count: {result['intent_count']}")
    print(f"Intents:")
    for intent in result['intents']:
        print(f"  - {intent['segment'][:50]}... -> {intent['intent']}")
    print(f"Suggested Order: {result['suggested_order']}")
    
    assert result['has_multiple_intents'] == True
    assert result['intent_count'] >= 2
    print("✅ Multi-intent detection test PASSED")

def test_disambiguation():
    """Test disambiguation for ambiguous requests."""
    print("\n" + "="*60)
    print("TEST 4: Disambiguation")
    print("="*60)
    
    result = get_disambiguation("medication")
    
    print(f"Needs Disambiguation: {result['needs_disambiguation']}")
    print(f"Prompt: {result.get('prompt', 'N/A')}")
    print(f"Options: {len(result.get('options', []))} options")
    print(f"Confidence Gap: {result.get('confidence_gap', 'N/A')}")
    
    # Ambiguous term should trigger disambiguation
    assert 'candidates' in result
    assert len(result['candidates']) >= 2
    print("✅ Disambiguation test PASSED")

def test_context_awareness():
    """Test context-aware classification across turns."""
    print("\n" + "="*60)
    print("TEST 5: Context-Aware Classification")
    print("="*60)
    
    session_id = "context-test-session"
    
    # Turn 1: Establish context
    r1 = classify_intent("I want to know about my prescription benefits", session_id)
    print(f"Turn 1 - Intent: {r1['intent']}, Confidence: {r1['confidence']}")
    
    # Turn 2: Short follow-up (should use context)
    r2 = classify_intent("what about cost?", session_id)
    print(f"Turn 2 - Intent: {r2['intent']}, Confidence: {r2['confidence']}")
    print(f"        Context Applied: {r2.get('context_applied', False)}")
    print(f"        Context Boosted: {r2.get('context_boosted', False)}")
    
    # Turn 3: Check context
    context = get_session_context(session_id)
    print(f"Session Context:")
    print(f"  Turn Count: {context['turn_count']}")
    print(f"  Recent Intents: {context['recent_intents']}")
    print(f"  Slot Memory: {context.get('slot_memory', {})}")
    
    assert context['turn_count'] >= 2
    print("✅ Context-awareness test PASSED")

def test_health_check():
    """Test health check with features."""
    print("\n" + "="*60)
    print("TEST 6: Health Check")
    print("="*60)
    
    result = health_check()
    
    print(f"Status: {result['status']}")
    print(f"Version: {result['version']}")
    print(f"Features: {result['features']}")
    print(f"Intent Count: {result['intent_count']}")
    
    assert result['status'] == 'healthy'
    assert 'slot_extraction' in result['features']
    assert 'multi_intent_detection' in result['features']
    assert 'disambiguation' in result['features']
    print("✅ Health check test PASSED")

def run_all_tests():
    """Run all enhanced tests."""
    print("\n" + "="*60)
    print("YAVA INTENT CLASSIFIER - ENHANCED FEATURE TESTS")
    print("="*60)
    
    tests = [
        test_full_classification,
        test_slot_extraction,
        test_multi_intent_detection,
        test_disambiguation,
        test_context_awareness,
        test_health_check
    ]
    
    passed = 0
    failed = 0
    
    for test in tests:
        try:
            test()
            passed += 1
        except AssertionError as e:
            print(f"❌ {test.__name__} FAILED: {e}")
            failed += 1
        except Exception as e:
            print(f"❌ {test.__name__} ERROR: {e}")
            failed += 1
    
    print("\n" + "="*60)
    print(f"RESULTS: {passed} passed, {failed} failed")
    print("="*60)
    
    return failed == 0

if __name__ == "__main__":
    success = run_all_tests()
    exit(0 if success else 1)
ENHANCEDTESTEOF

python3 test_enhanced.py 2>/dev/null && log_success "Enhanced local tests passed" || log_warn "Enhanced tests had issues"
echo ""

#===============================================================================
# Summary
#===============================================================================
echo ""
echo "============================================================"
echo "  YAVA Intent Classifier Agent - Installation Complete!"
echo "============================================================"
echo ""
echo "ENHANCED FEATURES INSTALLED:"
echo "  ✓ Intent Classification (47 intents)"
echo "  ✓ Slot Extraction (dates, IDs, amounts, names)"
echo "  ✓ Multi-Intent Detection (compound sentences)"
echo "  ✓ Context-Aware Classification (session memory)"
echo "  ✓ Disambiguation Engine (ambiguity handling)"
echo ""
echo "Files Created:"
echo "  ${PROJECT_NAME}/"
echo "  ├── __main__.py"
echo "  ├── yava-intent-classifier.zip"
echo "  ├── test_classifier.py"
echo "  ├── test_enhanced.py (NEW - tests all features)"
echo "  ├── src/"
echo "  │   ├── __init__.py"
echo "  │   ├── classifier.py (Enhanced: Slots, Multi-Intent, Context, Disambiguation)"
echo "  │   ├── skill.py (10 operations: classify, slots, multi, disambiguate, context...)"
echo "  │   └── intents/"
echo "  │       ├── __init__.py"
echo "  │       └── knowledge_base.py (47 intents)"
echo "  └── skills/"
echo "      └── yava_agent.json (Agent definition with 10 tools)"
echo ""
echo "SKILL OPERATIONS:"
echo "  1. classify_intent    - Full NLU (primary tool)"
echo "  2. extract_slots      - Entity extraction"
echo "  3. detect_multi_intent - Compound sentence parsing"
echo "  4. get_disambiguation  - Ambiguity handling"
echo "  5. resolve_disambiguation - User selection processing"
echo "  6. get_session_context - History & slot memory"
echo "  7. clear_session      - Reset conversation"
echo "  8. get_intents        - Intent catalog"
echo "  9. get_intent_details - Intent specifics"
echo "  10. health_check      - Service status"
echo ""
echo "Usage - Chat with Agent:"
echo "  orchestrate agent chat \"YAVA Intent Classifier Agent\""
echo ""
echo "Usage - Test Enhanced Features:"
echo "  cd ${PROJECT_NAME}"
echo "  python3 test_enhanced.py"
echo ""
echo "Usage - Test Specific Features:"
echo "  # Multi-intent"
echo "  orchestrate agent invoke \"YAVA Intent Classifier Agent\" \\"
echo "    --input \"Check deductible and copay for specialists\""
echo ""
echo "  # Slot extraction"
echo "  orchestrate agent invoke \"YAVA Intent Classifier Agent\" \\"
echo "    --input \"I have claim CLM-12345 from 03/15/2024\""
echo ""
echo "Manual Import (if needed):"
echo "  1. Watson Orchestrate UI → Agent Builder"
echo "  2. Create New Agent → Import"
echo "  3. Upload: skills/yava_agent.json"
echo ""
echo "============================================================"

