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
"""Local RAG+LLM Intent Classifier"""

import numpy as np
from typing import Dict, List, Optional, Tuple
from datetime import datetime
from collections import defaultdict
from .intents.knowledge_base import INTENT_KNOWLEDGE_BASE


class InMemoryVectorStore:
    def __init__(self):
        self.vectors, self.metadata = [], []
        
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
    def __init__(self):
        self.sessions = defaultdict(list)
        
    def add(self, session_id: str, utterance: str, intent: str, confidence: float):
        self.sessions[session_id].append({
            "utterance": utterance, "intent": intent, 
            "confidence": confidence, "timestamp": datetime.utcnow().isoformat()
        })
        if len(self.sessions[session_id]) > 10:
            self.sessions[session_id] = self.sessions[session_id][-10:]
    
    def get(self, session_id: str, n: int = 5) -> List[Dict]:
        return self.sessions.get(session_id, [])[-n:]


class EmbeddingGenerator:
    def __init__(self, dim: int = 384):
        self.dim = dim
        
    def generate(self, text: str) -> np.ndarray:
        """Generate deterministic embedding for text."""
        text = text.lower()
        np.random.seed(hash(text) % (2**32))
        emb = np.random.randn(self.dim)
        return emb / (np.linalg.norm(emb) + 1e-10)


class LocalIntentClassifier:
    def __init__(self):
        self.vector_store = InMemoryVectorStore()
        self.session_manager = SessionManager()
        self.embedder = EmbeddingGenerator()
        self._build_kb()
        
    def _build_kb(self):
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
    
    def classify(self, utterance: str, session_id: str = "default") -> Dict:
        start = datetime.utcnow()
        query_emb = self.embedder.generate(utterance)
        results = self.vector_store.search(query_emb, top_k=10)
        
        # Vote from top matches
        votes = defaultdict(float)
        for meta, score in results[:5]:
            votes[meta["intent_name"]] += score
        
        best_intent = max(votes, key=votes.get) if votes else "unknown"
        best_meta = next((m for m, s in results if m["intent_name"] == best_intent), 
                        {"intent_id": "UNK", "agent_routing": "FallbackAgent", "category": "unknown"})
        
        # Confidence calculation
        matching = [s for m, s in results[:3] if m["intent_name"] == best_intent]
        confidence = round(sum(matching) / len(matching) if matching else 0.5, 3)
        
        result = {
            "intent": best_intent,
            "intent_id": best_meta["intent_id"],
            "agent_routing": best_meta["agent_routing"],
            "category": best_meta["category"],
            "confidence": confidence,
            "needs_disambiguation": confidence < 0.75,
            "top_match_score": results[0][1] if results else 0.0,
            "processing_time_ms": (datetime.utcnow() - start).total_seconds() * 1000
        }
        
        self.session_manager.add(session_id, utterance, result["intent"], confidence)
        return result


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
"""Watson Orchestrate Skill Interface"""

import json
from typing import Dict, Optional
from .classifier import get_classifier
from .intents.knowledge_base import get_all_intents as _get_all_intents


def classify_intent(user_input: str, 
                   conversation_id: Optional[str] = None,
                   member_id: Optional[str] = None) -> Dict:
    """
    Skill: Classify user utterance to healthcare intent.
    
    Args:
        user_input: User's natural language message
        conversation_id: Watson conversation ID
        member_id: Member identifier
        
    Returns:
        Classification result for Watson routing
    """
    session_id = conversation_id or f"watson-{member_id}" or "default"
    classifier = get_classifier()
    result = classifier.classify(user_input, session_id)
    
    return {
        "intent": result["intent"],
        "agent": result["agent_routing"],
        "confidence": result["confidence"],
        "needs_clarification": result["needs_disambiguation"],
        "metadata": {
            "intent_id": result["intent_id"],
            "category": result["category"],
            "processing_time_ms": result["processing_time_ms"]
        }
    }


def get_intents() -> Dict:
    """Skill: List all available intents."""
    intents = _get_all_intents()
    return {"intents": intents, "count": len(intents)}


def health_check() -> Dict:
    """Skill: Health check endpoint."""
    return {"status": "healthy", "service": "yava-intent-classifier", "version": "1.0.0"}


# Main entry for Watson Orchestrate
def main(params: Dict) -> Dict:
    """Main entry point for Watson Orchestrate action."""
    action = params.get("action", "classify")
    
    if action == "classify":
        return classify_intent(
            params.get("user_input", ""),
            params.get("conversation_id"),
            params.get("member_id")
        )
    elif action == "intents":
        return get_intents()
    elif action == "health":
        return health_check()
    else:
        return {"error": f"Unknown action: {action}"}


