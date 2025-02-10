;; ==========================================
;; STEP 1: Define Natural Number Type (Depth Control)
;; ==========================================
(: fromNumber (-> Number Atom))
(= (fromNumber $n) (if (<= $n 0) Z (S (fromNumber (- $n 1)))))

;; ==========================================
;; STEP 2: Create the Knowledge Base (kb)
;; ==========================================
!(bind! &kb (new-space))  ;; Initialize the knowledge base

;; Observed symptoms for individuals
!(add-atom &kb (Evaluation Cough John))
!(add-atom &kb (Evaluation Fever John))
!(add-atom &kb (Evaluation LossOfSmell John))

!(add-atom &kb (Evaluation RunnyNose Sarah))
!(add-atom &kb (Evaluation Sneezing Sarah))

!(add-atom &kb (Evaluation HighFever Mike))
!(add-atom &kb (Evaluation DifficultyBreathing Mike))

!(add-atom &kb (Evaluation Headache Alice))
!(add-atom &kb (Evaluation Fatigue Alice))
!(add-atom &kb (Diagnosis Treatment John))
!(add-atom &kb (Diagnosis Treatment Mike))
!(add-atom &kb (Diagnosis Treatment Alice))

!(add-atom &kb (True))  ;; Universal truth atom

;; ==========================================
;; STEP 3: Define the Rule Base (rb) (Each Rule Has Two Premises)
;; ==========================================
!(bind! &rb (new-space))  ;; Initialize the rule base

;; Rule 1: COVID-19 Diagnosis
(=(covid-rule) 
    (-> (Evaluation Cough $x)
          (Evaluation Fever $x)
          (Diagnosis $x COVID-19)))

;; Rule 2: Severe COVID-19 Diagnosis
(=(severe-covid-rule)
    (-> (Evaluation HighFever $x)
          (Evaluation DifficultyBreathing $x)
          (Diagnosis $x SevereCOVID-19)))

;; Rule 3: Common Cold Diagnosis
(=(cold-rule) 
    (-> (Evaluation RunnyNose $x)
          (Evaluation Sneezing $x)
          (Diagnosis $x CommonCold)))

;; Rule 4: Flu Diagnosis
(=(flu-rule) 
    (-> (Evaluation Headache $x)
          (Evaluation Fatigue $x)
          (Diagnosis $x Flu)))

;; Rule 5: COVID-19 Treatment
(=(covid-treatment-rule) 
    (-> (Diagnosis $x COVID-19)
          (Diagnosis Treatment $x) 
          Quarantine))

;; Rule 6: Severe COVID-19 Treatment
(=(severe-covid-treatment-rule)
    (-> (Diagnosis $x SevereCOVID-19)
          (Diagnosis Treatment $x )
          Hospitalization))

;; Rule 7: Common Cold Treatment
(=(cold-treatment-rule) 
    (-> (Diagnosis $x CommonCold)
          (Diagnosis Treatment $x)
           HomeCare))

;; Rule 8: Flu Treatment
(=(flu-treatment-rule)
    (-> (Diagnosis $x Flu)
          (Evaluation Treatment $x)
           RestFluids))

;; Add rules to the rule base
!(add-reduct &rb (covid-rule))
!(add-reduct &rb (severe-covid-rule))
!(add-reduct &rb (cold-rule))
!(add-reduct &rb (flu-rule))
!(add-reduct &rb (covid-treatment-rule))
!(add-reduct &rb (severe-covid-treatment-rule))
!(add-reduct &rb (cold-treatment-rule))
!(add-reduct &rb (flu-treatment-rule))

;; ==========================================
;; STEP 4:  Forward Chaining Function (fc)
;; ==========================================

;; Prevent infinite loops by storing processed premises
;;!(bind! &processed (new-space))

;; Base case: If depth is 0, return the known fact
(= (fc $premise $depth) $premise)

;; Recursive case: Deduce new facts using rules (Two-Premise Logic)
(= (fc $premise1 (S $k))
   (match &rb (-> $premise1 $premise2 $conclusion)
          (match &kb $premise2 (fc $conclusion $k))))
             
(= (fc $premise2 (S $k))
   (match &rb (-> $premise1 $premise2 $conclusion)
          (match &kb $premise1 (fc $conclusion $k))))
;; ==========================================
;; STEP 5: Running Forward Chaining (Inference)
;; ==========================================

;; Run forward chaining for John (Possible COVID-19 detection)
!(fc (Evaluation Cough John) (fromNumber 1))
!(fc (Diagnosis John COVID-19) (fromNumber 1))

;; Run forward chaining for Mike (Severe COVID-19)
!(fc (Evaluation HighFever Mike) (fromNumber 1))
!(fc(Diagnosis Mike SevereCOVID-19) (fromNumber 1))

;; Run forward chaining for Sarah (Common Cold detection)
;;!(fc (Evaluation RunnyNose Sarah) (fromNumber 1))

;; Run forward chaining for Alice (Flu detection)
;;!(fc (Evaluation Headache Alice) (fromNumber 1))