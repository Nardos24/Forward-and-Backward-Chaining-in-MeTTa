# Forward and Backward Chaining in MeTTa

## Overview
This project implements **both forward and backward chaining** using **MeTTa** for **medical diagnosis and treatment inference**. 

- **Forward Chaining** starts with **known symptoms** and **infers possible diseases and treatments**.
- **Backward Chaining** starts with a **goal (diagnosis or treatment)** and **works backward to verify conditions**.

## How Forward Chaining Works
1. **Starts from symptoms in the Knowledge Base (KB).**
2. **Applies inference rules** (e.g., `Cough + Fever → COVID-19`).
3. **Derives diagnoses** based on symptoms.
4. **Further infers treatments based on diagnoses.**
5. **Stops when depth (`fromNumber`) reaches `Z` (zero recursion left).**

### **Example: Diagnosing and Treating John with Forward Chaining**
```lisp
!(fc (Evaluation Cough John) (fromNumber 2))
```
📌 **Step-by-Step Execution:**
1️⃣ **Checks symptoms (`Cough`, `Fever`).** ✅ Found in KB.
2️⃣ **Infers `Diagnosis John COVID-19`.** ✅
3️⃣ **Applies treatment rule `COVID-19 → Quarantine`.** ✅

**Final Output:**
```lisp
[(Diagnosis John COVID-19)]
[(Treatment John Quarantine)]
```

## How Backward Chaining Works
1. **Starts from the goal (e.g., `Diagnosis $X COVID-19`).**
2. **Finds a rule where the goal is the conclusion.**
3. **Recursively verifies the premises (e.g., `Cough` and `Fever`).**
4. **If premises hold, infers the goal.**
5. **If another goal depends on it (e.g., `COVID-19 → Quarantine`), repeats the process.**

### **Example: Diagnosing and Treating John with Backward Chaining**
```lisp
!(bc_bem (Diagnosis $X COVID-19) (fromNumber 2))
```

📌 **Step-by-Step Execution:**

### **Step 1: Base Case (Stopping Condition)**
```lisp
(= (bc_bem $conclusion $depth)
   (match &kb $conclusion $conclusion))
```
🔹 This checks:
- Is the conclusion already in the Knowledge Base (KB)?
  - If **yes**, return it and stop.
  - If **no**, move to the recursive step.

### **Step 2: Recursive Step (Searching for Rules)**
```lisp
(= (bc_bem $conclusion (S $k))
   (match &rb (-> $premise1 $premise2 $conclusion)
          (let* (($premise1 (bc_bem $premise1 $k))
                 ($premise2 (bc_bem $premise2 $k)))
            $conclusion)))
```
🔹 This means:
- **Find a rule in the Rule Base (RB) that leads to the conclusion.**
- **Recursively check if the premises (`premise1` and `premise2`) are true.**
- **If both are true, infer the conclusion.**

### **Step 3: Find a Rule That Matches `Diagnosis $X COVID-19`**
The system searches for a rule in `rb` where `Diagnosis $X COVID-19` is the conclusion.
```lisp
(=(covid-rule) 
    (-> (Evaluation Cough $X) 
          (Evaluation Fever $X) 
          (Diagnosis $X COVID-19)))
```
🔹 **This means:**
- If someone has **Cough AND Fever**, they have **COVID-19**.
- Now, the system must check both premises recursively.

### **Step 4: Check `Evaluation Cough $X` (First Premise)**
```lisp
(bc_bem (Evaluation Cough $X) (fromNumber 1))
```
🔹 **Base Case Check:**
- **Is `Evaluation Cough $X` in KB?** ✅ Yes, for John.
- **Stop recursion for this premise.**

✔ **Confirmed:**
```lisp
(Evaluation Cough John)
```

### **Step 5: Check `Evaluation Fever $X` (Second Premise)**
```lisp
(bc_bem (Evaluation Fever $X) (fromNumber 1))
```
🔹 **Base Case Check:**
- **Is `Evaluation Fever $X` in KB?** ✅ Yes, for John.
- **Stop recursion for this premise.**

✔ **Confirmed:**
```lisp
(Evaluation Fever John)
```

### **Step 6: Infer `Diagnosis John COVID-19`**
Since **both premises are true**, we can now infer:
```lisp
(Diagnosis John COVID-19)
```
✔ **Backward chaining successfully proves that John has COVID-19.**

### **Step 7: Return Final Result**
📌 **The final output will be:**
```lisp
[(Diagnosis John COVID-19)]
```
🚀 **Success! We found a person (`John`) who has COVID-19.**

## Summary
- **Forward Chaining** starts from **known facts** and **infers new conclusions**.
- **Backward Chaining** starts from **a goal** and **checks for supporting facts**.
- **Depth (`fromNumber`) controls recursion**, preventing infinite loops.
- **Both methods correctly diagnose and treat John based on `Cough` and `Fever`.**

## Running the Inference
To check diagnoses and treatments, clone the repository and navigate to the directory:
```sh
git clone https://github.com/Nardos24/Forward-and-Backward-Chaining-in-MeTTa.git
cd Forward and Backward Chaining in MeTTa
```
To run **Forward Chaining**:
```sh
metta fc.metta
```
To run **Backward Chaining**:
```sh
metta bc.metta
```
This system efficiently **combines forward and backward reasoning** for medical inference!

