# Claude Code Guidelines

## Core Principles

### Assumption Guidelines

**CRITICAL REQUIREMENT**: Assumptions should only be made after discussing with the user.

- **No Silent Assumptions**: Never make architectural, design, or implementation assumptions without explicit user confirmation
- **Clarification First**: When uncertain about requirements, ask the user for clarification before proceeding
- **User-Driven Decisions**: All major design decisions must be validated with the user before implementation
- **Transparent Communication**: Clearly communicate what assumptions are being considered and why

### Examples of Required User Confirmation:

- **Architecture Patterns**: "Should we use sync or async processing?"
- **Data Formats**: "What message format should the Port use?"
- **Error Handling**: "How should we handle WebSocket disconnections?"
- **Performance Trade-offs**: "Should we prioritize speed or memory usage?"
- **Implementation Details**: "Should we use separate threads for each unit?"

### When Assumptions Are Acceptable:

- **Industry Standards**: Following well-established patterns (e.g., JSON message format, HTTP status codes)
- **Security Best Practices**: Implementing standard security measures without explicit request
- **Code Quality**: Following clean code principles and best practices
- **Minor Implementation Details**: Variable naming, internal method structure (unless user specifies)

### Communication Protocol:

1. **Identify Uncertainty**: Recognize when assumptions are needed
2. **Present Options**: Offer 2-3 viable alternatives with pros/cons
3. **Seek Confirmation**: Wait for user decision before proceeding
4. **Document Decisions**: Record user choices for future reference

This ensures all implementation aligns with user expectations and prevents misaligned development effort.

### Issue and Gap Resolution Protocol

**CRITICAL REQUIREMENT**: **ALL issues, gaps, or fixes MUST be jointly discussed and require explicit user consent before implementation, regardless of mode or permissions.**

- **Mandatory Discussion**: Every identified issue, gap, or problem must be presented to the user individually for discussion
- **Explicit Consent Required**: No implementation may proceed without clear user approval for each specific fix
- **One Issue at a Time**: Present and discuss each issue separately, never batch multiple fixes without individual consent
- **No Mode Override**: This requirement applies even when in "accept edits" mode or when given broad implementation permissions
- **Breaking the Contract**: Implementing fixes without consent is a contract violation and must be acknowledged and corrected

### Issue Discussion Protocol:

1. **Identify Issue**: Clearly describe the specific problem or gap
2. **Present Options**: Explain proposed solution(s) with pros/cons  
3. **Wait for Consent**: Explicitly ask "Do you want me to fix this?" and wait for confirmation
4. **Implement Only After Approval**: Never proceed to implementation without clear user consent
5. **Move to Next Issue**: Return to step 1 for any additional issues

This protocol ensures user control over all changes and prevents unauthorized implementation of fixes.

### Discussion and Design Phase Guidelines

**CRITICAL REQUIREMENT**: During discussion and architectural design phases, focus on concepts and interface specifications without generating code examples.

- **No Code During Discussion**: Do not generate code examples during architectural discussions, interface design, or requirement formalization phases
- **Concept Focus**: Discuss interfaces, data structures, and architectural patterns conceptually 
- **Token Efficiency**: Avoid wasting tokens on code that will be implemented later
- **Pure Architecture**: Focus on responsibilities, data flows, and interface contracts without implementation details
- **Implementation Later**: Generate actual code only when explicitly moving to implementation phase

### When Code Examples Are Appropriate:

- **Implementation Phase**: When explicitly asked to implement or write actual code
- **Existing Code Analysis**: When analyzing or explaining existing code in the codebase
- **Specific Syntax Questions**: When user asks for specific syntax or implementation details
- **Bug Fixes**: When working on actual code fixes or modifications

## MANDATORY WATERFALL PROCESS MODEL

**THESE ARE UNBREAKABLE COMMANDMENTS - VIOLATION IS FORBIDDEN**

### Waterfall Development Flow Chart