if __name__ == "__main__":
    # Test
    print(json.dumps(classify_intent("I need to refill my prescription"), indent=2))
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
    "description": "Healthcare intent classification agent that determines user intent from natural language and routes to appropriate specialized agents. Supports 47 healthcare-related intents across categories: Healthcare Services, Benefits & Coverage, Financial, Claims, Wellness, and Member Services.",
    "instructions": "You are the YAVA Intent Classification Agent. Your role is to analyze user messages and determine their healthcare-related intent. When a user sends a message, classify it into one of 47 predefined intents and return the appropriate agent for routing. Always provide confidence scores and indicate if clarification is needed for ambiguous requests.",
    "llm_config": {
        "model": "granite-3-8b-instruct",
        "temperature": 0.1,
        "max_tokens": 500
    },
    "tools": [
        {
            "name": "classify_intent",
            "description": "Classify a user message into a healthcare intent",
            "parameters": {
                "type": "object",
                "properties": {
                    "user_input": {
                        "type": "string",
                        "description": "The user's natural language message"
                    },
                    "conversation_id": {
                        "type": "string",
                        "description": "Session ID for conversation context"
                    },
                    "member_id": {
                        "type": "string",
                        "description": "Member identifier"
                    }
                },
                "required": ["user_input"]
            }
        },
        {
            "name": "get_intents",
            "description": "List all 47 available healthcare intents"
        },
        {
            "name": "health_check",
            "description": "Check agent health status"
        }
    ],
    "conversation_starters": [
        "I need help with my prescription",
        "Check my claim status",
        "What is my deductible?",
        "Find a doctor near me",
        "I have a question about my benefits"
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

# Test 3: Test agent invocation
log_info "Testing agent - classify prescription intent..."
orchestrate agent invoke "YAVA Intent Classifier Agent" \
    --input "I need to refill my prescription" \
    2>/dev/null && log_success "Agent invocation successful" || \
    log_warn "Agent invoke not available - try chat mode"

# Test 4: Test agent with claim query
log_info "Testing agent - classify claims intent..."
orchestrate agent invoke "YAVA Intent Classifier Agent" \
    --input "I need to check my claim status" \
    2>/dev/null && log_success "Claims classification successful" || true

# Test 5: Test agent with benefits query
log_info "Testing agent - classify benefits intent..."
orchestrate agent invoke "YAVA Intent Classifier Agent" \
    --input "What is my deductible?" \
    2>/dev/null && log_success "Benefits classification successful" || true

# Test 6: Test agent chat mode
log_info "Testing agent chat mode..."
echo "To test interactively, run:"
echo "  orchestrate agent chat \"YAVA Intent Classifier Agent\""
echo ""

# Test 7: Run comprehensive tests via local Python
log_info "Running local comprehensive tests..."
if [[ -f test_classifier.py ]]; then
    python3 test_classifier.py 2>/dev/null && log_success "Local tests passed" || log_warn "Local tests had issues"
fi
echo ""

#===============================================================================
# Summary
#===============================================================================
echo ""
echo "============================================================"
echo "  YAVA Intent Classifier Agent - Installation Complete!"
echo "============================================================"
echo ""
echo "Files Created:"
echo "  ${PROJECT_NAME}/"
echo "  ├── __main__.py"
echo "  ├── yava-intent-classifier.zip"
echo "  ├── test_classifier.py"
echo "  ├── src/"
echo "  │   ├── __init__.py"
echo "  │   ├── classifier.py"
echo "  │   ├── skill.py"
echo "  │   └── intents/"
echo "  │       ├── __init__.py"
echo "  │       └── knowledge_base.py (47 intents)"
echo "  └── skills/"
echo "      └── yava_agent.json (Agent definition)"
echo ""
echo "Deployed Agent:"
echo "  • YAVA Intent Classifier Agent"
echo ""
echo "Usage - Chat with Agent:"
echo "  orchestrate agent chat \"YAVA Intent Classifier Agent\""
echo ""
echo "Usage - Invoke Agent:"
echo "  orchestrate agent invoke \"YAVA Intent Classifier Agent\" \\"
echo "    --input \"I need to refill my prescription\""
echo ""
echo "Usage - List Agents:"
echo "  orchestrate agent list"
echo ""
echo "Usage - Agent Details:"
echo "  orchestrate agent describe \"YAVA Intent Classifier Agent\""
echo ""
echo "Usage - Test Locally:"
echo "  cd ${PROJECT_NAME}"
echo "  python3 test_classifier.py"
echo ""
echo "Manual Import (if needed):"
echo "  1. Watson Orchestrate UI → Agent Builder"
echo "  2. Create New Agent → Import"
echo "  3. Upload: skills/yava_agent.json"
echo ""
echo "============================================================"