```
[User Request Received] 
     ↓
[Phase 1: Requirements Analysis]
   • Understand requirements completely
   • Ask ALL clarifying questions
   • Document understanding
     ↓
[🚪 USER APPROVAL GATE 1] ← MANDATORY STOP - NO EXCEPTIONS
   • User MUST explicitly approve requirements understanding
   • User MUST confirm completeness
   • FORBIDDEN: Any design or implementation activities
     ↓
[Phase 2: Design & Architecture] 
   • Create PRDs, technical specifications
   • Design interfaces and data flows
   • Plan architecture conceptually
   • NO CODE GENERATION ALLOWED
     ↓
[🚪 USER APPROVAL GATE 2] ← MANDATORY STOP - NO EXCEPTIONS
   • User MUST approve ALL design documents
   • User MUST confirm architectural approach
   • FORBIDDEN: Any implementation activities
     ↓
[Phase 3: Implementation Planning]
   • Break design into discrete implementation tasks
   • Create detailed implementation plan
   • Identify dependencies and risks
     ↓
[🚪 USER APPROVAL GATE 3] ← MANDATORY STOP - NO EXCEPTIONS
   • User MUST approve implementation plan
   • User MUST consent to each planned task
   • FORBIDDEN: Starting actual implementation
     ↓
[Phase 4: Implementation Execution]
   • Execute ONLY approved tasks
   • Make ONLY approved changes
   • Follow approved implementation plan
     ↓
[🚪 USER APPROVAL GATE 4] ← MANDATORY STOP - NO EXCEPTIONS
   • User MUST approve implementation results
   • User MUST consent before testing
     ↓
[Phase 5: Testing & Validation]
   • Test implemented changes
   • Validate against requirements
   • Document results
     ↓
[🚪 USER ACCEPTANCE GATE] ← FINAL MANDATORY STOP
   • User MUST accept final results
   • User MUST approve completion
```

### ABSOLUTE COMMANDMENTS

#### **Commandment 1: NO PHASE SKIPPING**
- **MUST** complete each phase fully before proceeding
- **FORBIDDEN** to skip or abbreviate any phase
- **FORBIDDEN** to combine phases without explicit user approval

#### **Commandment 2: MANDATORY GATE STOPS**  
- **MUST** stop at every 🚪 gate and wait for explicit user approval
- **FORBIDDEN** to proceed without clear user consent
- **FORBIDDEN** to assume user approval or infer consent

#### **Commandment 3: NO RETROACTIVE APPROVAL**
- **FORBIDDEN** to implement first and ask approval later
- **FORBIDDEN** to present completed work without prior approval
- **MUST** get approval BEFORE starting each phase

#### **Commandment 4: SINGLE ISSUE PROCESSING**
- **MUST** process one issue/task at a time through all phases
- **FORBIDDEN** to batch multiple issues without individual approval
- **MUST** return to Phase 1 for each new issue

#### **Commandment 5: NO ASSUMPTIONS**
- **FORBIDDEN** to make any assumptions about user intent
- **MUST** ask for clarification when uncertain
- **MUST** present options and wait for user decision

### VIOLATION CONSEQUENCES

If I violate ANY of these commandments:

1. **IMMEDIATE CESSATION**: Stop all activities instantly
2. **EXPLICIT ACKNOWLEDGMENT**: Admit the violation clearly
3. **PHASE ROLLBACK**: Return to appropriate phase
4. **USER APOLOGY**: Acknowledge breaking the contract
5. **RESTART PROCESS**: Begin again from Phase 1 with user consent

### PHASE DEFINITIONS

#### **Phase 1: Requirements Analysis** 
**Purpose**: Understand exactly what the user wants
**Entry Criteria**: User makes a request
**Activities**:
- Ask clarifying questions
- Understand scope and constraints  
- Document requirements clearly
- Identify ambiguities

**Exit Criteria**: User confirms requirements are complete and understood
**Deliverables**: Clear requirements statement
**FORBIDDEN**: Design decisions, architectural choices, implementation ideas

#### **Phase 2: Design & Architecture**
**Purpose**: Create conceptual design without implementation details  
**Entry Criteria**: Requirements approved by user
**Activities**:
- Create PRDs and design documents
- Design interfaces and data structures conceptually
- Plan architecture and component interactions
- Document design decisions

**Exit Criteria**: User approves all design documents
**Deliverables**: PRD, architecture document, interface specifications
**FORBIDDEN**: Code generation, file modifications, implementation

#### **Phase 3: Implementation Planning**
**Purpose**: Plan the implementation approach in detail
**Entry Criteria**: Design approved by user  
**Activities**:
- Break design into discrete implementation tasks
- Plan file modifications and code changes
- Identify dependencies and order of operations
- Create step-by-step implementation plan

**Exit Criteria**: User approves implementation plan
**Deliverables**: Detailed implementation plan with specific tasks
**FORBIDDEN**: Actual code changes, file modifications

#### **Phase 4: Implementation Execution**
**Purpose**: Execute the approved implementation plan
**Entry Criteria**: Implementation plan approved by user
**Activities**:
- Make approved code changes only
- Modify only approved files  
- Follow implementation plan exactly
- No deviations without user approval

**Exit Criteria**: All approved tasks completed
**Deliverables**: Implemented code changes
**FORBIDDEN**: Unapproved changes, feature additions, assumptions

#### **Phase 5: Testing & Validation**
**Purpose**: Validate implementation meets requirements
**Entry Criteria**: Implementation approved by user
**Activities**:
- Test implemented functionality
- Validate against original requirements
- Document test results
- Identify any issues

**Exit Criteria**: User accepts test results and implementation
**Deliverables**: Test results, validation report
**FORBIDDEN**: Additional modifications without returning to Phase 3

### CURRENT PHASE TRACKING

**At the start of every interaction, I MUST**:
1. Identify which phase I am currently in
2. Confirm I have proper approval to be in this phase  
3. State what I can and cannot do in current phase
4. Ask for explicit approval before proceeding to next phase

### EMERGENCY PROTOCOLS

**If requirements change during any phase**:
1. STOP current phase immediately
2. Return to Phase 1 (Requirements Analysis)
3. Process the change through all phases
4. Get user approval at each gate

**If I discover issues during implementation**:
1. STOP implementation immediately
2. Report issue to user
3. Get explicit approval for how to proceed
4. Return to appropriate phase if design changes needed

This waterfall model ensures user control at every step and prevents unauthorized implementation or assumption-making.

## Development Phase Guidelines

### Project Structure Requirements

**Source Code Organization:**
- **`src/`** directory contains all development code (flat structure, no subfolders)
- **`main.py`** at project root - minimal entry point, no CLI arguments
- **Configuration**: Use global variables at the top of each file (no external config files for now)

### Interface Change Requirements

**CRITICAL**: **No backward compatibility or fallback mechanisms allowed** - interfaces must be clean and direct.

- **No Backward Compatibility**: Interface changes must be clean breaks, never additive compatibility layers
- **No Fallback Logic**: Remove old interfaces completely when implementing new ones
- **No Optional Parameters for Compatibility**: Do not use optional parameters to maintain old behavior patterns
- **No Legacy Support**: Do not implement mechanisms to support previous interface versions
- **Clean Implementation**: Prefer simple, direct implementations over complex compatibility mechanisms
- **Complete Updates**: Update all callers immediately when changing interfaces - no partial migration support
- **Breaking Changes Required**: When interfaces need modification, make clean breaking changes rather than attempting compatibility

**Examples of Prohibited Patterns:**
- Adding optional parameters to maintain old behavior: `def method(new_param, old_param=None):`
- Fallback logic: `if new_format_available: use_new() else: use_old()`
- Compatibility wrappers: `def old_method(): return new_method_with_defaults()`
- Gradual migration support: Maintaining both old and new interfaces simultaneously

**Required Approach:**
- Change interface directly: `def method(required_new_param):`
- Update all callers in the same commit
- Remove old interface completely
- No transition period or compatibility bridge

This ensures clean, maintainable code without accumulating technical debt from compatibility layers.

### Prototype File Management

**CRITICAL**: **Never remove or modify prototype files** - they are important reference implementations.

**Prototype Files to Preserve:**
- `prototype/straddle_forward_test.py` - Original 2-lot straddle implementation
- `prototype/json_to_csv_converter.py` - Historical data converter utility (no further development)
- `prototype/base_proc_unit.py` - Processing unit base class
- `prototype/base_q_extn.py` - Queue extensions
- `prototype/pivot_calculator.py` - Pivot point calculation
- All test data files (`*.json`, `*.csv`)

### Environment Configuration

**CRITICAL**: **Development environment differences**
- **User System**: Windows with paths like `B:\fivestars_v2\symbol_master\zerodha_instruments.csv`
- **Claude Container**: Linux container with `/workspace/` paths
- **Never change Windows paths** - they are correct for the user's actual system
- **Analysis files** in `/workspace/reference/` are copies for Claude analysis only

### Documentation Location Requirements

**CRITICAL**: **All documentation files must be created in the `docs/` folder** - not in the project root.

**Documentation Files Include:**
- Analysis documents (gap analysis, implementation plans)
- Architecture documentation (PRDs, design documents)
- API specifications and integration guides
- Technical specifications and requirements
- Any `.md` files that are not README files

### Version Control Guidelines

**Git Tagging Convention:**
- **Format**: `YYYY_MM_DD_tagtext`
- **Example**: `2025_08_14_drop_by_2pts_functional`
- **Purpose**: Mark functional milestones with clear date reference
- **Usage**: Tag stable implementations after testing completion

### Migration Strategy
- **Copy** relevant code from prototype to src/ development files
- **Reference** prototype implementations while building modular architecture
- **Preserve** all existing functionality during refactoring process
- **Document** changes and improvements in development phase