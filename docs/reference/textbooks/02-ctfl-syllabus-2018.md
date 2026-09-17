# CTFL Syllabus 2018 GA

> Converted from original textbook file. Formatting simplified.

## Page 1

Certified Tester Foundation Level Syllabus
Version 2018 Version
International Software Testing Qualifications Board

## Page 2

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 2 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
Copyright Notice
This document may be copied in its entirety, or extracts made, if the source is acknowledged.
Copyright Notice © International Software Testing Qualifications Board (hereinafter called ISTQB®)
ISTQB is a registered trademark of the International Software Testing Qualifications Board.
Copyright © 2018 the authors for the update 2018 Klaus Olsen (chair), Tauhida Parveen (vice chair), Rex
Black (project manager), Debra Friedenberg, Matthias Hamburg, Judy McKay, Meile Posthuma, Hans
Schaefer, Radoslaw Smilgin, Mike Smith, Steve Toms, Stephanie Ulrich, Marie Walsh, and Eshraka
Zakaria.
Copyright © 2011 the authors for the update 2011 Thomas Müller (chair), Debra Friedenberg, and the
ISTQB WG Foundation Level.
Copyright © 2010 the authors for the update 2010 Thomas Müller (chair), Armin Beer, Martin Klonk, and
Rahul Verma.
Copyright © 2007 the authors for the update 2007 Thomas Müller (chair), Dorothy Graham, Debra
Friedenberg and Erik van Veenendaal.
Copyright © 2005, the authors Thomas Müller (chair), Rex Black, Sigrid Eldh, Dorothy Graham, Klaus
Olsen, Maaret Pyhäjärvi, Geoff Thompson, and Erik van Veenendaal.
All rights reserved.
The authors hereby transfer the copyright to the International Software Testing Qualifications Board
(ISTQB). The authors (as current copyright holders) and ISTQB (as the future copyright holder) have
agreed to the following conditions of use:
Any individual or training company may use this syllabus as the basis for a training course if the authors
and the ISTQB are acknowledged as the source and copyright owners of the syllabus and provided that
any advertisement of such a training course may mention the syllabus only after submission for official
accreditation of the training materials to an ISTQB recognized Member Board.
Any individual or group of individuals may use this syllabus as the basis for articles, books, or other
derivative writings if the authors and the ISTQB are acknowledged as the source and copyright owners of
the syllabus.
Any ISTQB-recognized Member Board may translate this syllabus and license the syllabus (or its translation) to other parties.

## Page 3

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 3 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
Revision History
Version Date Remarks
ISTQB 2018 27-April-2018
Candidate general release version ISTQB 2018 12-February-2018
Candidate beta version ISTQB 2018 19-January-2018
Cross-review internal version 3.0. ISTQB 2018 15-January-2018
Pre-cross-review internal version 2.9, incorporating Core
Team edits. ISTQB 2018 9-December-2017
Alpha review 2.5 release – Technical edit of 2.0 release,
no new content added ISTQB 2018 22-November-2017
Alpha review 2.0 release – Certified Tester Foundation
Level Syllabus Major Update 2018 – see Appendix C –
Release Notes for details ISTQB 2018 12-June-2017
Alpha review release - Certified Tester Foundation Level Syllabus Major Update 2018 – see Appendix C
–
Release Notes ISTQB 2011 1-Apr-2011
Certified Tester Foundation Level Syllabus Maintenance
Release – see Release Notes ISTQB 2010 30-Mar-2010
Certified Tester Foundation Level Syllabus Maintenance
Release – see Release Notes ISTQB 2007 01-May-2007
Certified Tester Foundation Level Syllabus Maintenance
Release ISTQB 2005 01-July-2005
Certified Tester Foundation Level Syllabus ASQF V2.2 July-2003
ASQF Syllabus Foundation Level Version 2.2 “Lehrplan
Grundlagen des Software-testens“ ISEB V2.0 25-Feb-1999 ISEB Software Testing Foundation Syllabus V2.0

## Page 4

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 4 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
Table of Contents
Copyright Notice............................................................................................................................................ 2
Revision History ............................................................................................................................................ 3
Table of Contents.......................................................................................................................................... 4
Acknowledgements ....................................................................................................................................... 7 0
Introduction........................................................................................................................................... 9 0.1
Purpose of this Syllabus .............................................................................................................. 9 0.2
The Certified Tester Foundation Level in Software Testing ........................................................ 9 0.3
Examinable Learning Objectives and Cognitive Levels of Knowledge ..................................... 10 0.4
The Foundation Level Certificate Exam .................................................................................... 10 0.5
Accreditation .............................................................................................................................. 10 0.6
Level of Detail ............................................................................................................................ 11 0.7
How this Syllabus is Organized ................................................................................................. 11 1
Fundamentals of Testing.................................................................................................................... 12 1.1
What is Testing? ........................................................................................................................ 13 1.1.1
Typical Objectives of Testing ................................................................................................ 13 1.1.2
Testing and Debugging ......................................................................................................... 14 1.2
Why is Testing Necessary? ....................................................................................................... 14 1.2.1
Testing’s Contributions to Success ....................................................................................... 14 1.2.2
Quality Assurance and Testing ............................................................................................. 15 1.2.3
Errors, Defects, and Failures................................................................................................. 15 1.2.4
Defects, Root Causes and Effects ........................................................................................ 16 1.3
Seven Testing Principles ........................................................................................................... 16 1.4
Test Process .............................................................................................................................. 17 1.4.1
Test Process in Context ........................................................................................................ 17 1.4.2
Test Activities and Tasks....................................................................................................... 18 1.4.3
Test Work Products............................................................................................................... 22 1.4.4
Traceability between the Test Basis and Test Work Products.............................................. 24 1.5
The Psychology of Testing ........................................................................................................ 25 1.5.1
Human Psychology and Testing............................................................................................ 25 1.5.2
Tester’s and Developer’s Mindsets ....................................................................................... 25 2
Testing Throughout the Software Development Lifecycle.................................................................. 27 2.1
Software Development Lifecycle Models................................................................................... 28 2.1.1
Software Development and Software Testing....................................................................... 28 2.1.2
Software Development Lifecycle Models in Context ............................................................. 29 2.2
Test Levels................................................................................................................................. 30 2.2.1
Component Testing ............................................................................................................... 31 2.2.2
Integration Testing................................................................................................................. 32 2.2.3
System Testing...................................................................................................................... 34 2.2.4
Acceptance Testing............................................................................................................... 36 2.3
Test Types ................................................................................................................................. 39 2.3.1
Functional Testing ................................................................................................................. 39 2.3.2
Non-functional Testing .......................................................................................................... 40 2.3.3
White-box Testing ................................................................................................................. 40 2.3.4
Change-related Testing......................................................................................................... 41 2.3.5 Test Types and Test Levels .................................................................................................. 41

## Page 5

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 5 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
2.4
Maintenance Testing ................................................................................................................. 42 2.4.1
Triggers for Maintenance ...................................................................................................... 43 2.4.2
Impact Analysis for Maintenance .......................................................................................... 43 3
Static Testing...................................................................................................................................... 45 3.1
Static Testing Basics ................................................................................................................. 46 3.1.1
Work Products that Can Be Examined by Static Testing ...................................................... 46 3.1.2
Benefits of Static Testing....................................................................................................... 46 3.1.3
Differences between Static and Dynamic Testing................................................................. 47 3.2
Review Process ......................................................................................................................... 48 3.2.1
Work Product Review Process.............................................................................................. 48 3.2.2
Roles and responsibilities in a formal review ........................................................................ 49 3.2.3
Review Types ........................................................................................................................ 50 3.2.4
Applying Review Techniques ................................................................................................ 52 3.2.5
Success Factors for Reviews ................................................................................................ 53 4
Test Techniques ................................................................................................................................. 55 4.1
Categories of Test Techniques.................................................................................................. 56 4.1.1
Choosing Test Techniques.................................................................................................... 56 4.1.2
Categories of Test Techniques and Their Characteristics .................................................... 57 4.2
Black-box Test Techniques ....................................................................................................... 58 4.2.1
Equivalence Partitioning........................................................................................................ 58 4.2.2
Boundary Value Analysis ...................................................................................................... 58 4.2.3
Decision Table Testing.......................................................................................................... 59 4.2.4
State Transition Testing ........................................................................................................ 60 4.2.5
Use Case Testing.................................................................................................................. 60 4.3
White-box Test Techniques ....................................................................................................... 60 4.3.1
Statement Testing and Coverage.......................................................................................... 61 4.3.2
Decision Testing and Coverage ............................................................................................ 61 4.3.3
The Value of Statement and Decision Testing...................................................................... 61 4.4
Experience-based Test Techniques .......................................................................................... 61 4.4.1
Error Guessing ...................................................................................................................... 61 4.4.2
Exploratory Testing ............................................................................................................... 62 4.4.3
Checklist-based Testing ........................................................................................................ 62 5
Test Management............................................................................................................................... 63 5.1
Test Organization ...................................................................................................................... 64 5.1.1
Independent Testing.............................................................................................................. 64 5.1.2
Tasks of a Test Manager and Tester .................................................................................... 65 5.2
Test Planning and Estimation .................................................................................................... 67 5.2.1
Purpose and Content of a Test Plan ..................................................................................... 67 5.2.2
Test Strategy and Test Approach.......................................................................................... 67 5.2.3
Entry Criteria and Exit Criteria (Definition of Ready and Definition of Done)........................ 68 5.2.4
Test Execution Schedule....................................................................................................... 69 5.2.5
Factors Influencing the Test Effort ........................................................................................ 69 5.2.6
Test Estimation Techniques .................................................................................................. 70 5.3
Test Monitoring and Control ...................................................................................................... 71 5.3.1
Metrics Used in Testing......................................................................................................... 71 5.3.2
Purposes, Contents, and Audiences for Test Reports .......................................................... 72 5.4
Configuration Management ....................................................................................................... 73 5.5
Risks and Testing ...................................................................................................................... 73 5.5.1
Definition of Risk.................................................................................................................... 73 5.5.2
Product and Project Risks ..................................................................................................... 73 5.5.3 Risk-based Testing and Product Quality............................................................................... 75

## Page 6

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 6 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
5.6
Defect Management .................................................................................................................. 76 6
Tool Support for Testing..................................................................................................................... 78 6.1
Test Tool Considerations........................................................................................................... 79 6.1.1
Test Tool Classification ......................................................................................................... 79 6.1.2
Benefits and Risks of Test Automation ................................................................................. 81 6.1.3
Special Considerations for Test Execution and Test Management Tools ............................ 82 6.2
Effective Use of Tools................................................................................................................ 83 6.2.1
Main Principles for Tool Selection ......................................................................................... 83 6.2.2
Pilot Projects for Introducing a Tool into an Organization..................................................... 84 6.2.3
Success Factors for Tools..................................................................................................... 84 7
References ......................................................................................................................................... 85
Standards................................................................................................................................................ 85
ISTQB documents .................................................................................................................................. 85
Books and Articles .................................................................................................................................. 86
Other Resources (not directly referenced in this Syllabus) .................................................................... 87 8
Appendix A – Syllabus Background ................................................................................................... 88
History of this Document......................................................................................................................... 88
Objectives of the Foundation Certificate Qualification............................................................................ 88
Objectives of the International Qualification ........................................................................................... 88
Entry Requirements for this Qualification ............................................................................................... 89
Background and History of the Foundation Certificate in Software Testing........................................... 89 9
Appendix B – Learning Objectives/Cognitive Level of Knowledge .................................................... 90
Level 1: Remember (K1)......................................................................................................................... 90
Level 2: Understand (K2)........................................................................................................................ 90
Level 3: Apply (K3) ................................................................................................................................. 90 10
Appendix C – Release Notes ............................................................................................................. 91 11 Index................................................................................................................................................... 92

## Page 7

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 7 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
Acknowledgements
This document was formally released by the General Assembly of the ISTQB (4 June 2018).
It was produced by a team from the International Software Testing Qualifications Board: Klaus Olsen
(chair), Tauhida Parveen (vice chair), Rex Black (project manager), Debra Friedenberg, Judy McKay,
Meile Posthuma, Hans Schaefer, Radoslaw Smilgin, Mike Smith, Steve Toms, Stephanie Ulrich, Marie
Walsh, and Eshraka Zakaria.
The team thanks Rex Black and Dorothy Graham for their technical editing, and the review team, the
cross-review team, and the Member Boards for their suggestions and input.
The following persons participated in the reviewing, commenting and balloting of this syllabus: Tom
Adams, Tobias Ahlgren, Xu Aiguo, Chris Van Bael, Katalin Balla, Graham Bath, Gualtiero Bazzana, Arne
Becher, Veronica Belcher, Lars Hilmar Bjørstrup, Ralf Bongard, Armin Born, Robert Bornelind, Mette
Bruhn-Pedersen, Geza Bujdoso, Earl Burba, Filipe Carlos, Young Jae Choi, Greg Collina, Alessandro
Collino, Cui Zhe, Taz Daughtrey, Matthias Daigl, Wim Decoutere, Frans Dijkman, Klaudia Dussa-Zieger,
Yonit Elbaz, Ofer Feldman, Mark Fewster, Florian Fieber, David Frei, Debra Friedenberg, Conrad
Fujimoto, Pooja Gautam, Thorsten Geiselhart, Chen Geng, Christian Alexander Graf, Dorothy Graham,
Michel Grandjean, Richard Green, Attila Gyuri, Jon Hagar, Kobi Halperin, Matthias Hamburg, Zsolt
Hargitai, Satoshi Hasegawa, Berit Hatten, Wang Hongwei, Tamás Horváth, Leanne Howard, Chinthaka
Indikadahena, J. Jayapradeep, Kari Kakkonen, Gábor Kapros, Beata Karpinska, Karl Kemminger,
Kwanho Kim, Seonjoon Kim, Cecilia Kjellman, Johan Klintin, Corne Kruger, Gerard Kruijff, Peter Kunit,
Hyeyong Kwon, Bruno Legeard, Thomas Letzkus, Alon Linetzki, Balder Lingegård, Tilo Linz, Hongbiao
Liu, Claire Lohr, Ine Lutterman, Marek Majernik, Rik Marselis, Romanos Matthaios, Judy McKay, Fergus
McLachlan, Dénes Medzihradszky, Stefan Merkel, Armin Metzger, Don Mills, Gary Mogyorodi, Ninna
Morin, Ingvar Nordström, Adam Novak, Avi Ofer, Magnus C Ohlsson, Joel Oliviera, Monika Stocklein
Olsen, Kenji Onishi, Francisca Cano Ortiz, Gitte Ottosen, Tuula Pääkkönen, Ana Paiva, Tal Pe'er, Helmut
Pichler, Michaël Pilaeten, Horst Pohlmann, Andrew Pollner, Meile Posthuma, Vitalijs Puiso, Salvatore
Reale, Stuart Reid, Ralf Reissing, Shark Ren, Miroslav Renda, Randy Rice, Adam Roman, Jan Sabak,
Hans Schaefer, Ina Schieferdecker, Franz Schiller, Jianxiong Shen, Klaus Skafte, Mike Smith, Cristina
Sobrero, Marco Sogliani, Murian Song, Emilio Soresi, Helder Sousa, Michael Sowers, Michael Stahl,
Lucjan Stapp, Li Suyuan, Toby Thompson, Steve Toms, Sagi Traybel, Sabine Uhde, Stephanie Ulrich,
Philippos Vakalakis, Erik van Veenendaal, Marianne Vesterdal, Ernst von Düring, Salinda
Wickramasinghe, Marie Walsh, Søren Wassard, Hans Weiberg, Paul Weymouth, Hyungjin Yoon, John
Young, Surong Yuan, Ester Zabar, and Karolina Zmitrowicz.
International Software Testing Qualifications Board Working Group Foundation Level (Edition 2018): Klaus
Olsen (chair), Tauhida Parveen (vice chair), Rex Black (project manager), Dani Almog, Debra Friedenberg,
Rashed Karim, Johan Klintin, Vipul Kocher, Corne Kruger, Sunny Kwon, Judy McKay, Thomas Müller, Igal
Levi, Ebbe Munk, Kenji Onishi, Meile Posthuma, Eric Riou du Cosquer, Hans Schaefer, Radoslaw Smilgin,
Mike Smith, Steve Toms, Stephanie Ulrich, Marie Walsh, Eshraka Zakaria, and Stevan Zivanovic. The core
team thanks the review team and all Member Boards for their suggestions.
International Software Testing Qualifications Board Working Group Foundation Level (Edition 2011):
Thomas Müller (chair), Debra Friedenberg. The core team thanks the review team (Dan Almog, Armin
Beer, Rex Black, Julie Gardiner, Judy McKay, Tuula Pääkkönen, Eric Riou du Cosquier Hans Schaefer,
Stephanie Ulrich, Erik van Veenendaal), and all Member Boards for their suggestions.
International Software Testing Qualifications Board Working Group Foundation Level (Edition 2010):
Thomas Müller (chair), Rahul Verma, Martin Klonk and Armin Beer. The core team thanks the review team (Rex Black, Mette Bruhn-Pederson, Debra Friedenberg, Klaus Olsen, Judy McKay, Tuula

## Page 8

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 8 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
Pääkkönen, Meile Posthuma, Hans Schaefer, Stephanie Ulrich, Pete Williams, Erik van Veenendaal), and
all Member Boards for their suggestions.
International Software Testing Qualifications Board Working Group Foundation Level (Edition 2007):
Thomas Müller (chair), Dorothy Graham, Debra Friedenberg, and Erik van Veenendaal. The core team
thanks the review team (Hans Schaefer, Stephanie Ulrich, Meile Posthuma, Anders Pettersson, and
Wonil Kwon) and all the Member Boards for their suggestions.
International Software Testing Qualifications Board Working Group Foundation Level (Edition 2005):
Thomas Müller (chair), Rex Black, Sigrid Eldh, Dorothy Graham, Klaus Olsen, Maaret Pyhäjärvi, Geoff
Thompson and Erik van Veenendaal. The core team thanks the review team and all Member Boards for their suggestions.

## Page 9

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 9 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
0 Introduction
0.1 Purpose of this Syllabus
This syllabus forms the basis for the International Software Testing Qualification at the Foundation Level.
The ISTQB provides this syllabus as follows: 1.
To member boards, to translate into their local language and to accredit training providers.
Member boards may adapt the syllabus to their particular language needs and add references to
adapt to their local publications. 2.
To certification bodies, to derive examination questions in their local language adapted to the
learning objectives for this syllabus. 3.
To training providers, to produce courseware and determine appropriate teaching methods. 4.
To certification candidates, to prepare for the certification exam (either as part of a training course
or independently). 5.
To the international software and systems engineering community, to advance the profession of
software and systems testing, and as a basis for books and articles.
The ISTQB may allow other entities to use this syllabus for other purposes, provided they seek and obtain
prior written permission from the ISTQB.
0.2 The Certified Tester Foundation Level in Software Testing
The Foundation Level qualification is aimed at anyone involved in software testing. This includes people
in roles such as testers, test analysts, test engineers, test consultants, test managers, user acceptance
testers, and software developers. This Foundation Level qualification is also appropriate for anyone who
wants a basic understanding of software testing, such as product owners, project managers, quality
managers, software development managers, business analysts, IT directors and management
consultants. Holders of the Foundation Certificate will be able to go on to higher-level software testing
qualifications.
The ISTQB Foundation Level Overview 2018 is a separate document which includes the following information:
 Business outcomes for the syllabus
 Matrix showing traceability between business outcomes and learning objectives
 Summary of this syllabus

## Page 10

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 10 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
0.3 Examinable Learning Objectives and Cognitive Levels of Knowledge
Learning objectives support the business outcomes and are used to create the Certified Tester
Foundation Level exams.
In general, all contents of this syllabus are examinable at a K1 level, except for the Introduction and
Appendices. That is, the candidate may be asked to recognize, remember, or recall a keyword or concept
mentioned in any of the six chapters. The knowledge levels of the specific learning objectives are shown at the beginning of each chapter, and classified as follows:
 K1: remember
 K2: understand

K3: apply
Further details and examples of learning objectives are given in Appendix B.
The definitions of all terms listed as keywords just below chapter headings shall be remembered (K1),
even if not explicitly mentioned in the learning objectives.
0.4 The Foundation Level Certificate Exam
The Foundation Level Certificate exam will be based on this syllabus. Answers to exam questions may
require the use of material based on more than one section of this syllabus. All sections of the syllabus
are examinable, except for the Introduction and Appendices. Standards, books, and other ISTQB syllabi
are included as references, but their content is not examinable, beyond what is summarized in this
syllabus itself from such standards, books, and other ISTQB syllabi.
The format of the exam is multiple choice. There are 40 questions. To pass the exam, at least 65% of the
questions (i.e., 26 questions) must be answered correctly.
Exams may be taken as part of an accredited training course or taken independently (e.g., at an exam
center or in a public exam). Completion of an accredited training course is not a pre-requisite for the
exam.
0.5 Accreditation
An ISTQB Member Board may accredit training providers whose course material follows this syllabus.
Training providers should obtain accreditation guidelines from the Member Board or body that performs
the accreditation. An accredited course is recognized as conforming to this syllabus, and is allowed to have an ISTQB exam as part of the course.

## Page 11

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 11 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
0.6 Level of Detail
The level of detail in this syllabus allows internationally consistent courses and exams. In order to achieve this goal, the syllabus consists of:
 General instructional objectives describing the intention of the Foundation Level
 A list of terms that students must be able to recall

Learning objectives for each knowledge area, describing the cognitive learning outcome to be achieved

A description of the key concepts, including references to sources such as accepted literature or
standards
The syllabus content is not a description of the entire knowledge area of software testing; it reflects the
level of detail to be covered in Foundation Level training courses. It focuses on test concepts and
techniques that can apply to all software projects, including Agile projects. This syllabus does not contain
any specific learning objectives related to any particular software development lifecycle or method, but it
does discuss how these concepts apply in Agile projects, other types of iterative and incremental
lifecycles, and in sequential lifecycles.
0.7 How this Syllabus is Organized
There are six chapters with examinable content. The top-level heading for each chapter specifies the time
for the chapter; timing is not provided below chapter level. For accredited training courses, the syllabus requires a minimum of 16.75 hours of instruction, distributed across the six chapters as follows:
 Chapter 1: 175 minutes Fundamentals of Testing
 Chapter 2: 100 minutes Testing Throughout the Software Development Lifecycle
 Chapter 3: 135 minutes Static Testing
 Chapter 4: 330 minutes Test Techniques
 Chapter 5: 225 minutes Test Management
 Chapter 6: 40 minutes Tool Support for Testing

## Page 12

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 12 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
1 Fundamentals of Testing
175 minutes Keywords
coverage, debugging, defect, error, failure, quality, quality assurance, root cause, test analysis, test basis,
test case, test completion, test condition, test control, test data, test design, test execution, test execution
schedule, test implementation, test monitoring, test object, test objective, test oracle, test planning, test procedure, test suite, testing, testware, traceability, validation, verification
Learning Objectives for Fundamentals of Testing: 1.1 What is Testing?
FL-1.1.1
(K1) Identify typical objectives of testing FL-1.1.2 (K2) Differentiate testing from debugging
1.2 Why is Testing Necessary?
FL-1.2.1
(K2) Give examples of why testing is necessary FL-1.2.2
(K2) Describe the relationship between testing and quality assurance and give examples
of how testing contributes to higher quality FL-1.2.3
(K2) Distinguish between error, defect, and failure FL-1.2.4 (K2) Distinguish between the root cause of a defect and its effects
1.3 Seven Testing Principles
FL-1.3.1 (K2) Explain the seven testing principles
1.4 Test Process
FL-1.4.1
(K2) Explain the impact of context on the test process FL-1.4.2
(K2) Describe the test activities and respective tasks within the test process FL-1.4.3
(K2) Differentiate the work products that support the test process FL-1.4.4
(K2) Explain the value of maintaining traceability between the test basis and test work products
1.5 The Psychology of Testing
FL-1.5.1
(K1) Identify the psychological factors that influence the success of testing FL-1.5.2
(K2) Explain the difference between the mindset required for test activities and the mindset required for development activities

## Page 13

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 13 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
1.1 What is Testing?
Software systems are an integral part of life, from business applications (e.g., banking) to consumer
products (e.g., cars). Most people have had an experience with software that did not work as expected.
Software that does not work correctly can lead to many problems, including loss of money, time, or
business reputation, and even injury or death. Software testing is a way to assess the quality of the
software and to reduce the risk of software failure in operation.
A common misperception of testing is that it only consists of running tests, i.e., executing the software
and checking the results. As described in section 1.4, software testing is a process which includes many
different activities; test execution (including checking of results) is only one of these activities. The test
process also includes activities such as test planning, analyzing, designing, and implementing tests,
reporting test progress and results, and evaluating the quality of a test object.
Some testing does involve the execution of the component or system being tested; such testing is called
dynamic testing. Other testing does not involve the execution of the component or system being tested;
such testing is called static testing. So, testing also includes reviewing work products such as
requirements, user stories, and source code.
Another common misperception of testing is that it focuses entirely on verification of requirements, user
stories, or other specifications. While testing does involve checking whether the system meets specified
requirements, it also involves validation, which is checking whether the system will meet user and other
stakeholder needs in its operational environment(s). Test activities are organized and carried out differently in different lifecycles (see section 2.1).
1.1.1 Typical Objectives of Testing
For any given project, the objectives of testing may include:
 To evaluate work products such as requirements, user stories, design, and code
 To verify whether all specified requirements have been fulfilled

To validate whether the test object is complete and works as the users and other stakeholders expect
 To build confidence in the level of quality of the test object
 To prevent defects
 To find failures and defects

To provide sufficient information to stakeholders to allow them to make informed decisions, especially regarding the level of quality of the test object

To reduce the level of risk of inadequate software quality (e.g., previously undetected failures occurring in operation)

To comply with contractual, legal, or regulatory requirements or standards, and/or to verify the
test object’s compliance with such requirements or standards
The objectives of testing can vary, depending upon the context of the component or system being tested, the test level, and the software development lifecycle model. These differences may include, for example:

## Page 14

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 14 of 96
4 June 2018 © International Software Testing Qualifications Board For public release

During component testing, one objective may be to find as many failures as possible so that the
underlying defects are identified and fixed early. Another objective may be to increase code coverage of the component tests.

During acceptance testing, one objective may be to confirm that the system works as expected
and satisfies requirements. Another objective of this testing may be to give information to stakeholders about the risk of releasing the system at a given time.
1.1.2 Testing and Debugging
Testing and debugging are different. Executing tests can show failures that are caused by defects in the
software. Debugging is the development activity that finds, analyzes, and fixes such defects. Subsequent
confirmation testing checks whether the fixes resolved the defects. In some cases, testers are
responsible for the initial test and the final confirmation test, while developers do the debugging and
associated component testing. However, in Agile development and in some other lifecycles, testers may
be involved in debugging and component testing.
ISO standard (ISO/IEC/IEEE 29119-1) has further information about software testing concepts.
1.2 Why is Testing Necessary?
Rigorous testing of components and systems, and their associated documentation, can help reduce the
risk of failures occurring during operation. When defects are detected, and subsequently fixed, this
contributes to the quality of the components or systems. In addition, software testing may also be required to meet contractual or legal requirements or industry-specific standards.
1.2.1 Testing’s Contributions to Success
Throughout the history of computing, it is quite common for software and systems to be delivered into
operation and, due to the presence of defects, to subsequently cause failures or otherwise not meet the
stakeholders’ needs. However, using appropriate test techniques can reduce the frequency of such
problematic deliveries, when those techniques are applied with the appropriate level of test expertise, in
the appropriate test levels, and at the appropriate points in the software development lifecycle. Examples include:

Having testers involved in requirements reviews or user story refinement could detect defects in
these work products. The identification and removal of requirements defects reduces the risk of incorrect or untestable functionality being developed.

Having testers work closely with system designers while the system is being designed can
increase each party’s understanding of the design and how to test it. This increased
understanding can reduce the risk of fundamental design defects and enable tests to be identified at an early stage.

Having testers work closely with developers while the code is under development can increase
each party’s understanding of the code and how to test it. This increased understanding can reduce the risk of defects within the code and the tests.

Having testers verify and validate the software prior to release can detect failures that might
otherwise have been missed, and support the process of removing the defects that caused the
failures (i.e., debugging). This increases the likelihood that the software meets stakeholder needs and satisfies requirements.

## Page 15

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 15 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
In addition to these examples, the achievement of defined test objectives (see section 1.1.1) contributes to overall software development and maintenance success.
1.2.2 Quality Assurance and Testing
While people often use the phrase quality assurance (or just QA
) to refer to testing, quality assurance and
testing are not the same, but they are related. A larger concept, quality management, ties them together.
Quality management includes all activities that direct and control an organization with regard to quality.
Among other activities, quality management includes both quality assurance and quality control. Quality
assurance is typically focused on adherence to proper processes, in order to provide confidence that the
appropriate levels of quality will be achieved. When processes are carried out properly, the work products
created by those processes are generally of higher quality, which contributes to defect prevention. In
addition, the use of root cause analysis to detect and remove the causes of defects, along with the proper
application of the findings of retrospective meetings to improve processes, are important for effective
quality assurance.
Quality control involves various activities, including test activities, that support the achievement of
appropriate levels of quality. Test activities are part of the overall software development or maintenance
process. Since quality assurance is concerned with the proper execution of the entire process, quality
assurance supports proper testing. As described in sections 1.1.1 and 1.2.1, testing contributes to the achievement of quality in a variety of ways.
1.2.3 Errors, Defects, and Failures
A person can make an error (mistake), which can lead to the introduction of a defect (fault or bug) in the
software code or in some other related work product. An error that leads to the introduction of a defect in
one work product can trigger an error that leads to the introduction of a defect in a related work product.
For example, a requirements elicitation error can lead to a requirements defect, which then results in a
programming error that leads to a defect in the code.
If a defect in the code is executed, this may cause a failure, but not necessarily in all circumstances. For
example, some defects require very specific inputs or preconditions to trigger a failure, which may occur
rarely or never. Errors may occur for many reasons, such as:
 Time pressure
 Human fallibility
 Inexperienced or insufficiently skilled project participants

Miscommunication between project participants, including miscommunication about requirements and design

Complexity of the code, design, architecture, the underlying problem to be solved, and/or the technologies used

Misunderstandings about intra-system and inter-system interfaces, especially when such intra- system and inter-system interactions are large in number

New, unfamiliar technologies
In addition to failures caused due to defects in the code, failures can also be caused by environmental
conditions. For example, radiation, electromagnetic fields, and pollution can cause defects in firmware or influence the execution of software by changing hardware conditions.

## Page 16

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 16 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
Not all unexpected test results are failures. False positives may occur due to errors in the way tests were
executed, or due to defects in the test data, the test environment, or other testware, or for other reasons.
The inverse situation can also occur, where similar errors or defects lead to false negatives. False
negatives are tests that do not detect defects that they should have detected; false positives are reported as defects, but aren’t actually defects.
1.2.4 Defects, Root Causes and Effects
The root causes of defects are the earliest actions or conditions that contributed to creating the defects.
Defects can be analyzed to identify their root causes, so as to reduce the occurrence of similar defects in
the future. By focusing on the most significant root causes, root cause analysis can lead to process
improvements that prevent a significant number of future defects from being introduced.
For example, suppose incorrect interest payments, due to a single line of incorrect code, result in
customer complaints. The defective code was written for a user story which was ambiguous, due to the
product owner’s misunderstanding of how to calculate interest. If a large percentage of defects exist in
interest calculations, and these defects have their root cause in similar misunderstandings, the product
owners could be trained in the topic of interest calculations to reduce such defects in the future.
In this example, the customer complaints are effects. The incorrect interest payments are failures. The
improper calculation in the code is a defect, and it resulted from the original defect, the ambiguity in the
user story. The root cause of the original defect was a lack of knowledge on the part of the product owner,
which resulted in the product owner making a mistake while writing the user story. The process of root
cause analysis is discussed in ISTQB-ETM Expert Level Test Management Syllabus and ISTQB-EITP
Expert Level Improving the Test Process Syllabus.
1.3 Seven Testing Principles
A number of testing principles have been suggested over the past 50 years and offer general guidelines common for all testing.
1. Testing shows the presence of defects, not their absence
Testing can show that defects are present, but cannot prove that there are no defects. Testing reduces
the probability of undiscovered defects remaining in the software but, even if no defects are found, testing is not a proof of correctness.
2. Exhaustive testing is impossible
Testing everything (all combinations of inputs and preconditions) is not feasible except for trivial cases.
Rather than attempting to test exhaustively, risk analysis, test techniques, and priorities should be used to focus test efforts.
3. Early testing saves time and money
To find defects early, both static and dynamic test activities should be started as early as possible in the software development lifecycle. Early testing is sometimes referred to as shift left
. Testing early in the software development lifecycle helps reduce or eliminate costly changes (see section 3.1).
4. Defects cluster together
A small number of modules usually contains most of the defects discovered during pre-release testing, or
is responsible for most of the operational failures. Predicted defect clusters, and the actual observed
defect clusters in test or operation, are an important input into a risk analysis used to focus the test effort (as mentioned in principle 2).

## Page 17

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 17 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
5. Beware of the pesticide paradox
If the same tests are repeated over and over again, eventually these tests no longer find any new defects.
To detect new defects, existing tests and test data may need changing, and new tests may need to be
written. (Tests are no longer effective at finding defects, just as pesticides are no longer effective at killing
insects after a while.) In some cases, such as automated regression testing, the pesticide paradox has a beneficial outcome, which is the relatively low number of regression defects.
6. Testing is context dependent
Testing is done differently in different contexts. For example, safety-critical industrial control software is
tested differently from an e-commerce mobile app. As another example, testing in an Agile project is done differently than testing in a sequential lifecycle project (see section 2.1).
7. Absence-of-errors is a fallacy
Some organizations expect that testers can run all possible tests and find all possible defects, but
principles 2 and 1, respectively, tell us that this is impossible. Further, it is a fallacy (i.e., a mistaken belief) to expect that just
finding and fixing a large number of defects will ensure the success of a system. For
example, thoroughly testing all specified requirements and fixing all defects found could still produce a
system that is difficult to use, that does not fulfill the users’ needs and expectations, or that is inferior
compared to other competing systems.
See Myers 2011, Kaner 2002, and Weinberg 2008 for examples of these and other testing principles.
1.4 Test Process
There is no one universal software test process, but there are common sets of test activities without which
testing will be less likely to achieve its established objectives. These sets of test activities are a test
process. The proper, specific software test process in any given situation depends on many factors.
Which test activities are involved in this test process, how these activities are implemented, and when these activities occur may be discussed in an organization’s test strategy.
1.4.1 Test Process in Context
Contextual factors that influence the test process for an organization, include, but are not limited to:
 Software development lifecycle model and project methodologies being used
 Test levels and test types being considered
 Product and project risks
 Business domain
 Operational constraints, including but not limited to:
o Budgets and resources
o Timescales
o Complexity
o Contractual and regulatory requirements
 Organizational policies and practices
 Required internal and external standards

## Page 18

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 18 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
The following sections describe general aspects of organizational test processes in terms of the following:
 Test activities and tasks
 Test work products

Traceability between the test basis and test work products
It is very useful if the test basis (for any level or type of testing that is being considered) has measurable
coverage criteria defined. The coverage criteria can act effectively as key performance indicators (KPIs)
to drive the activities that demonstrate achievement of software test objectives (see section 1.1.1).
For example, for a mobile application, the test basis may include a list of requirements and a list of
supported mobile devices. Each requirement is an element of the test basis. Each supported device is
also an element of the test basis. The coverage criteria may require at least one test case for each
element of the test basis. Once executed, the results of these tests tell stakeholders whether specified
requirements are fulfilled and whether failures were observed on supported devices. ISO standard (ISO/IEC/IEEE 29119-2) has further information about test processes.
1.4.2 Test Activities and Tasks
A test process consists of the following main groups of activities:
 Test planning
 Test monitoring and control
 Test analysis
 Test design
 Test implementation
 Test execution

Test completion
Each group of activities is composed of constituent activities, which will be described in the subsections
below. Each activity within each group of activities in turn may consist of multiple individual tasks, which
would vary from one project or release to another.
Further, although many of these activity groups may appear logically sequential, they are often
implemented iteratively. For example, Agile development involves small iterations of software design,
build, and test that happen on a continuous basis, supported by on-going planning. So test activities are
also happening on an iterative, continuous basis within this development approach. Even in sequential
development, the stepped logical sequence of activities will involve overlap, combination, concurrency, or
omission, so tailoring these main activities within the context of the system and the project is usually required.
Test planning
Test planning involves activities that define the objectives of testing and the approach for meeting test
objectives within constraints imposed by the context (e.g., specifying suitable test techniques and tasks,
and formulating a test schedule for meeting a deadline). Test plans may be revisited based on feedback from monitoring and control activities. Test planning is further explained in section 5.2.

## Page 19

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 19 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
Test monitoring and control
Test monitoring involves the on-going comparison of actual progress against the test plan using any test
monitoring metrics defined in the test plan. Test control involves taking actions necessary to meet the
objectives of the test plan (which may be updated over time). Test monitoring and control are supported
by the evaluation of exit criteria, which are referred to as the definition of done in some lifecycles (see
ISTQB-AT Foundation Level Agile Tester Extension Syllabus). For example, the evaluation of exit criteria for test execution as part of a given test level may include:
 Checking test results and logs against specified coverage criteria
 Assessing the level of component or system quality based on test results and logs

Determining if more tests are needed (e.g., if tests originally intended to achieve a certain level of product risk coverage failed to do so, requiring additional tests to be written and executed)
Test progress against the plan is communicated to stakeholders in test progress reports, including
deviations from the plan and information to support any decision to stop testing. Test monitoring and control are further explained in section 5.3.
Test analysis
During test analysis, the test basis is analyzed to identify testable features and define associated test
conditions. In other words, test analysis determines “what to test” in terms of measurable coverage
criteria. Test analysis includes the following major activities:
 Analyzing the test basis appropriate to the test level being considered, for example:
o
Requirement specifications, such as business requirements, functional requirements,
system requirements, user stories, epics, use cases, or similar work products that specify desired functional and non-functional component or system behavior
o
Design and implementation information, such as system or software architecture
diagrams or documents, design specifications, call flows, modelling diagrams (e.g., UML
or entity-relationship diagrams), interface specifications, or similar work products that specify component or system structure
o
The implementation of the component or system itself, including code, database metadata and queries, and interfaces
o
Risk analysis reports, which may consider functional, non-functional, and structural aspects of the component or system
 Evaluating the test basis and test items to identify defects of various types, such as:
o Ambiguities
o Omissions
o Inconsistencies
o Inaccuracies
o Contradictions
o Superfluous statements

## Page 20

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 20 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
 Identifying features and sets of features to be tested

Defining and prioritizing test conditions for each feature based on analysis of the test basis, and
considering functional, non-functional, and structural characteristics, other business and technical factors, and levels of risks

Capturing bi-directional traceability between each element of the test basis and the associated
test conditions (see sections 1.4.3 and 1.4.4)
The application of black-box, white-box, and experience-based test techniques can be useful in the
process of test analysis (see chapter 4) to reduce the likelihood of omitting important test conditions and
to define more precise and accurate test conditions.
In some cases, test analysis produces test conditions which are to be used as test objectives in test
charters. Test charters are typical work products in some types of experience-based testing (see section
4.4.2). When these test objectives are traceable to the test basis, coverage achieved during such
experience-based testing can be measured.
The identification of defects during test analysis is an important potential benefit, especially where no
other review process is being used and/or the test process is closely connected with the review process.
Such test analysis activities not only verify whether the requirements are consistent, properly expressed,
and complete, but also validate whether the requirements properly capture customer, user, and other
stakeholder needs. For example, techniques such as behavior driven development (BDD) and
acceptance test driven development (ATDD), which involve generating test conditions and test cases
from user stories and acceptance criteria prior to coding, also verify, validate, and detect defects in the user stories and acceptance criteria (see ISTQB Foundation Level Agile Tester Extension syllabus).
Test design
During test design, the test conditions are elaborated into high-level test cases, sets of high-level test
cases, and other testware. So, test analysis answers the question “what to test?” while test design
answers the question “how to test?” Test design includes the following major activities:
 Designing and prioritizing test cases and sets of test cases
 Identifying necessary test data to support test conditions and test cases
 Designing the test environment and identifying any required infrastructure and tools

Capturing bi-directional traceability between the test basis, test conditions, test cases, and test
procedures (see section 1.4.4)
The elaboration of test conditions into test cases and sets of test cases during test design often involves
using test techniques (see chapter 4).
As with test analysis, test design may also result in the identification of similar types of defects in the test
basis. Also as with test analysis, the identification of defects during test design is an important potential benefit.

## Page 21

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 21 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
Test implementation
During test implementation, the testware necessary for test execution is created and/or completed,
including sequencing the test cases into test procedures. So, test design answers the question “how to
test?” while test implementation answers the question “do we now have everything in place to run the
tests?” Test implementation includes the following major activities:
 Developing and prioritizing test procedures, and, potentially, creating automated test scripts
 Creating test suites from the test procedures and (if any) automated test scripts

Arranging the test suites within a test execution schedule in a way that results in efficient test execution (see section 5.2.4)

Building the test environment (including, potentially, test harnesses, service virtualization,
simulators, and other infrastructure items) and verifying that everything needed has been set up correctly
 Preparing test data and ensuring it is properly loaded in the test environment

Verifying and updating bi-directional traceability between the test basis, test conditions, test
cases, test procedures, and test suites (see section 1.4.4)
Test design and test implementation tasks are often combined.
In exploratory testing and other types of experience-based testing, test design and implementation may
occur, and may be documented, as part of test execution. Exploratory testing may be based on test
charters (produced as part of test analysis), and exploratory tests are executed immediately as they are designed and implemented (see section 4.4.2).
Test execution
During test execution, test suites are run in accordance with the test execution schedule. Test execution includes the following major activities:
 Recording the IDs and versions of the test item(s) or test object, test tool(s), and testware
 Executing tests either manually or by using test execution tools
 Comparing actual results with expected results

Analyzing anomalies to establish their likely causes (e.g., failures may occur due to defects in the code, but false positives also may occur [see section 1.2.3])
 Reporting defects based on the failures observed (see section 5.6)
 Logging the outcome of test execution (e.g., pass, fail, blocked)

Repeating test activities either as a result of action taken for an anomaly, or as part of the
planned testing (e.g., execution of a corrected test, confirmation testing, and/or regression testing)

Verifying and updating bi-directional traceability between the test basis, test conditions, test cases, test procedures, and test results.

## Page 22

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 22 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
Test completion
Test completion activities collect data from completed test activities to consolidate experience, testware,
and any other relevant information. Test completion activities occur at project milestones such as when a
software system is released, a test project is completed (or cancelled), an Agile project iteration is
finished (e.g., as part of a retrospective meeting), a test level is completed, or a maintenance release has
been completed. Test completion includes the following major activities:

Checking whether all defect reports are closed, entering change requests or product backlog items for any defects that remain unresolved at the end of test execution
 Creating a test summary report to be communicated to stakeholders

Finalizing and archiving the test environment, the test data, the test infrastructure, and other testware for later reuse

Handing over the testware to the maintenance teams, other project teams, and/or other stakeholders who could benefit from its use

Analyzing lessons learned from the completed test activities to determine changes needed for future iterations, releases, and projects
 Using the information gathered to improve test process maturity
1.4.3 Test Work Products
Test work products are created as part of the test process. Just as there is significant variation in the way
that organizations implement the test process, there is also significant variation in the types of work
products created during that process, in the ways those work products are organized and managed, and
in the names used for those work products. This syllabus adheres to the test process outlined above, and
the work products described in this syllabus and in the ISTQB Glossary. ISO standard (ISO/IEC/IEEE
29119-3) may also serve as a guideline for test work products.
Many of the test work products described in this section can be captured and managed using test management tools and defect management tools (see chapter 6).
Test planning work products
Test planning work products typically include one or more test plans. The test plan includes information
about the test basis, to which the other test work products will be related via traceability information (see
below and section 1.4.4), as well as exit criteria (or definition of done) which will be used during test monitoring and control. Test plans are described in section 5.2.
Test monitoring and control work products
Test monitoring and control work products typically include various types of test reports, including test
progress reports (produced on an ongoing and/or a regular basis) and test summary reports (produced at
various completion milestones). All test reports should provide audience-relevant details about the test
progress as of the date of the report, including summarizing the test execution results once those become
available.
Test monitoring and control work products should also address project management concerns, such as
task completion, resource allocation and usage, and effort.
Test monitoring and control, and the work products created during these activities, are further explained in section 5.3 of this syllabus.

## Page 23

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 23 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
Test analysis work products
Test analysis work products include defined and prioritized test conditions, each of which is ideally bi-
directionally traceable to the specific element(s) of the test basis it covers. For exploratory testing, test
analysis may involve the creation of test charters. Test analysis may also result in the discovery and reporting of defects in the test basis.
Test design work products
Test design results in test cases and sets of test cases to exercise the test conditions defined in test
analysis. It is often a good practice to design high-level test cases, without concrete values for input data
and expected results. Such high-level test cases are reusable across multiple test cycles with different
concrete data, while still adequately documenting the scope of the test case. Ideally, each test case is bi-
directionally traceable to the test condition(s) it covers.
Test design also results in the design and/or identification of the necessary test data, the design of the
test environment, and the identification of infrastructure and tools, though the extent to which these
results are documented varies significantly. Test conditions defined in test analysis may be further refined in test design.
Test implementation work products
Test implementation work products include:
 Test procedures and the sequencing of those test procedures
 Test suites

A test execution schedule
Ideally, once test implementation is complete, achievement of coverage criteria established in the test
plan can be demonstrated via bi-directional traceability between test procedures and specific elements of
the test basis, through the test cases and test conditions.
In some cases, test implementation involves creating work products using or used by tools, such as
service virtualization and automated test scripts.
Test implementation also may result in the creation and verification of test data and the test environment.
The completeness of the documentation of the data and/or environment verification results may vary
significantly.
The test data serve to assign concrete values to the inputs and expected results of test cases. Such
concrete values, together with explicit directions about the use of the concrete values, turn high-level test
cases into executable low-level test cases. The same high-level test case may use different test data
when executed on different releases of the test object. The concrete expected results which are
associated with concrete test data are identified by using a test oracle.
In exploratory testing, some test design and implementation work products may be created during test
execution, though the extent to which exploratory tests (and their traceability to specific elements of the
test basis) are documented may vary significantly. Test conditions defined in test analysis may be further refined in test implementation.

## Page 24

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 24 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
Test execution work products
Test execution work products include:

Documentation of the status of individual test cases or test procedures (e.g., ready to run, pass, fail, blocked, deliberately skipped, etc.)
 Defect reports (see section 5.6)

Documentation about which test item(s), test object(s), test tools, and testware were involved in
the testing
Ideally, once test execution is complete, the status of each element of the test basis can be determined
and reported via bi-directional traceability with the associated the test procedure(s). For example, we can
say which requirements have passed all planned tests, which requirements have failed tests and/or have
defects associated with them, and which requirements have planned tests still waiting to be run. This
enables verification that the coverage criteria have been met, and enables the reporting of test results in terms that are understandable to stakeholders.
Test completion work products
Test completion work products include test summary reports, action items for improvement of subsequent
projects or iterations (e.g., following a project Agile retrospective), change requests or product backlog items, and finalized testware.
1.4.4 Traceability between the Test Basis and Test Work Products
As mentioned in section 1.4.3, test work products and the names of those work products vary
significantly. Regardless of these variations, in order to implement effective test monitoring and control, it
is important to establish and maintain traceability throughout the test process between each element of
the test basis and the various test work products associated with that element, as described above. In addition to the evaluation of test coverage, good traceability supports:
 Analyzing the impact of changes
 Making testing auditable
 Meeting IT governance criteria

Improving the understandability of test progress reports and test summary reports to include the
status of elements of the test basis (e.g., requirements that passed their tests, requirements that failed their tests, and requirements that have pending tests)
 Relating the technical aspects of testing to stakeholders in terms that they can understand

Providing information to assess product quality, process capability, and project progress against
business goals
Some test management tools provide test work product models that match part or all of the test work
products outlined in this section. Some organizations build their own management systems to organize the work products and provide the information traceability they require.

## Page 25

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 25 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
1.5 The Psychology of Testing
Software development, including software testing, involves human beings. Therefore, human psychology has important effects on software testing.
1.5.1 Human Psychology and Testing
Identifying defects during a static test such as a requirements review or user story refinement session, or
identifying failures during dynamic test execution, may be perceived as criticism of the product and of its
author. An element of human psychology called confirmation bias can make it difficult to accept
information that disagrees with currently held beliefs. For example, since developers expect their code to
be correct, they have a confirmation bias that makes it difficult to accept that the code is incorrect. In
addition to confirmation bias, other cognitive biases may make it difficult for people to understand or
accept information produced by testing. Further, it is a common human trait to blame the bearer of bad
news, and information produced by testing often contains bad news.
As a result of these psychological factors, some people may perceive testing as a destructive activity,
even though it contributes greatly to project progress and product quality (see sections 1.1 and 1.2). To
try to reduce these perceptions, information about defects and failures should be communicated in a
constructive way. This way, tensions between the testers and the analysts, product owners, designers,
and developers can be reduced. This applies during both static and dynamic testing.
Testers and test managers need to have good interpersonal skills to be able to communicate effectively
about defects, failures, test results, test progress, and risks, and to build positive relationships with colleagues. Ways to communicate well include the following examples:

Start with collaboration rather than battles. Remind everyone of the common goal of better quality systems.

Emphasize the benefits of testing. For example, for the authors, defect information can help them
improve their work products and their skills. For the organization, defects found and fixed during testing will save time and money and reduce overall risk to product quality.

Communicate test results and other findings in a neutral, fact-focused way without criticizing the
person who created the defective item. Write objective and factual defect reports and review findings.

Try to understand how the other person feels and the reasons they may react negatively to the information.

Confirm that the other person has understood what has been said and vice versa.
Typical test objectives were discussed earlier (see section 1.1). Clearly defining the right set of test
objectives has important psychological implications. Most people tend to align their plans and behaviors
with the objectives set by the team, management, and other stakeholders. It is also important that testers adhere to these objectives with minimal personal bias.
1.5.2 Tester’s and Developer’s Mindsets
Developers and testers often think differently. The primary objective of development is to design and build
a product. As discussed earlier, the objectives of testing include verifying and validating the product,
finding defects prior to release, and so forth. These are different sets of objectives which require different mindsets. Bringing these mindsets together helps to achieve a higher level of product quality.

## Page 26

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 26 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
A mindset reflects an individual’s assumptions and preferred methods for decision making and problem-
solving. A tester’s mindset should include curiosity, professional pessimism, a critical eye, attention to
detail, and a motivation for good and positive communications and relationships. A tester’s mindset tends
to grow and mature as the tester gains experience.
A developer’s mindset may include some of the elements of a tester’s mindset, but successful developers
are often more interested in designing and building solutions than in contemplating what might be wrong
with those solutions. In addition, confirmation bias makes it difficult to find mistakes in their own work.
With the right mindset, developers are able to test their own code. Different software development
lifecycle models often have different ways of organizing the testers and test activities. Having some of the
test activities done by independent testers increases defect detection effectiveness, which is particularly
important for large, complex, or safety-critical systems. Independent testers bring a perspective which is
different than that of the work product authors (i.e., business analysts, product owners, designers, and programmers), since they have different cognitive biases from the authors.

## Page 27

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 27 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
2
Testing Throughout the Software
Development Lifecycle
100 minutes Keywords
acceptance testing, alpha testing, beta testing, commercial off-the-shelf (COTS), component integration
testing, component testing, confirmation testing, contractual acceptance testing, functional testing, impact
analysis, integration testing, maintenance testing, non-functional testing, operational acceptance testing,
regression testing, regulatory acceptance testing, sequential development model, system integration
testing, system testing, test basis, test case, test environment, test level, test object, test objective, test type, user acceptance testing, white-box testing
Learning Objectives for Testing Throughout the Software Development Lifecycle 2.1 Software Development Lifecycle Models
FL-2.1.1
(K2) Explain the relationships between software development activities and test activities in
the software development lifecycle FL-2.1.2
(K1) Identify reasons why software development lifecycle models must be adapted to the context of project and product characteristics
2.2 Test Levels
FL-2.2.1
(K2) Compare the different test levels from the perspective of objectives, test basis, test objects, typical defects and failures, and approaches and responsibilities
2.3 Test Types
FL-2.3.1
(K2) Compare functional, non-functional, and white-box testing FL-2.3.2
(K1) Recognize that functional, non-functional, and white-box tests occur at any test level FL-2.3.3 (K2) Compare the purposes of confirmation testing and regression testing
2.4 Maintenance Testing
FL-2.4.1
(K2) Summarize triggers for maintenance testing FL-2.4.2 (K2) Describe the role of impact analysis in maintenance testing

## Page 28

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 28 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
2.1 Software Development Lifecycle Models
A software development lifecycle model describes the types of activity performed at each stage in a
software development project, and how the activities relate to one another logically and chronologically.
There are a number of different software development lifecycle models, each of which requires different approaches to testing.
2.1.1 Software Development and Software Testing
It is an important part of a tester's role to be familiar with the common software development lifecycle
models so that appropriate test activities can take place. In any software development lifecycle model, there are several characteristics of good testing:
 For every development activity, there is a corresponding test activity
 Each test level has test objectives specific to that level

Test analysis and design for a given test level begin during the corresponding development activity

Testers participate in discussions to define and refine requirements and design, and are involved
in reviewing work products (e.g., requirements, design, user stories, etc.) as soon as drafts are
available
No matter which software development lifecycle model is chosen, test activities should start in the early
stages of the lifecycle, adhering to the testing principle of early testing. This syllabus categorizes common software development lifecycle models as follows:
 Sequential development models

Iterative and incremental development models
A sequential development model describes the software development process as a linear, sequential flow
of activities. This means that any phase in the development process should begin when the previous
phase is complete. In theory, there is no overlap of phases, but in practice, it is beneficial to have early
feedback from the following phase.
In the Waterfall model, the development activities (e.g., requirements analysis, design, coding, testing)
are completed one after another. In this model, test activities only occur after all other development
activities have been completed.
Unlike the Waterfall model, the V-model integrates the test process throughout the development process,
implementing the principle of early testing. Further, the V-model includes test levels associated with each
corresponding development phase, which further supports early testing (see section 2.2 for a discussion
of test levels). In this model, the execution of tests associated with each test level proceeds sequentially,
but in some cases overlapping occurs.
Sequential development models deliver software that contains the complete set of features, but typically
require months or years for delivery to stakeholders and users.
Incremental development involves establishing requirements, designing, building, and testing a system in
pieces, which means that the software’s features grow incrementally. The size of these feature increments
vary, with some methods having larger pieces and some smaller pieces. The feature increments can be as small as a single change to a user interface screen or new query option.

## Page 29

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 29 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
Iterative development occurs when groups of features are specified, designed, built, and tested together
in a series of cycles, often of a fixed duration. Iterations may involve changes to features developed in
earlier iterations, along with changes in project scope. Each iteration delivers working software which is a
growing subset of the overall set of features until the final software is delivered or development is
stopped. Examples include:

Rational Unified Process: Each iteration tends to be relatively long (e.g., two to three months),
and the feature increments are correspondingly large, such as two or three groups of related features

Scrum: Each iteration tends to be relatively short (e.g., hours, days, or a few weeks), and the
feature increments are correspondingly small, such as a few enhancements and/or two or three new features

Kanban: Implemented with or without fixed-length iterations, which can deliver either a single enhancement or feature upon completion, or can group features together to release at once

Spiral (or prototyping): Involves creating experimental increments, some of which may be heavily
re-worked or even abandoned in subsequent development work
Components or systems developed using these methods often involve overlapping and iterating test
levels throughout development. Ideally, each feature is tested at several test levels as it moves towards
delivery. In some cases, teams use continuous delivery or continuous deployment, both of which involve
significant automation of multiple test levels as part of their delivery pipelines. Many development efforts
using these methods also include the concept of self-organizing teams, which can change the way testing
work is organized as well as the relationship between testers and developers.
These methods form a growing system, which may be released to end-users on a feature-by-feature
basis, on an iteration-by-iteration basis, or in a more traditional major-release fashion. Regardless of
whether the software increments are released to end-users, regression testing is increasingly important
as the system grows.
In contrast to sequential models, iterative and incremental models may deliver usable software in weeks
or even days, but may only deliver the complete set of requirements product over a period of months or
even years.
For more information on software testing in the context of Agile development, see ISTQB-AT Foundation Level Agile Tester Extension Syllabus, Black 2017, Crispin 2008, and Gregory 2015.
2.1.2 Software Development Lifecycle Models in Context
Software development lifecycle models must be selected and adapted to the context of project and
product characteristics. An appropriate software development lifecycle model should be selected and
adapted based on the project goal, the type of product being developed, business priorities (e.g., time-to-
market), and identified product and project risks. For example, the development and testing of a minor
internal administrative system should differ from the development and testing of a safety-critical system
such as an automobile’s brake control system. As another example, in some cases organizational and
cultural issues may inhibit communication between team members, which can impede iterative
development.
Depending on the context of the project, it may be necessary to combine or reorganize test levels and/or
test activities. For example, for the integration of a commercial off-the-shelf (COTS) software product into a larger system, the purchaser may perform interoperability testing at the system integration test level

## Page 30

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 30 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
(e.g., integration to the infrastructure and other systems) and at the acceptance test level (functional and
non-functional, along with user acceptance testing and operational acceptance testing). See section 2.2
for a discussion of test levels and section 2.3 for a discussion of test types.
In addition, software development lifecycle models themselves may be combined. For example, a V-
model may be used for the development and testing of the backend systems and their integrations, while
an Agile development model may be used to develop and test the front-end user interface (UI) and
functionality. Prototyping may be used early in a project, with an incremental development model adopted
once the experimental phase is complete.
Internet of Things (IoT) systems, which consist of many different objects, such as devices, products, and
services, typically apply separate software development lifecycle models for each object. This presents a
particular challenge for the development of Internet of Things system versions. Additionally the software
development lifecycle of such objects places stronger emphasis on the later phases of the software
development lifecycle after they have been introduced to operational use (e.g., operate, update, and
decommission phases).
2.2 Test Levels
Test levels are groups of test activities that are organized and managed together. Each test level is an
instance of the test process, consisting of the activities described in section 1.4, performed in relation to
software at a given level of development, from individual units or components to complete systems or,
where applicable, systems of systems. Test levels are related to other activities within the software development lifecycle. The test levels used in this syllabus are:
 Component testing
 Integration testing
 System testing

Acceptance testing Test levels are characterized by the following attributes:
 Specific objectives
 Test basis, referenced to derive test cases
 Test object (i.e., what is being tested)
 Typical defects and failures

Specific approaches and responsibilities
For every test level, a suitable test environment is required. In acceptance testing, for example, a
production-like test environment is ideal, while in component testing the developers typically use their own development environment.

## Page 31

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 31 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
2.2.1
Component Testing Objectives of component testing
Component testing (also known as unit or module testing) focuses on components that are separately testable. Objectives of component testing include:
 Reducing risk

Verifying whether the functional and non-functional behaviors of the component are as designed and specified
 Building confidence in the component’s quality
 Finding defects in the component

Preventing defects from escaping to higher test levels
In some cases, especially in incremental and iterative development models (e.g., Agile) where code
changes are ongoing, automated component regression tests play a key role in building confidence that
changes have not broken existing components.
Component testing is often done in isolation from the rest of the system, depending on the software
development lifecycle model and the system, which may require mock objects, service virtualization,
harnesses, stubs, and drivers. Component testing may cover functionality (e.g., correctness of
calculations), non-functional characteristics (e.g., searching for memory leaks), and structural properties (e.g., decision testing).
Test basis
Examples of work products that can be used as a test basis for component testing include:
 Detailed design
 Code
 Data model
 Component specifications
Test objects
Typical test objects for component testing include:
 Components, units or modules
 Code and data structures
 Classes
 Database modules
Typical defects and failures
Examples of typical defects and failures for component testing include:
 Incorrect functionality (e.g., not as described in design specifications)
 Data flow problems
 Incorrect code and logic

## Page 32

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 32 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
Defects are typically fixed as soon as they are found, often with no formal defect management. However,
when developers do report defects, this provides important information for root cause analysis and process improvement.
Specific approaches and responsibilities
Component testing is usually performed by the developer who wrote the code, but it at least requires
access to the code being tested. Developers may alternate component development with finding and
fixing defects. Developers will often write and execute tests after having written the code for a component.
However, in Agile development especially, writing automated component test cases may precede writing
application code.
For example, consider test driven development (TDD). Test driven development is highly iterative and is
based on cycles of developing automated test cases, then building and integrating small pieces of code,
then executing the component tests, correcting any issues, and re-factoring the code. This process
continues until the component has been completely built and all component tests are passing. Test driven
development is an example of a test-first approach. While test driven development originated in eXtreme
Programming (XP), it has spread to other forms of Agile and also to sequential lifecycles (see ISTQB-AT Foundation Level Agile Tester Extension Syllabus).
2.2.2
Integration Testing Objectives of integration testing
Integration testing focuses on interactions between components or systems. Objectives of integration testing include:
 Reducing risk

Verifying whether the functional and non-functional behaviors of the interfaces are as designed and specified
 Building confidence in the quality of the interfaces
 Finding defects (which may be in the interfaces themselves or within the components or systems)

Preventing defects from escaping to higher test levels
As with component testing, in some cases automated integration regression tests provide confidence that
changes have not broken existing interfaces, components, or systems.
There are two different levels of integration testing described in this syllabus, which may be carried out on test objects of varying size as follows:

Component integration testing focuses on the interactions and interfaces between integrated
components. Component integration testing is performed after component testing, and is
generally automated. In iterative and incremental development, component integration tests are usually part of the continuous integration process.

System integration testing focuses on the interactions and interfaces between systems,
packages, and microservices. System integration testing can also cover interactions with, and
interfaces provided by, external organizations (e.g., web services). In this case, the developing
organization does not control the external interfaces, which can create various challenges for
testing (e.g., ensuring that test-blocking defects in the external organization’s code are resolved,
arranging for test environments, etc.). System integration testing may be done after system
testing or in parallel with ongoing system test activities (in both sequential development and iterative and incremental development).

## Page 33

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 33 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
Test basis
Examples of work products that can be used as a test basis for integration testing include:
 Software and system design
 Sequence diagrams
 Interface and communication protocol specifications
 Use cases
 Architecture at component or system level
 Workflows
 External interface definitions
Test objects
Typical test objects for integration testing include:
 Subsystems
 Databases
 Infrastructure
 Interfaces
 APIs
 Microservices
Typical defects and failures
Examples of typical defects and failures for component integration testing include:
 Incorrect data, missing data, or incorrect data encoding
 Incorrect sequencing or timing of interface calls
 Interface mismatch
 Failures in communication between components
 Unhandled or improperly handled communication failures between components

Incorrect assumptions about the meaning, units, or boundaries of the data being passed between
components Examples of typical defects and failures for system integration testing include:
 Inconsistent message structures between systems
 Incorrect data, missing data, or incorrect data encoding
 Interface mismatch
 Failures in communication between systems
 Unhandled or improperly handled communication failures between systems

## Page 34

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 34 of 96
4 June 2018 © International Software Testing Qualifications Board For public release

Incorrect assumptions about the meaning, units, or boundaries of the data being passed between systems
 Failure to comply with mandatory security regulations
Specific approaches and responsibilities
Component integration tests and system integration tests should concentrate on the integration itself. For
example, if integrating module A with module B, tests should focus on the communication between the
modules, not the functionality of the individual modules, as that should have been covered during
component testing. If integrating system X with system Y, tests should focus on the communication
between the systems, not the functionality of the individual systems, as that should have been covered
during system testing. Functional, non-functional, and structural test types are applicable.
Component integration testing is often the responsibility of developers. System integration testing is
generally the responsibility of testers. Ideally, testers performing system integration testing should
understand the system architecture, and should have influenced integration planning.
If integration tests and the integration strategy are planned before components or systems are built, those
components or systems can be built in the order required for most efficient testing. Systematic integration
strategies may be based on the system architecture (e.g., top-down and bottom-up), functional tasks,
transaction processing sequences, or some other aspect of the system or components. In order to
simplify defect isolation and detect defects early, integration should normally be incremental (i.e., a small
number of additional components or systems at a time) rather than “big bang” (i.e., integrating all
components or systems in one single step). A risk analysis of the most complex interfaces can help to
focus the integration testing.
The greater the scope of integration, the more difficult it becomes to isolate defects to a specific
component or system, which may lead to increased risk and additional time for troubleshooting. This is
one reason that continuous integration, where software is integrated on a component-by-component
basis (i.e., functional integration), has become common practice. Such continuous integration often includes automated regression testing, ideally at multiple test levels.
2.2.3
System Testing Objectives of system testing
System testing focuses on the behavior and capabilities of a whole system or product, often considering
the end-to-end tasks the system can perform and the non-functional behaviors it exhibits while performing those tasks. Objectives of system testing include:
 Reducing risk

Verifying whether the functional and non-functional behaviors of the system are as designed and specified
 Validating that the system is complete and will work as expected
 Building confidence in the quality of the system as a whole
 Finding defects
 Preventing defects from escaping to higher test levels or production

## Page 35

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 35 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
For certain systems, verifying data quality may be an objective. As with component testing and integration
testing, in some cases automated system regression tests provide confidence that changes have not
broken existing features or end-to-end capabilities. System testing often produces information that is used
by stakeholders to make release decisions. System testing may also satisfy legal or regulatory
requirements or standards. The test environment should ideally correspond to the final target or production environment.
Test basis
Examples of work products that can be used as a test basis for system testing include:
 System and software requirement specifications (functional and non-functional)
 Risk analysis reports
 Use cases
 Epics and user stories
 Models of system behavior
 State diagrams
 System and user manuals
Test objects
Typical test objects for system testing include:
 Applications
 Hardware/software systems
 Operating systems
 System under test (SUT)
 System configuration and configuration data
Typical defects and failures
Examples of typical defects and failures for system testing include:
 Incorrect calculations
 Incorrect or unexpected system functional or non-functional behavior
 Incorrect control and/or data flows within the system
 Failure to properly and completely carry out end-to-end functional tasks
 Failure of the system to work properly in the production environment(s)
 Failure of the system to work as described in system and user manuals
Specific approaches and responsibilities
System testing should focus on the overall, end-to-end behavior of the system as a whole, both functional
and non-functional. System testing should use the most appropriate techniques (see chapter 4) for the
aspect(s) of the system to be tested. For example, a decision table may be created to verify whether functional behavior is as described in business rules.

## Page 36

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 36 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
Independent testers typically carry out system testing. Defects in specifications (e.g., missing user stories,
incorrectly stated business requirements, etc.) can lead to a lack of understanding of, or disagreements
about, expected system behavior. Such situations can cause false positives and false negatives, which
waste time and reduce defect detection effectiveness, respectively. Early involvement of testers in user
story refinement or static testing activities, such as reviews, helps to reduce the incidence of such situations.
2.2.4
Acceptance Testing Objectives of acceptance testing
Acceptance testing, like system testing, typically focuses on the behavior and capabilities of a whole system or product. Objectives of acceptance testing include:
 Establishing confidence in the quality of the system as a whole
 Validating that the system is complete and will work as expected

Verifying that functional and non-functional behaviors of the system are as specified
Acceptance testing may produce information to assess the system’s readiness for deployment and use by
the customer (end-user). Defects may be found during acceptance testing, but finding defects is often not
an objective, and finding a significant number of defects during acceptance testing may in some cases be
considered a major project risk. Acceptance testing may also satisfy legal or regulatory requirements or
standards. Common forms of acceptance testing include the following:
 User acceptance testing
 Operational acceptance testing
 Contractual and regulatory acceptance testing

Alpha and beta testing. Each is described in the following four subsections.
User acceptance testing (UAT)
The acceptance testing of the system by users is typically focused on validating the fitness for use of the
system by intended users in a real or simulated operational environment. The main objective is building
confidence that the users can use the system to meet their needs, fulfill requirements, and perform business processes with minimum difficulty, cost, and risk.
Operational acceptance testing (OAT)
The acceptance testing of the system by operations or systems administration staff is usually performed in a (simulated) production environment. The tests focus on operational aspects, and may include:
 Testing of backup and restore
 Installing, uninstalling and upgrading
 Disaster recovery
 User management
 Maintenance tasks

## Page 37

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 37 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
 Data load and migration tasks
 Checks for security vulnerabilities

Performance testing
The main objective of operational acceptance testing is building confidence that the operators or system
administrators can keep the system working properly for the users in the operational environment, even under exceptional or difficult conditions.
Contractual and regulatory acceptance testing
Contractual acceptance testing is performed against a contract’s acceptance criteria for producing
custom-developed software. Acceptance criteria should be defined when the parties agree to the
contract. Contractual acceptance testing is often performed by users or by independent testers.
Regulatory acceptance testing is performed against any regulations that must be adhered to, such as
government, legal, or safety regulations. Regulatory acceptance testing is often performed by users or by
independent testers, sometimes with the results being witnessed or audited by regulatory agencies.
The main objective of contractual and regulatory acceptance testing is building confidence that contractual or regulatory compliance has been achieved.
Alpha and beta testing
Alpha and beta testing are typically used by developers of commercial off-the-shelf (COTS) software who
want to get feedback from potential or existing users, customers, and/or operators before the software
product is put on the market. Alpha testing is performed at the developing organization’s site, not by the
development team, but by potential or existing customers, and/or operators or an independent test team.
Beta testing is performed by potential or existing customers, and/or operators at their own locations. Beta
testing may come after alpha testing, or may occur without any preceding alpha testing having occurred.
One objective of alpha and beta testing is building confidence among potential or existing customers,
and/or operators that they can use the system under normal, everyday conditions, and in the operational
environment(s) to achieve their objectives with minimum difficulty, cost, and risk. Another objective may
be the detection of defects related to the conditions and environment(s) in which the system will be used, especially when those conditions and environment(s) are difficult to replicate by the development team.
Test basis
Examples of work products that can be used as a test basis for any form of acceptance testing include:
 Business processes
 User or business requirements
 Regulations, legal contracts and standards
 Use cases
 System requirements
 System or user documentation
 Installation procedures
 Risk analysis reports

## Page 38

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 38 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
In addition, as a test basis for deriving test cases for operational acceptance testing, one or more of the following work products can be used:
 Backup and restore procedures
 Disaster recovery procedures
 Non-functional requirements
 Operations documentation
 Deployment and installation instructions
 Performance targets
 Database packages
 Security standards or regulations
Typical test objects
Typical test objects for any form of acceptance testing include:
 System under test
 System configuration and configuration data
 Business processes for a fully integrated system
 Recovery systems and hot sites (for business continuity and disaster recovery testing)
 Operational and maintenance processes
 Forms
 Reports
 Existing and converted production data
Typical defects and failures
Examples of typical defects for any form of acceptance testing include:
 System workflows do not meet business or user requirements
 Business rules are not implemented correctly
 System does not satisfy contractual or regulatory requirements

Non-functional failures such as security vulnerabilities, inadequate performance efficiency under high loads, or improper operation on a supported platform

## Page 39

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 39 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
Specific approaches and responsibilities
Acceptance testing is often the responsibility of the customers, business users, product owners, or
operators of a system, and other stakeholders may be involved as well.
Acceptance testing is often thought of as the last test level in a sequential development lifecycle, but it may also occur at other times, for example:
 Acceptance testing of a COTS software product may occur when it is installed or integrated

Acceptance testing of a new functional enhancement may occur before system testing
In iterative development, project teams can employ various forms of acceptance testing during and at the
end of each iteration, such as those focused on verifying a new feature against its acceptance criteria and
those focused on validating that a new feature satisfies the users’ needs. In addition, alpha tests and beta
tests may occur, either at the end of each iteration, after the completion of each iteration, or after a series
of iterations. User acceptance tests, operational acceptance tests, regulatory acceptance tests, and
contractual acceptance tests also may occur, either at the close of each iteration, after the completion of
each iteration, or after a series of iterations.
2.3 Test Types
A test type is a group of test activities aimed at testing specific characteristics of a software system, or a part of a system, based on specific test objectives. Such objectives may include:

Evaluating functional quality characteristics, such as completeness, correctness, and appropriateness

Evaluating non-functional quality characteristics, such as reliability, performance efficiency, security, compatibility, and usability

Evaluating whether the structure or architecture of the component or system is correct, complete, and as specified

Evaluating the effects of changes, such as confirming that defects have been fixed (confirmation
testing) and looking for unintended changes in behavior resulting from software or environment changes (regression testing)
2.3.1 Functional Testing
Functional testing of a system involves tests that evaluate functions that the system should perform.
Functional requirements may be described in work products such as business requirements
specifications, epics, user stories, use cases, or functional specifications, or they may be undocumented.
The functions are “what” the system should do.
Functional tests should be performed at all test levels (e.g., tests for components may be based on a
component specification), though the focus is different at each level (see section 2.2).
Functional testing considers the behavior of the software, so black-box techniques may be used to derive
test conditions and test cases for the functionality of the component or system (see section 4.2).
The thoroughness of functional testing can be measured through functional coverage. Functional
coverage is the extent to which some type of functional element has been exercised by tests, and is
expressed as a percentage of the type(s) of element being covered. For example, using traceability
between tests and functional requirements, the percentage of these requirements which are addressed by testing can be calculated, potentially identifying coverage gaps.

## Page 40

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 40 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
Functional test design and execution may involve special skills or knowledge, such as knowledge of the
particular business problem the software solves (e.g., geological modelling software for the oil and gas
industries) or the particular role the software serves (e.g., computer gaming software that provides interactive entertainment).
2.3.2 Non-functional Testing
Non-functional testing of a system evaluates characteristics of systems and software such as usability,
performance efficiency or security. Refer to ISO standard (ISO/IEC 25010) for a classification of software
product quality characteristics. Non-functional testing is the testing of “how well” the system behaves.
Contrary to common misperceptions, non-functional testing can and often should be performed at all test
levels, and done as early as possible. The late discovery of non-functional defects can be extremely
dangerous to the success of a project.
Black-box techniques (see section 4.2) may be used to derive test conditions and test cases for non-
functional testing. For example, boundary value analysis can be used to define the stress conditions for
performance tests.
The thoroughness of non-functional testing can be measured through non-functional coverage. Non-
functional coverage is the extent to which some type of non-functional element has been exercised by
tests, and is expressed as a percentage of the type(s) of element being covered. For example, using
traceability between tests and supported devices for a mobile application, the percentage of devices
which are addressed by compatibility testing can be calculated, potentially identifying coverage gaps.
Non-functional test design and execution may involve special skills or knowledge, such as knowledge of
the inherent weaknesses of a design or technology (e.g., security vulnerabilities associated with particular
programming languages) or the particular user base (e.g., the personas of users of healthcare facility
management systems).
Refer to ISTQB-ATA Advanced Level Test Analyst Syllabus, ISTQB-ATTA Advanced Level Technical
Test Analyst Syllabus, ISTQB-SEC Advanced Level Security Tester Syllabus, and other ISTQB specialist modules for more details regarding the testing of non-functional quality characteristics.
2.3.3 White-box Testing
White-box testing derives tests based on the system’s internal structure or implementation. Internal
structure may include code, architecture, work flows, and/or data flows within the system (see section
4.3).
The thoroughness of white-box testing can be measured through structural coverage. Structural coverage
is the extent to which some type of structural element has been exercised by tests, and is expressed as a
percentage of the type of element being covered.
At the component testing level, code coverage is based on the percentage of component code that has
been tested, and may be measured in terms of different aspects of code (coverage items) such as the
percentage of executable statements tested in the component, or the percentage of decision outcomes
tested. These types of coverage are collectively called code coverage. At the component integration
testing level, white-box testing may be based on the architecture of the system, such as interfaces
between components, and structural coverage may be measured in terms of the percentage of interfaces
exercised by tests.
White-box test design and execution may involve special skills or knowledge, such as the way the code is
built (e.g., to use code coverage tools), how data is stored (e.g., to evaluate possible database queries), and how to use coverage tools and to correctly interpret their results.

## Page 41

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 41 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
2.3.4 Change-related Testing
When changes are made to a system, either to correct a defect or because of new or changing
functionality, testing should be done to confirm that the changes have corrected the defect or implemented the functionality correctly, and have not caused any unforeseen adverse consequences.
 Confirmation testing:
After a defect is fixed, the software may be tested with all test cases that
failed due to the defect, which should be re-executed on the new software version. The software
may also be tested with new tests if, for instance, the defect was missing functionality. At the very
least, the steps to reproduce the failure(s) caused by the defect must be re-executed on the new
software version. The purpose of a confirmation test is to confirm whether the original defect has been successfully fixed.
 Regression testing:
It is possible that a change made in one part of the code, whether a fix or
another type of change, may accidentally affect the behavior of other parts of the code, whether
within the same component, in other components of the same system, or even in other systems.
Changes may include changes to the environment, such as a new version of an operating system
or database management system. Such unintended side-effects are called regressions.
Regression testing involves running tests to detect such unintended side-effects.
Confirmation testing and regression testing are performed at all test levels.
Especially in iterative and incremental development lifecycles (e.g., Agile), new features, changes to
existing features, and code refactoring result in frequent changes to the code, which also requires
change-related testing. Due to the evolving nature of the system, confirmation and regression testing are
very important. This is particularly relevant for Internet of Things systems where individual objects (e.g.,
devices) are frequently updated or replaced.
Regression test suites are run many times and generally evolve slowly, so regression testing is a strong candidate for automation. Automation of these tests should start early in the project (see chapter 6).
2.3.5 Test Types and Test Levels
It is possible to perform any of the test types mentioned above at any test level. To illustrate, examples of
functional, non-functional, white-box, and change-related tests will be given across all test levels, for a banking application, starting with functional tests:

For component testing, tests are designed based on how a component should calculate compound interest.

For component integration testing, tests are designed based on how account information captured at the user interface is passed to the business logic.

For system testing, tests are designed based on how account holders can apply for a line of credit on their checking accounts.

For system integration testing, tests are designed based on how the system uses an external microservice to check an account holder’s credit score.

For acceptance testing, tests are designed based on how the banker handles approving or
declining a credit application. The following are examples of non-functional tests:

For component testing, performance tests are designed to evaluate the number of CPU cycles required to perform a complex total interest calculation.

## Page 42

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 42 of 96
4 June 2018 © International Software Testing Qualifications Board For public release

For component integration testing, security tests are designed for buffer overflow vulnerabilities due to data passed from the user interface to the business logic.

For system testing, portability tests are designed to check whether the presentation layer works on all supported browsers and mobile devices.

For system integration testing, reliability tests are designed to evaluate system robustness if the credit score microservice fails to respond.

For acceptance testing, usability tests are designed to evaluate the accessibility of the banker’s
credit processing interface for people with disabilities. The following are examples of white-box tests:

For component testing, tests are designed to achieve complete statement and decision coverage (see section 4.3) for all components that perform financial calculations.

For component integration testing, tests are designed to exercise how each screen in the browser interface passes data to the next screen and to the business logic.

For system testing, tests are designed to cover sequences of web pages that can occur during a credit line application.

For system integration testing, tests are designed to exercise all possible inquiry types sent to the credit score microservice.

For acceptance testing, tests are designed to cover all supported financial data file structures and
value ranges for bank-to-bank transfers. Finally, the following are examples for change-related tests:

For component testing, automated regression tests are built for each component and included within the continuous integration framework.

For component integration testing, tests are designed to confirm fixes to interface-related defects as the fixes are checked into the code repository.

For system testing, all tests for a given workflow are re-executed if any screen on that workflow changes.

For system integration testing, tests of the application interacting with the credit scoring microservice are re-executed daily as part of continuous deployment of that microservice.

For acceptance testing, all previously-failed tests are re-executed after a defect found in
acceptance testing is fixed.
While this section provides examples of every test type across every level, it is not necessary, for all
software, to have every test type represented across every level. However, it is important to run
applicable test types at each level, especially the earliest level where the test type occurs.
2.4 Maintenance Testing
Once deployed to production environments, software and systems need to be maintained. Changes of
various sorts are almost inevitable in delivered software and systems, either to fix defects discovered in
operational use, to add new functionality, or to delete or alter already-delivered functionality. Maintenance is also needed to preserve or improve non-functional quality characteristics of the component or system

## Page 43

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 43 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
over its lifetime, especially performance efficiency, compatibility, reliability, security, compatibility, and
portability.
When any changes are made as part of maintenance, maintenance testing should be performed, both to
evaluate the success with which the changes were made and to check for possible side-effects (e.g.,
regressions) in parts of the system that remain unchanged (which is usually most of the system).
Maintenance testing focuses on testing the changes to the system, as well as testing unchanged parts
that might have been affected by the changes. Maintenance can involve planned releases and unplanned
releases (hot fixes).
A maintenance release may require maintenance testing at multiple test levels, using various test types, based on its scope. The scope of maintenance testing depends on:

The degree of risk of the change, for example, the degree to which the changed area of software communicates with other components or systems
 The size of the existing system
 The size of the change
2.4.1 Triggers for Maintenance
There are several reasons why software maintenance, and thus maintenance testing, takes place, both
for planned and unplanned changes. We can classify the triggers for maintenance as follows:

Modification, such as planned enhancements (e.g., release-based), corrective and emergency
changes, changes of the operational environment (such as planned operating system or database upgrades), upgrades of COTS software, and patches for defects and vulnerabilities

Migration, such as from one platform to another, which can require operational tests of the new
environment as well as of the changed software, or tests of data conversion when data from another application will be migrated into the system being maintained

Retirement, such as when an application reaches the end of its life
When an application or system is retired, this can require testing of data migration or archiving if long
data-retention periods are required. Testing restore/retrieve procedures after archiving for long retention
periods may also be needed. In addition regression testing may be needed to ensure that any
functionality that remains in service still works.
For Internet of Things systems, maintenance testing may be triggered by the introduction of completely
new or modified things, such as hardware devices and software services, into the overall system. The
maintenance testing for such systems places particular emphasis on integration testing at different levels
(e.g., network level, application level) and on security aspects, in particular those relating to personal data.
2.4.2 Impact Analysis for Maintenance
Impact analysis evaluates the changes that were made for a maintenance release to identify the intended
consequences as well as expected and possible side effects of a change, and to identify the areas in the
system that will be affected by the change. Impact analysis can also help to identify the impact of a
change on existing tests. The side effects and affected areas in the system need to be tested for regressions, possibly after updating any existing tests affected by the change.

## Page 44

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 44 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
Impact analysis may be done before a change is made, to help decide if the change should be made,
based on the potential consequences in other areas of the system. Impact analysis can be difficult if:
 Specifications (e.g., business requirements, user stories, architecture) are out of date or missing
 Test cases are not documented or are out of date
 Bi-directional traceability between tests and the test basis has not been maintained
 Tool support is weak or non-existent
 The people involved do not have domain and/or system knowledge
 Insufficient attention has been paid to the software's maintainability during development

## Page 45

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 45 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
3 Static Testing
135 minutes Keywords
ad hoc reviewing, checklist-based reviewing,
dynamic testing, formal review, informal review, inspection,
perspective-based reading, review, role-based reviewing, scenario-based reviewing, static analysis, static testing, technical review, walkthrough
Learning Objectives for Static Testing 3.1 Static Testing Basics
FL-3.1.1
(K1) Recognize types of software work product that can be examined by the different static
testing techniques FL-3.1.2
(K2) Use examples to describe the value of static testing FL-3.1.3
(K2) Explain the difference between static and dynamic techniques, considering objectives, types of defects to be identified, and the role of these techniques within the software lifecycle
3.2 Review Process
FL-3.2.1
(K2) Summarize the activities of the work product review process FL-3.2.2
(K1) Recognize the different roles and responsibilities in a formal review FL-3.2.3
(K2) Explain the differences between different review types: informal review, walkthrough,
technical review, and inspection FL-3.2.4
(K3) Apply a review technique to a work product to find defects FL-3.2.5 (K2) Explain the factors that contribute to a successful review

## Page 46

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 46 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
3.1 Static Testing Basics
In contrast to dynamic testing, which requires the execution of the software being tested, static testing
relies on the manual examination of work products (i.e., reviews) or tool-driven evaluation of the code or
other work products (i.e., static analysis). Both types of static testing assess the code or other work
product being tested without actually executing the code or work product being tested.
Static analysis is important for safety-critical computer systems (e.g., aviation, medical, or nuclear
software), but static analysis has also become important and common in other settings. For example,
static analysis is an important part of security testing. Static analysis is also often incorporated into
automated build and delivery systems, for example in Agile development, continuous delivery, and continuous deployment.
3.1.1 Work Products that Can Be Examined by Static Testing
Almost any work product can be examined using static testing (reviews and/or static analysis), for example:

Specifications, including business requirements, functional requirements, and security requirements
 Epics, user stories, and acceptance criteria
 Architecture and design specifications
 Code
 Testware, including test plans, test cases, test procedures, and automated test scripts
 User guides
 Web pages
 Contracts, project plans, schedules, and budgets

Models, such as activity diagrams, which may be used for Model-Based testing (see ISTQB-MBT
Foundation Level Model-Based Tester Extension Syllabus and Kramer 2016)
Reviews can be applied to any work product that the participants know how to read and understand.
Static analysis can be applied efficiently to any work product with a formal structure (typically code or
models) for which an appropriate static analysis tool exists. Static analysis can even be applied with tools
that evaluate work products written in natural language such as requirements (e.g., checking for spelling, grammar, and readability).
3.1.2 Benefits of Static Testing
Static testing techniques provide a variety of benefits. When applied early in the software development
lifecycle, static testing enables the early detection of defects before dynamic testing is performed (e.g., in
requirements or design specifications reviews, product backlog refinement, etc.). Defects found early are
often much cheaper to remove than defects found later in the lifecycle, especially compared to defects
found after the software is deployed and in active use. Using static testing techniques to find defects and
then fixing those defects promptly is almost always much cheaper for the organization than using
dynamic testing to find defects in the test object and then fixing them, especially when considering the
additional costs associated with updating other work products and performing confirmation and regression testing.

## Page 47

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 47 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
Additional benefits of static testing may include:
 Detecting and correcting defects more efficiently, and prior to dynamic test execution
 Identifying defects which are not easily found by dynamic testing

Preventing defects in design or coding by uncovering inconsistencies, ambiguities, contradictions, omissions, inaccuracies, and redundancies in requirements
 Increasing development productivity (e.g., due to improved design, more maintainable code)
 Reducing development cost and time
 Reducing testing cost and time

Reducing total cost of quality over the software’s lifetime, due to fewer failures later in the lifecycle or after delivery into operation
 Improving communication between team members in the course of participating in reviews
3.1.3 Differences between Static and Dynamic Testing
Static testing and dynamic testing can have the same objectives (see section 1.1.1), such as providing an
assessment of the quality of the work products and identifying defects as early as possible. Static and
dynamic testing complement each other by finding different types of defects.
One main distinction is that static testing finds defects in work products directly rather than identifying
failures caused by defects when the software is run. A defect can reside in a work product for a very long
time without causing a failure. The path where the defect lies may be rarely exercised or hard to reach, so
it will not be easy to construct and execute a dynamic test that encounters it. Static testing may be able to
find the defect with much less effort.
Another distinction is that static testing can be used to improve the consistency and internal quality of
work products, while dynamic testing typically focuses on externally visible behaviors.
Compared with dynamic testing, typical defects that are easier and cheaper to find and fix through static testing include:

Requirement defects (e.g., inconsistencies, ambiguities, contradictions, omissions, inaccuracies, and redundancies)
 Design defects (e.g., inefficient algorithms or database structures, high coupling, low cohesion)

Coding defects (e.g., variables with undefined values, variables that are declared but never used, unreachable code, duplicate code)
 Deviations from standards (e.g., lack of adherence to coding standards)

Incorrect interface specifications (e.g., different units of measurement used by the calling system than by the called system)
 Security vulnerabilities (e.g., susceptibility to buffer overflows)

Gaps or inaccuracies in test basis traceability or coverage (e.g., missing tests for an acceptance
criterion)
Moreover, most types of maintainability defects can only be found by static testing (e.g., improper
modularization, poor reusability of components, code that is difficult to analyze and modify without introducing new defects).

## Page 48

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 48 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
3.2 Review Process
Reviews vary from informal to formal. Informal reviews are characterized by not following a defined
process and not having formal documented output. Formal reviews are characterized by team
participation, documented results of the review, and documented procedures for conducting the review.
The formality of a review process is related to factors such as the software development lifecycle model,
the maturity of the development process, the complexity of the work product to be reviewed, any legal or
regulatory requirements, and/or the need for an audit trail.
The focus of a review depends on the agreed objectives of the review (e.g., finding defects, gaining
understanding, educating participants such as testers and new team members, or discussing and
deciding by consensus).
ISO standard (ISO/IEC 20246) contains more in-depth descriptions of the review process for work products, including roles and review techniques.
3.2.1 Work Product Review Process
The review process comprises the following main activities:
Planning

Defining the scope, which includes the purpose of the review, what documents or parts of documents to review, and the quality characteristics to be evaluated
 Estimating effort and timeframe
 Identifying review characteristics such as the review type with roles, activities, and checklists
 Selecting the people to participate in the review and allocating roles
 Defining the entry and exit criteria for more formal review types (e.g., inspections)
 Checking that entry criteria are met (for more formal review types)
Initiate review

Distributing the work product (physically or by electronic means) and other material, such as issue log forms, checklists, and related work products
 Explaining the scope, objectives, process, roles, and work products to the participants
 Answering any questions that participants may have about the review
Individual review (i.e., individual preparation)
 Reviewing all or part of the work product
 Noting potential defects, recommendations, and questions
Issue communication and analysis
 Communicating identified potential defects (e.g., in a review meeting)
 Analyzing potential defects, assigning ownership and status to them
 Evaluating and documenting quality characteristics

Evaluating the review findings against the exit criteria to make a review decision (reject; major changes needed; accept, possibly with minor changes)

## Page 49

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 49 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
Fixing and reporting
 Creating defect reports for those findings that require changes
 Fixing defects found (typically done by the author) in the work product reviewed

Communicating defects to the appropriate person or team (when found in a work product related to the work product reviewed)

Recording updated status of defects (in formal reviews), potentially including the agreement of the comment originator
 Gathering metrics (for more formal review types)
 Checking that exit criteria are met (for more formal review types)

Accepting the work product when the exit criteria are reached
The results of a work product review vary, depending on the review type and formality, as described in section 3.2.3.
3.2.2 Roles and responsibilities in a formal review
A typical formal review will include the roles below:
Author
 Creates the work product under review
 Fixes defects in the work product under review (if necessary)
Management
 Is responsible for review planning
 Decides on the execution of reviews
 Assigns staff, budget, and time
 Monitors ongoing cost-effectiveness
 Executes control decisions in the event of inadequate outcomes
Facilitator (often called moderator)
 Ensures effective running of review meetings (when held)
 Mediates, if necessary, between the various points of view
 Is often the person upon whom the success of the review depends
Review leader
 Takes overall responsibility for the review
 Decides who will be involved and organizes when and where it will take place

## Page 50

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 50 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
Reviewers

May be subject matter experts, persons working on the project, stakeholders with an interest in the work product, and/or individuals with specific technical or business backgrounds
 Identify potential defects in the work product under review

May represent different perspectives (e.g., tester, programmer, user, operator, business analyst, usability expert, etc.)
Scribe (or recorder)
 Collates potential defects found during the individual review activity

Records new potential defects, open points, and decisions from the review meeting (when held)
In some review types, one person may play more than one role, and the actions associated with each role
may also vary based on review type. In addition, with the advent of tools to support the review process,
especially the logging of defects, open points, and decisions, there is often no need for a scribe. Further, more detailed roles are possible, as described in ISO standard (ISO/IEC 20246).
3.2.3 Review Types
Although reviews can be used for various purposes, one of the main objectives is to uncover defects. All
review types can aid in defect detection, and the selected review type should be based on the needs of
the project, available resources, product type and risks, business domain, and company culture, among
other selection criteria.
Reviews can be classified according to various attributes. The following lists the four most common types of reviews and their associated attributes.
Informal review (e.g., buddy check, pairing, pair review)
 Main purpose: detecting potential defects
 Possible additional purposes: generating new ideas or solutions, quickly solving minor problems
 Not based on a formal (documented) process
 May not involve a review meeting
 May be performed by a colleague of the author (buddy check) or by more people
 Results may be documented
 Varies in usefulness depending on the reviewers
 Use of checklists is optional
 Very commonly used in Agile development

## Page 51

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 51 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
Walkthrough

Main purposes: find defects, improve the software product, consider alternative implementations, evaluate conformance to standards and specifications

Possible additional purposes: exchanging ideas about techniques or style variations, training of participants, achieving consensus
 Individual preparation before the review meeting is optional
 Review meeting is typically led by the author of the work product
 Scribe is mandatory
 Use of checklists is optional
 May take the form of scenarios, dry runs, or simulations
 Potential defect logs and review reports may be produced
 May vary in practice from quite informal to very formal
Technical review
 Main purposes: gaining consensus, detecting potential defects

Possible further purposes: evaluating quality and building confidence in the work product,
generating new ideas, motivating and enabling authors to improve future work products, considering alternative implementations

Reviewers should be technical peers of the author, and technical experts in the same or other disciplines
 Individual preparation before the review meeting is required
 Review meeting is optional, ideally led by a trained facilitator (typically not the author)
 Scribe is mandatory, ideally not the author
 Use of checklists is optional
 Potential defect logs and review reports are typically produced
Inspection

Main purposes: detecting potential defects, evaluating quality and building confidence in the work product, preventing future similar defects through author learning and root cause analysis

Possible further purposes: motivating and enabling authors to improve future work products and the software development process, achieving consensus
 Follows a defined process with formal documented outputs, based on rules and checklists

Uses clearly defined roles, such as those specified in section 3.2.2 which are mandatory, and may include a dedicated reader (who reads the work product aloud during the review meeting)
 Individual preparation before the review meeting is required

Reviewers are either peers of the author or experts in other disciplines that are relevant to the work product

## Page 52

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 52 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
 Specified entry and exit criteria are used
 Scribe is mandatory
 Review meeting is led by a trained facilitator (not the author)
 Author cannot act as the review leader, reader, or scribe
 Potential defect logs and review report are produced

Metrics are collected and used to improve the entire software development process, including the
inspection process
A single work product may be the subject of more than one type of review. If more than one type of
review is used, the order may vary. For example, an informal review may be carried out before a technical
review, to ensure the work product is ready for a technical review.
The types of reviews described above can be done as peer reviews, i.e., done by colleagues at a similar
approximate organizational level.
The types of defects found in a review vary, depending especially on the work product being reviewed.
See section 3.1.3 for examples of defects that can be found by reviews in different work products, and see Gilb 1993 for information on formal inspections.
3.2.4 Applying Review Techniques
There are a number of review techniques that can be applied during the individual review (i.e., individual
preparation) activity to uncover defects. These techniques can be used across the review types described
above. The effectiveness of the techniques may differ depending on the type of review used. Examples of different individual review techniques for various review types are listed below.
Ad hoc
In an ad hoc review, reviewers are provided with little or no guidance on how this task should be
performed. Reviewers often read the work product sequentially, identifying and documenting issues as
they encounter them. Ad hoc reviewing is a commonly used technique needing little preparation. This
technique is highly dependent on reviewer skills and may lead to many duplicate issues being reported by different reviewers.
Checklist-based
A checklist-based review is a systematic technique, whereby the reviewers detect issues based on
checklists that are distributed at review initiation (e.g., by the facilitator). A review checklist consists of a
set of questions based on potential defects, which may be derived from experience. Checklists should be
specific to the type of work product under review and should be maintained regularly to cover issue types
missed in previous reviews. The main advantage of the checklist-based technique is a systematic
coverage of typical defect types. Care should be taken not to simply follow the checklist in individual reviewing, but also to look for defects outside the checklist.
Scenarios and dry runs
In a scenario-based review, reviewers are provided with structured guidelines on how to read through the
work product. A scenario-based approach supports reviewers in performing “dry runs” on the work
product based on expected usage of the work product (if the work product is documented in a suitable
format such as use cases). These scenarios provide reviewers with better guidelines on how to identify specific defect types than simple checklist entries. As with checklist-based reviews, in order not to miss

## Page 53

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 53 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
other defect types (e.g., missing features), reviewers should not be constrained to the documented scenarios.
Role-based
A role-based review is a technique in which the reviewers evaluate the work product from the perspective
of individual stakeholder roles. Typical roles include specific end user types (experienced, inexperienced,
senior, child, etc.), and specific roles in the organization (user administrator, system administrator, performance tester, etc.).
Perspective-based
In perspective-based reading, similar to a role-based review, reviewers take on different stakeholder
viewpoints in individual reviewing. Typical stakeholder viewpoints include end user, marketing, designer,
tester, or operations. Using different stakeholder viewpoints leads to more depth in individual reviewing
with less duplication of issues across reviewers.
In addition, perspective-based reading also requires the reviewers to attempt to use the work product
under review to generate the product they would derive from it. For example, a tester would attempt to
generate draft acceptance tests if performing a perspective-based reading on a requirements
specification to see if all the necessary information was included. Further, in perspective-based reading,
checklists are expected to be used.
Empirical studies have shown perspective-based reading to be the most effective general technique for
reviewing requirements and technical work products. A key success factor is including and weighing
different stakeholder viewpoints appropriately, based on risks. See Shul 2000 for details on perspective- based reading, and Sauer 2000 for the effectiveness of different review types.
3.2.5 Success Factors for Reviews
In order to have a successful review, the appropriate type of review and the techniques used must be
considered. In addition, there are a number of other factors that will affect the outcome of the review. Organizational success factors for reviews include:

Each review has clear objectives, defined during review planning, and used as measurable exit criteria

Review types are applied which are suitable to achieve the objectives and are appropriate to the type and level of software work products and participants

Any review techniques used, such as checklist-based or role-based reviewing, are suitable for effective defect identification in the work product to be reviewed
 Any checklists used address the main risks and are up to date

Large documents are written and reviewed in small chunks, so that quality control is exercised by providing authors early and frequent feedback on defects
 Participants have adequate time to prepare
 Reviews are scheduled with adequate notice

Management supports the review process (e.g., by incorporating adequate time for review activities in project schedules)

## Page 54

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 54 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
People-related success factors for reviews include:

The right people are involved to meet the review objectives, for example, people with different skill sets or perspectives, who may use the document as a work input

Testers are seen as valued reviewers who contribute to the review and learn about the work product, which enables them to prepare more effective tests, and to prepare those tests earlier
 Participants dedicate adequate time and attention to detail

Reviews are conducted on small chunks, so that reviewers do not lose concentration during individual review and/or the review meeting (when held)
 Defects found are acknowledged, appreciated, and handled objectively
 The meeting is well-managed, so that participants consider it a valuable use of their time

The review is conducted in an atmosphere of trust; the outcome will not be used for the evaluation of the participants

Participants avoid body language and behaviors that might indicate boredom, exasperation, or hostility to other participants
 Adequate training is provided, especially for more formal review types such as inspections

A culture of learning and process improvement is promoted See Gilb 1993, Wiegers 2002, and van Veenendaal 2004 for more on successful reviews.

## Page 55

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 55 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
4 Test Techniques
330 minutes Keywords
black-box test technique, boundary value analysis, checklist-based testing, coverage, decision coverage,
decision table testing, error guessing, equivalence partitioning, experience-based test technique,
exploratory testing, state transition testing, statement coverage, test technique, use case testing, white- box test technique
Learning Objectives for Test Techniques 4.1 Categories of Test Techniques
FL-4.1.1
(K2) Explain the characteristics, commonalities, and differences between black-box test techniques, white-box test techniques, and experience-based test techniques
4.2 Black-box Test Techniques
FL-4.2.1
(K3) Apply equivalence partitioning to derive test cases from given requirements FL-4.2.2
(K3) Apply boundary value analysis to derive test cases from given requirements FL-4.2.3
(K3) Apply decision table testing to derive test cases from given requirements FL-4.2.4
(K3) Apply state transition testing to derive test cases from given requirements FL-4.2.5 (K2) Explain how to derive test cases from a use case
4.3 White-box Test Techniques
FL-4.3.1
(K2) Explain statement coverage FL-4.3.2
(K2) Explain decision coverage FL-4.3.3 (K2) Explain the value of statement and decision coverage
4.4 Experience-based Test Techniques
FL-4.4.1
(K2) Explain error guessing FL-4.4.2
(K2) Explain exploratory testing FL-4.4.3 (K2) Explain checklist-based testing

## Page 56

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 56 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
4.1 Categories of Test Techniques
The purpose of a test technique, including those discussed in this section, is to help in identifying test conditions, test cases, and test data.
4.1.1 Choosing Test Techniques
The choice of which test techniques to use depends on a number of factors, including the following:
 Type of component or system
 Component or system complexity
 Regulatory standards
 Customer or contractual requirements
 Risk levels
 Risk types
 Test objectives
 Available documentation
 Tester knowledge and skills
 Available tools
 Time and budget
 Software development lifecycle model
 Expected use of the software
 Previous experience with using the test techniques on the component or system to be tested

The types of defects expected in the component or system
Some techniques are more applicable to certain situations and test levels; others are applicable to all test
levels. When creating test cases, testers generally use a combination of test techniques to achieve the
best results from the test effort.
The use of test techniques in the test analysis, test design, and test implementation activities can range
from very informal (little to no documentation) to very formal. The appropriate level of formality depends
on the context of testing, including the maturity of test and development processes, time constraints,
safety or regulatory requirements, the knowledge and skills of the people involved, and the software development lifecycle model being followed.

## Page 57

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 57 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
4.1.2 Categories of Test Techniques and Their Characteristics
In this syllabus, test techniques are classified as black-box, white-box, or experience-based.
Black-box test techniques (also called behavioral or behavior-based techniques) are based on an
analysis of the appropriate test basis (e.g., formal requirements documents, specifications, use cases,
user stories, or business processes). These techniques are applicable to both functional and non-
functional testing. Black-box test techniques concentrate on the inputs and outputs of the test object
without reference to its internal structure.
White-box test techniques (also called structural or structure-based techniques) are based on an analysis
of the architecture, detailed design, internal structure, or the code of the test object. Unlike black-box test
techniques, white-box test techniques concentrate on the structure and processing within the test object.
Experience-based test techniques leverage the experience of developers, testers and users to design,
implement, and execute tests. These techniques are often combined with black-box and white-box test
techniques. Common characteristics of black-box test techniques include the following:

Test conditions, test cases, and test data are derived from a test basis that may include software requirements, specifications, use cases, and user stories

Test cases may be used to detect gaps between the requirements and the implementation of the requirements, as well as deviations from the requirements

Coverage is measured based on the items tested in the test basis and the technique applied to
the test basis Common characteristics of white-box test techniques include the following:

Test conditions, test cases, and test data are derived from a test basis that may include code,
software architecture, detailed design, or any other source of information regarding the structure of the software

Coverage is measured based on the items tested within a selected structure (e.g., the code or interfaces)

Specifications are often used as an additional source of information to determine the expected
outcome of test cases Common characteristics of experience-based test techniques include the following:

Test conditions, test cases, and test data are derived from a test basis that may include
knowledge and experience of testers, developers, users and other stakeholders
This knowledge and experience includes expected use of the software, its environment, likely defects,
and the distribution of those defects
The international standard (ISO/IEC/IEEE 29119-4) contains descriptions of test techniques and their corresponding coverage measures (see Craig 2002 and Copeland 2004 for more on techniques).

## Page 58

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 58 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
4.2 Black-box Test Techniques
4.2.1 Equivalence Partitioning
Equivalence partitioning divides data into partitions (also known as equivalence classes) in such a way
that all the members of a given partition are expected to be processed in the same way (see Kaner 2013 and Jorgensen 2014). There are equivalence partitions for both valid and invalid values.

Valid values are values that should be accepted by the component or system. An equivalence partition containing valid values is called a “valid equivalence partition.”

Invalid values are values that should be rejected by the component or system. An equivalence partition containing invalid values is called an “invalid equivalence partition.”

Partitions can be identified for any data element related to the test object, including inputs,
outputs, internal values, time-related values (e.g., before or after an event) and for interface parameters (e.g., integrated components being tested during integration testing).
 Any partition may be divided into subpartitions if required.
 Each value must belong to one and only one equivalence partition.

When invalid equivalence partitions are used in test cases, they should be tested individually, i.e.,
not combined with other invalid equivalence partitions, to ensure that failures are not masked.
Failures can be masked when several failures occur at the same time but only one is visible,
causing the other failures to be undetected.
To achieve 100% coverage with this technique, test cases must cover all identified partitions (including
invalid partitions) by using a minimum of one value from each partition. Coverage is measured as the
number of equivalence partitions tested by at least one value, divided by the total number of identified
equivalence partitions, normally expressed as a percentage. Equivalence partitioning is applicable at all test levels.
4.2.2 Boundary Value Analysis
Boundary value analysis (BVA) is an extension of equivalence partitioning, but can only be used when the
partition is ordered, consisting of numeric or sequential data. The minimum and maximum values (or first
and last values) of a partition are its boundary values (Beizer 1990).
For example, suppose an input field accepts a single integer value as an input, using a keypad to limit
inputs so that non-integer inputs are impossible. The valid range is from 1 to 5, inclusive. So, there are
three equivalence partitions: invalid (too low); valid; invalid (too high). For the valid equivalence partition,
the boundary values are 1 and 5. For the invalid (too high) partition, the boundary values are 6 and 9. For
the invalid (too low) partition, there is only one boundary value, 0, because this is a partition with only one
member.
In the example above, we identify two boundary values per boundary. The boundary between invalid (too
low) and valid gives the test values 0 and 1. The boundary between valid and invalid (too high) gives the
test values 5 and 6. Some variations of this technique identify three boundary values per boundary: the
values before, at, and just over the boundary. In the previous example, using three-point boundary
values, the lower boundary test values are 0, 1, and 2, and the upper boundary test values are 4, 5,
and 6 (Jorgensen 2014).
Behavior at the boundaries of equivalence partitions is more likely to be incorrect than behavior within the
partitions. It is important to remember that both specified and implemented boundaries may be displaced to positions above or below their intended positions, may be omitted altogether, or may be supplemented

## Page 59

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 59 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
with unwanted additional boundaries. Boundary value analysis and testing will reveal almost all such
defects by forcing the software to show behaviors from a partition other than the one to which the
boundary value should belong.
Boundary value analysis can be applied at all test levels. This technique is generally used to test
requirements that call for a range of numbers (including dates and times). Boundary coverage for a
partition is measured as the number of boundary values tested, divided by the total number of identified boundary test values, normally expressed as a percentage.
4.2.3 Decision Table Testing
Combinatorial test techniques are useful for testing the implementation of system requirements that
specify how different combinations of conditions result in different outcomes. One approach to such
testing is decision table testing.
Decision tables are a good way to record complex business rules that a system must implement. When
creating decision tables, the tester identifies conditions (often inputs) and the resulting actions (often
outputs) of the system. These form the rows of the table, usually with the conditions at the top and the
actions at the bottom. Each column corresponds to a decision rule that defines a unique combination of
conditions which results in the execution of the actions associated with that rule. The values of the
conditions and actions are usually shown as Boolean values (true or false) or discrete values (e.g., red,
green, blue), but can also be numbers or ranges of numbers. These different types of conditions and
actions might be found together in the same table.
The common notation in decision tables is as follows: For conditions:
 Y means the condition is true (may also be shown as T or 1)
 N means the condition is false (may also be shown as F or 0)

— means the value of the condition doesn’t matter (may also be shown as N/A) For actions:
 X means the action should occur (may also be shown as Y or T or 1)

Blank means the action should not occur (may also be shown as – or N or F or 0)
A full decision table has enough columns to cover every combination of conditions. The table can be
collapsed by deleting columns containing impossible combinations of conditions, columns containing
possible but infeasible combinations of conditions, and columns that test combinations of conditions that
do not affect the outcome. For more information on how to collapse decision tables, see ISTQB-ATA
Advanced Level Test Analyst Syllabus.
The common minimum coverage standard for decision table testing is to have at least one test case per
decision rule in the table. This typically involves covering all combinations of conditions. Coverage is
measured as the number of decision rules tested by at least one test case, divided by the total number of
decision rules, normally expressed as a percentage.
The strength of decision table testing is that it helps to identify all the important combinations of
conditions, some of which might otherwise be overlooked. It also helps in finding any gaps in the
requirements. It may be applied to all situations in which the behavior of the software depends on a combination of conditions, at any test level.

## Page 60

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 60 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
4.2.4 State Transition Testing
Components or systems may respond differently to an event depending on current conditions or previous
history (e.g., the events that have occurred since the system was initialized). The previous history can be
summarized using the concept of states. A state transition diagram shows the possible software states,
as well as how the software enters, exits, and transitions between states. A transition is initiated by an
event (e.g., user input of a value into a field). The event results in a transition. If the same event can result
in two or more different transitions from the same state, that event may be qualified by a guard condition.
The state change may result in the software taking an action (e.g., outputting a calculation or error
message).
A state transition table shows all valid transitions and potentially invalid transitions between states, as well
as the events, guard conditions, and resulting actions for valid transitions. State transition diagrams
normally show only the valid transitions and exclude the invalid transitions.
Tests can be designed to cover a typical sequence of states, to exercise all states, to exercise every
transition, to exercise specific sequences of transitions, or to test invalid transitions.
State transition testing is used for menu-based applications and is widely used within the embedded
software industry. The technique is also suitable for modeling a business scenario having specific states
or for testing screen navigation. The concept of a state is abstract – it may represent a few lines of code
or an entire business process.
Coverage is commonly measured as the number of identified states or transitions tested, divided by the
total number of identified states or transitions in the test object, normally expressed as a percentage. For
more information on coverage criteria for state transition testing, see ISTQB-ATA Advanced Level Test Analyst Syllabus.
4.2.5 Use Case Testing
Tests can be derived from use cases, which are a specific way of designing interactions with software
items, incorporating requirements for the software functions represented by the use cases. Use cases are
associated with actors (human users, external hardware, or other components or systems) and subjects (the component or system to which the use case is applied).
Each use case specifies some behavior that a subject can perform in collaboration with one or more
actors (UML 2.5.1 2017). A use case can be described by interactions and activities, as well as
preconditions, postconditions and natural language where appropriate. Interactions between the actors
and the subject may result in changes to the state of the subject. Interactions may be represented
graphically by work flows, activity diagrams, or business process models.
A use case can include possible variations of its basic behavior, including exceptional behavior and error
handling (system response and recovery from programming, application and communication errors, e.g.,
resulting in an error message). Tests are designed to exercise the defined behaviors (basic, exceptional
or alternative, and error handling). Coverage can be measured by the percentage of use case behaviors
tested divided by the total number of use case behaviors, normally expressed as a percentage.
For more information on coverage criteria for use case testing, see the ISTQB-ATA Advanced Level Test
Analyst Syllabus.
4.3 White-box Test Techniques
White-box testing is based on the internal structure of the test object. White-box test techniques can be used at all test levels, but the two code-related techniques discussed in this section are most commonly

## Page 61

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 61 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
used at the component test level. There are more advanced techniques that are used in some safety-
critical, mission-critical, or high integrity environments to achieve more thorough coverage, but those are
not discussed here. For more information on such techniques, see the ISTQB Advanced Level Technical Test Analyst syllabus.
4.3.1 Statement Testing and Coverage
Statement testing exercises the executable statements in the code. Coverage is measured as the number
of statements executed by the tests divided by the total number of executable statements in the test object, normally expressed as a percentage.
4.3.2 Decision Testing and Coverage
Decision testing exercises the decisions in the code and tests the code that is executed based on the
decision outcomes. To do this, the test cases follow the control flows that occur from a decision point
(e.g., for an IF statement, one for the true outcome and one for the false outcome; for a CASE statement,
test cases would be required for all the possible outcomes, including the default outcome).
Coverage is measured as the number of decision outcomes executed by the tests divided by the total number of decision outcomes in the test object, normally expressed as a percentage.
4.3.3 The Value of Statement and Decision Testing
When 100% statement coverage is achieved, it ensures that all executable statements in the code have
been tested at least once, but it does not ensure that all decision logic has been tested. Of the two white-
box techniques discussed in this syllabus, statement testing may provide less coverage than decision
testing.
When 100% decision coverage is achieved, it executes all decision outcomes, which includes testing the
true outcome and also the false outcome, even when there is no explicit false statement (e.g., in the case
of an IF statement without an else in the code). Statement coverage helps to find defects in code that was
not exercised by other tests. Decision coverage helps to find defects in code where other tests have not
taken both true and false outcomes.
Achieving 100% decision coverage guarantees 100% statement coverage (but not vice versa).
4.4 Experience-based Test Techniques
When applying experience-based test techniques, the test cases are derived from the tester’s skill and
intuition, and their experience with similar applications and technologies. These techniques can be helpful
in identifying tests that were not easily identified by other more systematic techniques. Depending on the
tester’s approach and experience, these techniques may achieve widely varying degrees of coverage and
effectiveness. Coverage can be difficult to assess and may not be measurable with these techniques. Commonly used experience-based techniques are discussed in the following sections.
4.4.1 Error Guessing
Error guessing is a technique used to anticipate the occurrence of mistakes, defects, and failures, based on the tester’s knowledge, including:
 How the application has worked in the past
 What types of mistakes the developers tend to make

## Page 62

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 62 of 96
4 June 2018 © International Software Testing Qualifications Board For public release

Failures that have occurred in other applications
A methodical approach to the error guessing technique is to create a list of possible mistakes, defects,
and failures, and design tests that will expose those failures and the defects that caused them. These
mistake, defect, failure lists can be built based on experience, defect and failure data, or from common knowledge about why software fails.
4.4.2 Exploratory Testing
In exploratory testing, informal (not pre-defined) tests are designed, executed, logged, and evaluated
dynamically during test execution. The test results are used to learn more about the component or
system, and to create tests for the areas that may need more testing.
Exploratory testing is sometimes conducted using session-based testing to structure the activity. In
session-based testing, exploratory testing is conducted within a defined time-box, and the tester uses a
test charter containing test objectives to guide the testing. The tester may use test session sheets to
document the steps followed and the discoveries made.
Exploratory testing is most useful when there are few or inadequate specifications or significant time
pressure on testing. Exploratory testing is also useful to complement other more formal testing
techniques.
Exploratory testing is strongly associated with reactive test strategies (see section 5.2.2). Exploratory testing can incorporate the use of other black-box, white-box, and experience-based techniques.
4.4.3 Checklist-based Testing
In checklist-based testing, testers design, implement, and execute tests to cover test conditions found in a
checklist. As part of analysis, testers create a new checklist or expand an existing checklist, but testers
may also use an existing checklist without modification. Such checklists can be built based on
experience, knowledge about what is important for the user, or an understanding of why and how
software fails.
Checklists can be created to support various test types, including functional and non-functional testing. In
the absence of detailed test cases, checklist-based testing can provide guidelines and a degree of
consistency. As these are high-level lists, some variability in the actual testing is likely to occur, resulting in potentially greater coverage but less repeatability.

## Page 63

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 63 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
5 Test Management
225 minutes Keywords
configuration management, defect management, entry criteria, exit criteria, product risk, project risk, risk,
risk level, risk-based testing, test approach, test control, test estimation, test manager, test monitoring, test plan, test planning, test progress report, test strategy, test summary report, tester
Learning Objectives for Test Management 5.1 Test Organization
FL-5.1.1
(K2) Explain the benefits and drawbacks of independent testing FL-5.1.2 (K1) Identify the tasks of a test manager and tester
5.2 Test Planning and Estimation
FL-5.2.1
(K2) Summarize the purpose and content of a test plan FL-5.2.2
(K2) Differentiate between various test strategies FL-5.2.3
(K2) Give examples of potential entry and exit criteria FL-5.2.4
(K3) Apply knowledge of prioritization, and technical and logical dependencies, to schedule
test execution for a given set of test cases FL-5.2.5
(K1) Identify factors that influence the effort related to testing FL-5.2.6
(K2) Explain the difference between two estimation techniques: the metrics-based technique and the expert-based technique
5.3 Test Monitoring and Control
FL-5.3.1
(K1) Recall metrics used for testing FL-5.3.2 (K2) Summarize the purposes, contents, and audiences for test reports
5.4 Configuration Management
FL-5.4.1 (K2) Summarize how configuration management supports testing
5.5 Risks and Testing
FL-5.5.1
(K1) Define risk level by using likelihood and impact FL-5.5.2
(K2) Distinguish between project and product risks FL-5.5.3
(K2) Describe, by using examples, how product risk analysis may influence the thoroughness and scope of testing
5.6 Defect Management
FL-5.6.1 (K3) Write a defect report, covering defects found during testing

## Page 64

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 64 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
5.1 Test Organization
5.1.1 Independent Testing
Testing tasks may be done by people in a specific testing role, or by people in another role (e.g.,
customers). A certain degree of independence often makes the tester more effective at finding defects
due to differences between the author’s and the tester’s cognitive biases (see section 1.5). Independence
is not, however, a replacement for familiarity, and developers can efficiently find many defects in their
own code. Degrees of independence in testing include the following (from low level of independence to high level):
 No independent testers; the only form of testing available is developers testing their own code

Independent developers or testers within the development teams or the project team; this could be developers testing their colleagues’ products

Independent test team or group within the organization, reporting to project management or executive management

Independent testers from the business organization or user community, or with specializations in specific test types such as usability, security, performance, regulatory/compliance, or portability

Independent testers external to the organization, either working on-site (insourcing) or off-site
(outsourcing)
For most types of projects, it is usually best to have multiple test levels, with some of these levels handled
by independent testers. Developers should participate in testing, especially at the lower levels, so as to
exercise control over the quality of their own work.
The way in which independence of testing is implemented varies depending on the software development
lifecycle model. For example, in Agile development, testers may be part of a development team. In some
organizations using Agile methods, these testers may be considered part of a larger independent test
team as well. In addition, in such organizations, product owners may perform acceptance testing to
validate user stories at the end of each iteration. Potential benefits of test independence include:

Independent testers are likely to recognize different kinds of failures compared to developers because of their different backgrounds, technical perspectives, and biases

An independent tester can verify, challenge, or disprove assumptions made by stakeholders
during specification and implementation of the system Potential drawbacks of test independence include:

Isolation from the development team, leading to a lack of collaboration, delays in providing feedback to the development team, or an adversarial relationship with the development team
 Developers may lose a sense of responsibility for quality
 Independent testers may be seen as a bottleneck or blamed for delays in release

Independent testers may lack some important information (e.g., about the test object)
Many organizations are able to successfully achieve the benefits of test independence while avoiding the drawbacks.

## Page 65

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 65 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
5.1.2 Tasks of a Test Manager and Tester
In this syllabus, two test roles are covered, test managers and testers. The activities and tasks performed
by these two roles depend on the project and product context, the skills of the people in the roles, and the
organization.
The test manager is tasked with overall responsibility for the test process and successful leadership of the
test activities. The test management role might be performed by a professional test manager, or by a
project manager, a development manager, or a quality assurance manager. In larger projects or
organizations, several test teams may report to a test manager, test coach, or test coordinator, each team
being headed by a test leader or lead tester. Typical test manager tasks may include:
 Develop or review a test policy and test strategy for the organization

Plan the test activities by considering the context, and understanding the test objectives and
risks. This may include selecting test approaches, estimating test time, effort and cost, acquiring resources, defining test levels and test cycles, and planning defect management
 Write and update the test plan(s)
 Coordinate the test plan(s) with project managers, product owners, and others
 Share testing perspectives with other project activities, such as integration planning

Initiate the analysis, design, implementation, and execution of tests, monitor test progress and results, and check the status of exit criteria (or definition of done)

Prepare and deliver test progress reports and test summary reports based on the information gathered

Adapt planning based on test results and progress (sometimes documented in test progress
reports, and/or in test summary reports for other testing already completed on the project) and take any actions necessary for test control

Support setting up the defect management system and adequate configuration management of testware

Introduce suitable metrics for measuring test progress and evaluating the quality of the testing and the product

Support the selection and implementation of tools to support the test process, including
recommending the budget for tool selection (and possibly purchase and/or support), allocating time and effort for pilot projects, and providing continuing support in the use of the tool(s)
 Decide about the implementation of test environment(s)
 Promote and advocate the testers, the test team, and the test profession within the organization

Develop the skills and careers of testers (e.g., through training plans, performance evaluations,
coaching, etc.)
The way in which the test manager role is carried out varies depending on the software development
lifecycle. For example, in Agile development, some of the tasks mentioned above are handled by the
Agile team, especially those tasks concerned with the day-to-day testing done within the team, often by a tester working within the team. Some of the tasks that span multiple teams or the entire organization, or

## Page 66

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 66 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
that have to do with personnel management, may be done by test managers outside of the development
team, who are sometimes called test coaches. See Black 2009 for more on managing the test process. Typical tester tasks may include:
 Review and contribute to test plans

Analyze, review, and assess requirements, user stories and acceptance criteria, specifications, and models for testability (i.e., the test basis)

Identify and document test conditions, and capture traceability between test cases, test conditions, and the test basis

Design, set up, and verify test environment(s), often coordinating with system administration and network management
 Design and implement test cases and test procedures
 Prepare and acquire test data
 Create the detailed test execution schedule
 Execute tests, evaluate the results, and document deviations from expected results
 Use appropriate tools to facilitate the test process
 Automate tests as needed (may be supported by a developer or a test automation expert)

Evaluate non-functional characteristics such as performance efficiency, reliability, usability, security, compatibility, and portability

Review tests developed by others
People who work on test analysis, test design, specific test types, or test automation may be specialists in
these roles. Depending on the risks related to the product and the project, and the software development
lifecycle model selected, different people may take over the role of tester at different test levels. For
example, at the component testing level and the component integration testing level, the role of a tester is
often done by developers. At the acceptance test level, the role of a tester is often done by business
analysts, subject matter experts, and users. At the system test level and the system integration test level,
the role of a tester is often done by an independent test team. At the operational acceptance test level, the role of a tester is often done by operations and/or systems administration staff.

## Page 67

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 67 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
5.2 Test Planning and Estimation
5.2.1 Purpose and Content of a Test Plan
A test plan outlines test activities for development and maintenance projects. Planning is influenced by
the test policy and test strategy of the organization, the development lifecycles and methods being used
(see section 2.1), the scope of testing, objectives, risks, constraints, criticality, testability, and the
availability of resources.
As the project and test planning progress, more information becomes available and more detail can be
included in the test plan. Test planning is a continuous activity and is performed throughout the product's
lifecycle. (Note that the product’s lifecycle may extend beyond a project's scope to include the
maintenance phase.) Feedback from test activities should be used to recognize changing risks so that
planning can be adjusted. Planning may be documented in a master test plan and in separate test plans
for test levels, such as system testing and acceptance testing, or for separate test types, such as usability
testing and performance testing. Test planning activities may include the following and some of these may be documented in a test plan:
 Determining the scope, objectives, and risks of testing
 Defining the overall approach of testing
 Integrating and coordinating the test activities into the software lifecycle activities

Making decisions about what to test, the people and other resources required to perform the various test activities, and how test activities will be carried out

Scheduling of test analysis, design, implementation, execution, and evaluation activities, either on
particular dates (e.g., in sequential development) or in the context of each iteration (e.g., in iterative development)
 Selecting metrics for test monitoring and control
 Budgeting for the test activities

Determining the level of detail and structure for test documentation (e.g., by providing templates
or example documents)
The content of test plans vary, and can extend beyond the topics identified above. Sample test plans can be found in ISO standard (ISO/IEC/IEEE 29119-3).
5.2.2 Test Strategy and Test Approach
A test strategy provides a generalized description of the test process, usually at the product or organizational level. Common types of test strategies include:
 Analytical:
This type of test strategy is based on an analysis of some factor (e.g., requirement or
risk). Risk-based testing is an example of an analytical approach, where tests are designed and prioritized based on the level of risk.
 Model-Based:
In this type of test strategy, tests are designed based on some model of some
required aspect of the product, such as a function, a business process, an internal structure, or a
non-functional characteristic (e.g., reliability). Examples of such models include business process models, state models, and reliability growth models.

## Page 68

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 68 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
 Methodical:
This type of test strategy relies on making systematic use of some predefined set of
tests or test conditions, such as a taxonomy of common or likely types of failures, a list of
important quality characteristics, or company-wide look-and-feel standards for mobile apps or web pages.
 Process-compliant
(or standard-compliant): This type of test strategy involves analyzing,
designing, and implementing tests based on external rules and standards, such as those
specified by industry-specific standards, by process documentation, by the rigorous identification and use of the test basis, or by any process or standard imposed on or by the organization.
 Directed (or consultative):
This type of test strategy is driven primarily by the advice, guidance, or
instructions of stakeholders, business domain experts, or technology experts, who may be outside the test team or outside the organization itself.
 Regression-averse:
This type of test strategy is motivated by a desire to avoid regression of
existing capabilities. This test strategy includes reuse of existing testware (especially test cases and test data), extensive automation of regression tests, and standard test suites.
 Reactive:
In this type of test strategy, testing is reactive to the component or system being
tested, and the events occurring during test execution, rather than being pre-planned (as the
preceding strategies are). Tests are designed and implemented, and may immediately be
executed in response to knowledge gained from prior test results. Exploratory testing is a
common technique employed in reactive strategies.
An appropriate test strategy is often created by combining several of these types of test strategies. For
example, risk-based testing (an analytical strategy) can be combined with exploratory testing (a reactive
strategy); they complement each other and may achieve more effective testing when used together.
While the test strategy provides a generalized description of the test process, the test approach tailors the
test strategy for a particular project or release. The test approach is the starting point for selecting the test
techniques, test levels, and test types, and for defining the entry criteria and exit criteria (or definition of
ready and definition of done, respectively). The tailoring of the strategy is based on decisions made in
relation to the complexity and goals of the project, the type of product being developed, and product risk
analysis. The selected approach depends on the context and may consider factors such as risks, safety,
available resources and skills, technology, the nature of the system (e.g., custom-built versus COTS), test objectives, and regulations.
5.2.3 Entry Criteria and Exit Criteria (Definition of Ready and Definition of Done)
In order to exercise effective control over the quality of the software, and of the testing, it is advisable to
have criteria which define when a given test activity should start and when the activity is complete. Entry
criteria (more typically called definition of ready in Agile development) define the preconditions for
undertaking a given test activity. If entry criteria are not met, it is likely that the activity will prove more
difficult, more time-consuming, more costly, and more risky. Exit criteria (more typically called definition of
done in Agile development) define what conditions must be achieved in order to declare a test level or a
set of tests completed. Entry and exit criteria should be defined for each test level and test type, and will
differ based on the test objectives. Typical entry criteria include:

Availability of testable requirements, user stories, and/or models (e.g., when following a model- based testing strategy)
 Availability of test items that have met the exit criteria for any prior test levels

## Page 69

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 69 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
 Availability of test environment
 Availability of necessary test tools

Availability of test data and other necessary resources Typical exit criteria include:
 Planned tests have been executed

A defined level of coverage (e.g., of requirements, user stories, acceptance criteria, risks, code) has been achieved
 The number of unresolved defects is within an agreed limit
 The number of estimated remaining defects is sufficiently low

The evaluated levels of reliability, performance efficiency, usability, security, and other relevant
quality characteristics are sufficient
Even without exit criteria being satisfied, it is also common for test activities to be curtailed due to the
budget being expended, the scheduled time being completed, and/or pressure to bring the product to
market. It can be acceptable to end testing under such circumstances, if the project stakeholders and business owners have reviewed and accepted the risk to go live without further testing.
5.2.4 Test Execution Schedule
Once the various test cases and test procedures are produced (with some test procedures potentially
automated) and assembled into test suites, the test suites can be arranged in a test execution schedule
that defines the order in which they are to be run. The test execution schedule should take into account
such factors as prioritization, dependencies, confirmation tests, regression tests, and the most efficient
sequence for executing the tests.
Ideally, test cases would be ordered to run based on their priority levels, usually by executing the test
cases with the highest priority first. However, this practice may not work if the test cases have
dependencies or the features being tested have dependencies. If a test case with a higher priority is
dependent on a test case with a lower priority, the lower priority test case must be executed first.
Similarly, if there are dependencies across test cases, they must be ordered appropriately regardless of
their relative priorities. Confirmation and regression tests must be prioritized as well, based on the
importance of rapid feedback on changes, but here again dependencies may apply.
In some cases, various sequences of tests are possible, with differing levels of efficiency associated with
those sequences. In such cases, trade-offs between efficiency of test execution versus adherence to prioritization must be made.
5.2.5 Factors Influencing the Test Effort
Test effort estimation involves predicting the amount of test-related work that will be needed in order to
meet the objectives of the testing for a particular project, release, or iteration. Factors influencing the test
effort may include characteristics of the product, characteristics of the development process, characteristics of the people, and the test results, as shown below.
Product characteristics
 The risks associated with the product
 The quality of the test basis

## Page 70

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 70 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
 The size of the product
 The complexity of the product domain
 The requirements for quality characteristics (e.g., security, reliability)
 The required level of detail for test documentation
 Requirements for legal and regulatory compliance
Development process characteristics
 The stability and maturity of the organization
 The development model in use
 The test approach
 The tools used
 The test process
 Time pressure
People characteristics

The skills and experience of the people involved, especially with similar projects and products (e.g., domain knowledge)
 Team cohesion and leadership
Test results
 The number and severity of defects found
 The amount of rework required
5.2.6 Test Estimation Techniques
There are a number of estimation techniques used to determine the effort required for adequate testing. Two of the most commonly used techniques are:

The metrics-based technique: estimating the test effort based on metrics of former similar projects, or based on typical values

The expert-based technique: estimating the test effort based on the experience of the owners of
the testing tasks or by experts
For example, in Agile development, burndown charts are examples of the metrics-based approach as
effort is being captured and reported, and is then used to feed into the team’s velocity to determine the
amount of work the team can do in the next iteration; whereas planning poker is an example of the
expert-based approach, as team members are estimating the effort to deliver a feature based on their experience (ISTQB-AT Foundation Level Agile Tester Extension Syllabus). 
Within sequential projects, defect removal models are examples of the metrics-based approach, where
volumes of defects and time to remove them are captured and reported, which then provides a basis for
estimating future projects of a similar nature; whereas the Wideband Delphi estimation technique is an
example of the expert-based approach in which groups of experts provides estimates based on their experience (ISTQB-ATM Advanced Level Test Manager Syllabus).

## Page 71

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 71 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
5.3 Test Monitoring and Control
The purpose of test monitoring is to gather information and provide feedback and visibility about test
activities. Information to be monitored may be collected manually or automatically and should be used to
assess test progress and to measure whether the test exit criteria, or the testing tasks associated with an
Agile project's definition of done, are satisfied, such as meeting the targets for coverage of product risks,
requirements, or acceptance criteria.
Test control describes any guiding or corrective actions taken as a result of information and metrics
gathered and (possibly) reported. Actions may cover any test activity and may affect any other software
lifecycle activity. Examples of test control actions include:
 Re-prioritizing tests when an identified risk occurs (e.g., software delivered late)

Changing the test schedule due to availability or unavailability of a test environment or other resources
 Re-evaluating whether a test item meets an entry or exit criterion due to rework
5.3.1 Metrics Used in Testing
Metrics can be collected during and at the end of test activities in order to assess:
 Progress against the planned schedule and budget
 Current quality of the test object
 Adequacy of the test approach

Effectiveness of the test activities with respect to the objectives Common test metrics include:

Percentage of planned work done in test case preparation (or percentage of planned test cases implemented)
 Percentage of planned work done in test environment preparation

Test case execution (e.g., number of test cases run/not run, test cases passed/failed, and/or test conditions passed/failed)

Defect information (e.g., defect density, defects found and fixed, failure rate, and confirmation test results)
 Test coverage of requirements, user stories, acceptance criteria, risks, or code
 Task completion, resource allocation and usage, and effort

Cost of testing, including the cost compared to the benefit of finding the next defect or the cost compared to the benefit of running the next test

## Page 72

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 72 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
5.3.2 Purposes, Contents, and Audiences for Test Reports
The purpose of test reporting is to summarize and communicate test activity information, both during and
at the end of a test activity (e.g., a test level). The test report prepared during a test activity may be
referred to as a test progress report, while a test report prepared at the end of a test activity may be
referred to as a test summary report.
During test monitoring and control, the test manager regularly issues test progress reports for
stakeholders. In addition to content common to test progress reports and test summary reports, typical test progress reports may also include: 
 The status of the test activities and progress against the test plan
 Factors impeding progress
 Testing planned for the next reporting period

The quality of the test object
When exit criteria are reached, the test manager issues the test summary report. This report provides a
summary of the testing performed, based on the latest test progress report and any other relevant
information. Typical test progress reports and test summary reports may include:
 Summary of testing performed
 Information on what occurred during a test period
 Deviations from plan, including deviations in schedule, duration, or effort of test activities
 Status of testing and product quality with respect to the exit criteria or definition of done
 Factors that have blocked or continue to block progress

Metrics of defects, test cases, test coverage, activity progress, and resource consumption. (e.g., as described in 5.3.1)
 Residual risks (see section 5.5)

Reusable test work products produced
The contents of a test report will vary depending on the project, the organizational requirements, and the
software development lifecycle. For example, a complex project with many stakeholders or a regulated
project may require more detailed and rigorous reporting than a quick software update. As another
example, in Agile development, test progress reporting may be incorporated into task boards, defect
summaries, and burndown charts, which may be discussed during a daily stand-up meeting (see ISTQB-
AT Foundation Level Agile Tester Extension Syllabus).
In addition to tailoring test reports based on the context of the project, test reports should be tailored
based on the report’s audience. The type and amount of information that should be included for a
technical audience or a test team may be different from what would be included in an executive summary
report. In the first case, detailed information on defect types and trends may be important. In the latter
case, a high-level report (e.g., a status summary of defects by priority, budget, schedule, and test
conditions passed/failed/not tested) may be more appropriate.
ISO standard (ISO/IEC/IEEE 29119-3) refers to two types of test reports, test progress reports and test
completion reports (called test summary reports in this syllabus), and contains structures and examples for each type.

## Page 73

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 73 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
5.4 Configuration Management
The purpose of configuration management is to establish and maintain the integrity of the component or
system, the testware, and their relationships to one another through the project and product lifecycle. To properly support testing, configuration management may involve ensuring the following:

All test items are uniquely identified, version controlled, tracked for changes, and related to each other

All items of testware are uniquely identified, version controlled, tracked for changes, related to
each other and related to versions of the test item(s) so that traceability can be maintained throughout the test process

All identified documents and software items are referenced unambiguously in test documentation
During test planning, configuration management procedures and infrastructure (tools) should be identified
and implemented. 5.5 Risks and Testing
5.5.1 Definition of Risk
Risk involves the possibility of an event in the future which has negative consequences. The level of risk is determined by the likelihood of the event and the impact (the harm) from that event.
5.5.2 Product and Project Risks
Product risk involves the possibility that a work product (e.g., a specification, component, system, or test)
may fail to satisfy the legitimate needs of its users and/or stakeholders. When the product risks are
associated with specific quality characteristics of a product (e.g., functional suitability, reliability,
performance efficiency, usability, security, compatibility, maintainability, and portability), product risks are also called quality risks. Examples of product risks include:
 Software might not perform its intended functions according to the specification

Software might not perform its intended functions according to user, customer, and/or stakeholder needs
 A system architecture may not adequately support some non-functional requirement(s)
 A particular computation may be performed incorrectly in some circumstances
 A loop control structure may be coded incorrectly
 Response-times may be inadequate for a high-performance transaction processing system
 User experience (UX) feedback might not meet product expectations

## Page 74

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 74 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
Project risk involves situations that, should they occur, may have a negative effect on a project's ability to achieve its objectives. Examples of project risks include:
 Project issues:
o
Delays may occur in delivery, task completion, or satisfaction of exit criteria or definition of done
o
Inaccurate estimates, reallocation of funds to higher priority projects, or general cost- cutting across the organization may result in inadequate funding
o Late changes may result in substantial re-work
 Organizational issues:
o Skills, training, and staff may not be sufficient
o Personnel issues may cause conflict and problems
o
Users, business staff, or subject matter experts may not be available due to conflicting business priorities
 Political issues:
o Testers may not communicate their needs and/or the test results adequately
o
Developers and/or testers may fail to follow up on information found in testing and reviews (e.g., not improving development and testing practices)
o
There may be an improper attitude toward, or expectations of, testing (e.g., not appreciating the value of finding defects during testing)
 Technical issues:
o Requirements may not be defined well enough
o The requirements may not be met, given existing constraints
o The test environment may not be ready on time
o Data conversion, migration planning, and their tool support may be late
o
Weaknesses in the development process may impact the consistency or quality of project work products such as design, code, configuration, test data, and test cases
o
Poor defect management and similar problems may result in accumulated defects and other technical debt
 Supplier issues:
o A third party may fail to deliver a necessary product or service, or go bankrupt
o
Contractual issues may cause problems to the project
Project risks may affect both development activities and test activities. In some cases, project managers
are responsible for handling all project risks, but it is not unusual for test managers to have responsibility for test-related project risks.

## Page 75

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 75 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
5.5.3 Risk-based Testing and Product Quality
Risk is used to focus the effort required during testing. It is used to decide where and when to start testing
and to identify areas that need more attention. Testing is used to reduce the probability of an adverse
event occurring, or to reduce the impact of an adverse event. Testing is used as a risk mitigation activity,
to provide feedback about identified risks, as well as providing feedback on residual (unresolved) risks.
A risk-based approach to testing provides proactive opportunities to reduce the levels of product risk. It
involves product risk analysis, which includes the identification of product risks and the assessment of
each risk’s likelihood and impact. The resulting product risk information is used to guide test planning, the
specification, preparation and execution of test cases, and test monitoring and control. Analyzing product
risks early contributes to the success of a project. In a risk-based approach, the results of product risk analysis are used to:
 Determine the test techniques to be employed

Determine the particular levels and types of testing to be performed (e.g., security testing, accessibility testing)
 Determine the extent of testing to be carried out
 Prioritize testing in an attempt to find the critical defects as early as possible

Determine whether any activities in addition to testing could be employed to reduce risk (e.g.,
providing training to inexperienced designers)
Risk-based testing draws on the collective knowledge and insight of the project stakeholders to carry out
product risk analysis. To ensure that the likelihood of a product failure is minimized, risk management activities provide a disciplined approach to:
 Analyze (and re-evaluate on a regular basis) what can go wrong (risks)
 Determine which risks are important to deal with
 Implement actions to mitigate those risks

Make contingency plans to deal with the risks should they become actual events
In addition, testing may identify new risks, help to determine what risks should be mitigated, and lower uncertainty about risks.

## Page 76

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 76 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
5.6 Defect Management
Since one of the objectives of testing is to find defects, defects found during testing should be logged.
The way in which defects are logged may vary, depending on the context of the component or system
being tested, the test level, and the software development lifecycle model. Any defects identified should
be investigated and should be tracked from discovery and classification to their resolution (e.g., correction
of the defects and successful confirmation testing of the solution, deferral to a subsequent release,
acceptance as a permanent product limitation, etc.). In order to manage all defects to resolution, an
organization should establish a defect management process which includes a workflow and rules for
classification. This process must be agreed with all those participating in defect management, including
designers, developers, testers, and product owners. In some organizations, defect logging and tracking
may be very informal.
During the defect management process, some of the reports may turn out to describe false positives, not
actual failures due to defects. For example, a test may fail when a network connection is broken or times
out. This behavior does not result from a defect in the test object, but is an anomaly that needs to be
investigated. Testers should attempt to minimize the number of false positives reported as defects.
Defects may be reported during coding, static analysis, reviews, dynamic testing, or use of a software
product. Defects may be reported for issues in code or working systems, or in any type of documentation
including requirements, user stories and acceptance criteria, development documents, test documents,
user manuals, or installation guides. In order to have an effective and efficient defect management
process, organizations may define standards for the attributes, classification, and workflow of defects. Typical defect reports have the following objectives:

Provide developers and other parties with information about any adverse event that occurred, to
enable them to identify specific effects, to isolate the problem with a minimal reproducing test, and to correct the potential defect(s), as needed or to otherwise resolve the problem

Provide test managers a means of tracking the quality of the work product and the impact on the
testing (e.g., if a lot of defects are reported, the testers will have spent a lot of time reporting them instead of running tests, and there will be more confirmation testing needed)

Provide ideas for development and test process improvement A defect report filed during dynamic testing typically includes:
 An identifier
 A title and a short summary of the defect being reported
 Date of the defect report, issuing organization, and author
 Identification of the test item (configuration item being tested) and environment
 The development lifecycle phase(s) in which the defect was observed

A description of the defect to enable reproduction and resolution, including logs, database dumps screenshots, or recordings (if found during test execution)
 Expected and actual results
 Scope or degree of impact (severity) of the defect on the interests of stakeholder(s)
 Urgency/priority to fix

## Page 77

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 77 of 96
4 June 2018 © International Software Testing Qualifications Board For public release

State of the defect report (e.g., open, deferred, duplicate, waiting to be fixed, awaiting confirmation testing, re-opened, closed)
 Conclusions, recommendations and approvals
 Global issues, such as other areas that may be affected by a change resulting from the defect

Change history, such as the sequence of actions taken by project team members with respect to the defect to isolate, repair, and confirm it as fixed

References, including the test case that revealed the problem
Some of these details may be automatically included and/or managed when using defect management
tools, e.g., automatic assignment of an identifier, assignment and update of the defect report state during
the workflow, etc. Defects found during static testing, particularly reviews, will normally be documented in
a different way, e.g., in review meeting notes.
An example of the contents of a defect report can be found in ISO standard (ISO/IEC/IEEE 29119-3) (which refers to defect reports as incident reports).

## Page 78

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 78 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
6 Tool Support for Testing
40 minutes Keywords
data-driven testing, keyword-driven testing, performance testing tool, test automation, test execution tool, test management tool
Learning Objectives for Test Tools 6.1 Test tool considerations
FL-6.1.1
(K2) Classify test tools according to their purpose and the test activities they support FL-6.1.2
(K1) Identify benefits and risks of test automation FL-6.1.3 (K1) Remember special considerations for test execution and test management tools
6.2 Effective use of tools
FL-6.2.1
(K1) Identify the main principles for selecting a tool FL-6.2.2
(K1) Recall the objectives for using pilot projects to introduce tools FL-6.2.3
(K1) Identify the success factors for evaluation, implementation, deployment, and on-going support of test tools in an organization

## Page 79

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 79 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
6.1 Test Tool Considerations Test tools can be used to support one or more testing activities. Such tools include:
 Tools that are directly used in testing, such as test execution tools and test data preparation tools

Tools that help to manage requirements, test cases, test procedures, automated test scripts, test results, test data, and defects, and for reporting and monitoring test execution
 Tools that are used for investigation and evaluation
 Any tool that assists in testing (a spreadsheet is also a test tool in this meaning)
6.1.1 Test Tool Classification
Test tools can have one or more of the following purposes depending on the context:

Improve the efficiency of test activities by automating repetitive tasks or tasks that require significant resources when done manually (e.g., test execution, regression testing)

Improve the efficiency of test activities by supporting manual test activities throughout the test process (see section 1.4)

Improve the quality of test activities by allowing for more consistent testing and a higher level of defect reproducibility
 Automate activities that cannot be executed manually (e.g., large scale performance testing)

Increase reliability of testing (e.g., by automating large data comparisons or simulating behavior)
Tools can be classified based on several criteria such as purpose, pricing, licensing model (e.g.,
commercial or open source), and technology used. Tools are classified in this syllabus according to the
test activities that they support.
Some tools clearly support only or mainly one activity; others may support more than one activity, but are
classified under the activity with which they are most closely associated. Tools from a single provider,
especially those that have been designed to work together, may be provided as an integrated suite.
Some types of test tools can be intrusive, which means that they may affect the actual outcome of the
test. For example, the actual response times for an application may be different due to the extra
instructions that are executed by a performance testing tool, or the amount of code coverage achieved
may be distorted due to the use of a coverage tool. The consequence of using intrusive tools is called the
probe effect.
Some tools offer support that is typically more appropriate for developers (e.g., tools that are used during component and integration testing). Such tools are marked with “(D)” in the sections below.
Tool support for management of testing and testware
Management tools may apply to any test activities over the entire software development lifecycle. Examples of tools that support management of testing and testware include:
 Test management tools and application lifecycle management tools (ALM)
 Requirements management tools (e.g., traceability to test objects)
 Defect management tools

## Page 80

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 80 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
 Configuration management tools
 Continuous integration tools (D)
Tool support for static testing
Static testing tools are associated with the activities and benefits described in chapter 3. Examples of such tools include:
 Tools that support reviews
 Static analysis tools (D)
Tool support for test design and implementation
Test design tools aid in the creation of maintainable work products in test design and implementation, including test cases, test procedures and test data. Examples of such tools include:
 Test design tools
 Model-Based testing tools
 Test data preparation tools
 Acceptance test driven development (ATDD) and behavior driven development (BDD) tools

Test driven development (TDD) tools (D)
In some cases, tools that support test design and implementation may also support test execution and logging, or provide their outputs directly to other tools that support test execution and logging.
Tool support for test execution and logging
Many tools exist to support and enhance test execution and logging activities. Examples of these tools include:
 Test execution tools (e.g., to run regression tests)
 Coverage tools (e.g., requirements coverage, code coverage (D))
 Test harnesses (D)
 Unit test framework tools (D)
Tool support for performance measurement and dynamic analysis
Performance measurement and dynamic analysis tools are essential in supporting performance and load testing activities, as these activities cannot effectively be done manually. Examples of these tools include:
 Performance testing tools
 Monitoring tools
 Dynamic analysis tools (D)

## Page 81

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 81 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
Tool support for specialized testing needs
In addition to tools that support the general test process, there are many other tools that support more specific testing issues. Examples of these include tools that focus on:
 Data quality assessment
 Data conversion and migration
 Usability testing
 Accessibility testing
 Localization testing
 Security testing
 Portability testing (e.g., testing software across multiple supported platforms)
6.1.2 Benefits and Risks of Test Automation
Simply acquiring a tool does not guarantee success. Each new tool introduced into an organization will
require effort to achieve real and lasting benefits. There are potential benefits and opportunities with the
use of tools in testing, but there are also risks. This is particularly true of test execution tools (which is
often referred to as test automation). Potential benefits of using tools to support test execution include:

Reduction in repetitive manual work (e.g., running regression tests, environment set up/tear down tasks, re-entering the same test data, and checking against coding standards), thus saving time

Greater consistency and repeatability (e.g., test data is created in a coherent manner, tests are
executed by a tool in the same order with the same frequency, and tests are consistently derived from requirements)
 More objective assessment (e.g., static measures, coverage)

Easier access to information about testing (e.g., statistics and graphs about test progress, defect
rates and performance) Potential risks of using tools to support testing include:
 Expectations for the tool may be unrealistic (including functionality and ease of use)

The time, cost and effort for the initial introduction of a tool may be under-estimated (including training and external expertise)

The time and effort needed to achieve significant and continuing benefits from the tool may be
under-estimated (including the need for changes in the test process and continuous improvement in the way the tool is used)
 The effort required to maintain the test assets generated by the tool may be under-estimated

The tool may be relied on too much (seen as a replacement for test design or execution, or the use of automated testing where manual testing would be better)
 Version control of test assets may be neglected

## Page 82

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 82 of 96
4 June 2018 © International Software Testing Qualifications Board For public release

Relationships and interoperability issues between critical tools may be neglected, such as
requirements management tools, configuration management tools, defect management tools and tools from multiple vendors
 The tool vendor may go out of business, retire the tool, or sell the tool to a different vendor
 The vendor may provide a poor response for support, upgrades, and defect fixes
 An open source project may be suspended
 A new platform or technology may not be supported by the tool
 There may be no clear ownership of the tool (e.g., for mentoring, updates, etc.)
6.1.3 Special Considerations for Test Execution and Test Management Tools
In order to have a smooth and successful implementation, there are a number of things that ought to be considered when selecting and integrating test execution and test management tools into an organization.
Test execution tools
Test execution tools execute test objects using automated test scripts. This type of tool often requires
significant effort in order to achieve significant benefits.
Capturing tests by recording the actions of a manual tester seems attractive, but this approach does not
scale to large numbers of test scripts. A captured script is a linear representation with specific data and
actions as part of each script. This type of script may be unstable when unexpected events occur. The
latest generation of these tools, which takes advantage of “smart” image capturing technology, has
increased the usefulness of this class of tools, although the generated scripts still require ongoing
maintenance as the system’s user interface evolves over time.
A data-driven testing approach separates out the test inputs and expected results, usually into a
spreadsheet, and uses a more generic test script that can read the input data and execute the same test
script with different data. Testers who are not familiar with the scripting language can then create new test
data for these predefined scripts.
In a keyword-driven testing approach, a generic script processes keywords describing the actions to be
taken (also called action words), which then calls keyword scripts to process the associated test data.
Testers (even if they are not familiar with the scripting language) can then define tests using the keywords
and associated data, which can be tailored to the application being tested. Further details and examples
of data-driven and keyword-driven testing approaches are given in ISTQB-TAE Advanced Level Test
Automation Engineer Syllabus, Fewster 1999 and Buwalda 2001.
The above approaches require someone to have expertise in the scripting language (testers, developers
or specialists in test automation). Regardless of the scripting technique used, the expected results for
each test need to be compared to actual results from the test, either dynamically (while the test is
running) or stored for later (post-execution) comparison.
Model-Based testing (MBT) tools enable a functional specification to be captured in the form of a model,
such as an activity diagram. This task is generally performed by a system designer. The MBT tool
interprets the model in order to create test case specifications which can then be saved in a test
management tool and/or executed by a test execution tool (see ISTQB-MBT Foundation Level Model- Based Testing Syllabus).

## Page 83

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 83 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
Test management tools
Test management tools often need to interface with other tools or spreadsheets for various reasons, including:
 To produce useful information in a format that fits the needs of the organization
 To maintain consistent traceability to requirements in a requirements management tool

To link with test object version information in the configuration management tool
This is particularly important to consider when using an integrated tool (e.g., Application Lifecycle
Management), which includes a test management module (and possibly a defect management system),
as well as other modules (e.g., project schedule and budget information) that are used by different groups
within an organization. 6.2 Effective Use of Tools
6.2.1 Main Principles for Tool Selection
The main considerations in selecting a tool for an organization include:
 Assessment of the maturity of the organization, its strengths and weaknesses
 Identification of opportunities for an improved test process supported by tools

Understanding of the technologies used by the test object(s), in order to select a tool that is compatible with that technology

The build and continuous integration tools already in use within the organization, in order to ensure tool compatibility and integration
 Evaluation of the tool against clear requirements and objective criteria
 Consideration of whether or not the tool is available for a free trial period (and for how long)

Evaluation of the vendor (including training, support and commercial aspects) or support for non- commercial (e.g., open source) tools
 Identification of internal requirements for coaching and mentoring in the use of the tool

Evaluation of training needs, considering the testing (and test automation) skills of those who will be working directly with the tool(s)
 Consideration of pros and cons of various licensing models (e.g., commercial or open source)

Estimation of a cost-benefit ratio based on a concrete business case (if required)
As a final step, a proof-of-concept evaluation should be done to establish whether the tool performs
effectively with the software under test and within the current infrastructure or, if necessary, to identify changes needed to that infrastructure to use the tool effectively.

## Page 84

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 84 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
6.2.2 Pilot Projects for Introducing a Tool into an Organization
After completing the tool selection and a successful proof-of-concept, introducing the selected tool into an organization generally starts with a pilot project, which has the following objectives:
 Gaining in-depth knowledge about the tool, understanding both its strengths and weaknesses

Evaluating how the tool fits with existing processes and practices, and determining what would need to change

Deciding on standard ways of using, managing, storing, and maintaining the tool and the test
assets (e.g., deciding on naming conventions for files and tests, selecting coding standards, creating libraries and defining the modularity of test suites)
 Assessing whether the benefits will be achieved at reasonable cost

Understanding the metrics that you wish the tool to collect and report, and configuring the tool to ensure these metrics can be captured and reported
6.2.3 Success Factors for Tools
Success factors for evaluation, implementation, deployment, and on-going support of tools within an organization include:
 Rolling out the tool to the rest of the organization incrementally
 Adapting and improving processes to fit with the use of the tool
 Providing training, coaching, and mentoring for tool users
 Defining guidelines for the use of the tool (e.g., internal standards for automation)
 Implementing a way to gather usage information from the actual use of the tool
 Monitoring tool use and benefits
 Providing support to the users of a given tool

Gathering lessons learned from all users
It is also important to ensure that the tool is technically and organizationally integrated into the software
development lifecycle, which may involve separate organizations responsible for operations and/or third
party suppliers. See Graham 2012 for experiences and advice about using test execution tools.

## Page 85

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 85 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
7 References
Standards
ISO/IEC/IEEE 29119-1 (2013) Software and systems engineering - Software testing - Part 1: Concepts
and definitions
ISO/IEC/IEEE 29119-2 (2013) Software and systems engineering - Software testing - Part 2: Test
processes
ISO/IEC/IEEE 29119-3 (2013) Software and systems engineering - Software testing - Part 3: Test
documentation
ISO/IEC/IEEE 29119-4 (2015) Software and systems engineering - Software testing - Part 4: Test
techniques
ISO/IEC 25010, (2011) Systems and software engineering – Systems and software Quality Requirements
and Evaluation (SQuaRE) System and software quality models
ISO/IEC 20246: (2017) Software and systems engineering — Work product reviews UML 2.5, Unified Modeling Language Reference Manual, http://www.omg.org/spec/UML/2.5.1/, 2017
ISTQB documents
ISTQB Glossary
ISTQB Foundation Level Overview 2018
ISTQB-MBT Foundation Level Model-Based Tester Extension Syllabus
ISTQB-AT Foundation Level Agile Tester Extension Syllabus
ISTQB-ATA Advanced Level Test Analyst Syllabus
ISTQB-ATM Advanced Level Test Manager Syllabus
ISTQB-SEC Advanced Level Security Tester Syllabus
ISTQB-TAE Advanced Level Test Automation Engineer Syllabus
ISTQB-ETM Expert Level Test Management Syllabus ISTQB-EITP Expert Level Improving the Test Process Syllabus

## Page 86

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 86 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
Books and Articles
Beizer, B. (1990 ) Software Testing Techniques (2e)
, Van Nostrand Reinhold: Boston MA Black, R. (2017) Agile Testing Foundations
, BCS Learning & Development Ltd: Swindon UK Black, R. (2009) Managing the Testing Process (3e)
, John Wiley & Sons: New York NY Buwalda, H. et al. (2001) Integrated Test Design and Automation
, Addison Wesley: Reading MA Copeland, L. (2004) A Practitioner’s Guide to Software Test Design
, Artech House: Norwood MA Craig, R. and Jaskiel, S. (2002) Systematic Software Testing
, Artech House: Norwood MA Crispin, L. and Gregory, J. (2008) Agile Testing
, Pearson Education: Boston MA Fewster, M. and Graham, D. (1999) Software Test Automation
, Addison Wesley: Harlow UK Gilb, T. and Graham, D. (1993) Software Inspection
, Addison Wesley: Reading MA Graham, D. and Fewster, M. (2012) Experiences of Test Automation
, Pearson Education: Boston MA Gregory, J. and Crispin, L. (2015) More Agile Testing
, Pearson Education: Boston MA Jorgensen, P. (2014) Software Testing, A Craftsman’s Approach (4e)
, CRC Press: Boca Raton FL Kaner, C., Bach, J. and Pettichord, B. (2002) Lessons Learned in Software Testing
, John Wiley & Sons:
New York NY Kaner, C., Padmanabhan, S. and Hoffman, D. (2013) The Domain Testing Workbook
, Context-Driven
Press: New York NY Kramer, A., Legeard, B. (2016)
Model-Based Testing Essentials: Guide to the ISTQB Certified Model- Based Tester: Foundation Level
, John Wiley & Sons: New York NY Myers, G. (2011) The Art of Software Testing
, (3e), John Wiley & Sons: New York NY
Sauer, C. (2000) “The Effectiveness of Software Development Technical Reviews: A Behaviorally Motivated Program of Research,” IEEE Transactions on Software Engineering , Volume 26, Issue 1, pp 1-
Shull, F., Rus, I., Basili, V. July 2000. “How Perspective-Based Reading can Improve Requirement Inspections.” IEEE Computer, Volume 33, Issue 7, pp 73-79
van Veenendaal, E. (ed.) (2004) The Testing Practitioner
(Chapters 8 - 10), UTN Publishers: The
Netherlands Wiegers, K. (2002) Peer Reviews in Software
, Pearson Education: Boston MA Weinberg, G. (2008) Perfect Software and Other Illusions about Testing , Dorset House: New York NY

## Page 87

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 87 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
Other Resources (not directly referenced in this Syllabus)
Black, R., van Veenendaal, E. and Graham, D. (2012)
Foundations of Software Testing: ISTQB Certification (3e)
, Cengage Learning: London UK Hetzel, W. (1993) Complete Guide to Software Testing (2e)
, QED Information Sciences: Wellesley MA Spillner, A., Linz, T., and Schaefer, H. (2014) Software Testing Foundations (4e)
, Rocky Nook: San Rafael CA

## Page 88

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 88 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
8 Appendix A – Syllabus Background
History of this Document
This document is the ISTQB Certified Tester Foundation Level Syllabus, the first level international
qualification approved by the ISTQB (www.istqb.org).
This document was prepared between 2014 and 2018 by a Working Group comprised of members
appointed by the International Software Testing Qualifications Board (ISTQB). The 2018 version was
initially reviewed by representatives from all ISTQB member boards, and then by representatives drawn from the international software testing community.
Objectives of the Foundation Certificate Qualification

To gain recognition for testing as an essential and professional software engineering specialization
 To provide a standard framework for the development of testers' careers

To enable professionally qualified testers to be recognized by employers, customers and peers, and to raise the profile of testers
 To promote consistent and good testing practices within all software engineering disciplines
 To identify testing topics that are relevant and of value to industry

To enable software suppliers to hire certified testers and thereby gain commercial advantage over their competitors by advertising their tester recruitment policy

To provide an opportunity for testers and those with an interest in testing to acquire an internationally recognized qualification in the subject
Objectives of the International Qualification
 To be able to compare testing knowledge across different countries
 To enable testers to move across country borders more easily
 To enable multinational/international projects to have a common understanding of testing issues
 To increase the number of qualified testers worldwide

To have more impact/value as an internationally-based initiative than from any country-specific approach

To develop a common international body of understanding and knowledge about testing through
the syllabus and terminology, and to increase the level of knowledge about testing for all participants
 To promote testing as a profession in more countries
 To enable testers to gain a recognized qualification in their native language
 To enable sharing of knowledge and resources across countries

To provide international recognition of testers and this qualification due to participation from many countries

## Page 89

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 89 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
Entry Requirements for this Qualification
The entry criterion for taking the ISTQB Certified Tester Foundation Level exam is that candidates have an interest in software testing. However, it is strongly recommended that candidates also:

Have at least a minimal background in either software development or software testing, such as six months experience as a system or user acceptance tester or as a software developer

Take a course that has been accredited by one of the ISTQB-recognized member boards to ISTQB standards.
Background and History of the Foundation Certificate in Software Testing
The independent certification of software testers began in the UK with the British Computer Society's
Information Systems Examination Board (ISEB), when a Software Testing Board was set up in 1998
(www.bcs.org.uk/iseb). In 2002, ASQF in Germany began to support a German tester qualification
scheme (www.asqf.de). This syllabus is based on the ISEB and ASQF syllabi; it includes reorganized,
updated and additional content, and the emphasis is directed at topics that will provide the most practical
help to testers.
An existing Foundation Certificate in Software Testing (e.g., from ISEB, ASQF or an ISTQB-recognized
member board) awarded before this International Certificate was released, will be deemed to be
equivalent to the International Certificate. The Foundation Certificate does not expire and does not need
to be renewed. The date it was awarded is shown on the Certificate.
Within each participating country, local aspects are controlled by a national or regional ISTQB-recognized
Software Testing Board. Duties of member boards are specified by the ISTQB, but are implemented
within each country. The duties of the country boards are expected to include accreditation of training providers and the setting of exams.

## Page 90

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 90 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
9
Appendix B – Learning Objectives/Cognitive Level of Knowledge
The following learning objectives are defined as applying to this syllabus. Each topic in the syllabus will be examined according to the learning objective for it.
Level 1: Remember (K1)
The candidate will recognize, remember and recall a term or concept.
Keywords: Identify, remember, retrieve, recall, recognize, know
Examples:
Can recognize the definition of “failure” as:
 “Non-delivery of service to an end user or any other stakeholder” or
 “Deviation of the component or system from its expected delivery, service or result”
Level 2: Understand (K2)
The candidate can select the reasons or explanations for statements related to the topic, and can summarize, compare, classify, categorize and give examples for the testing concept.
Keywords
: Summarize, generalize, abstract, classify, compare, map, contrast, exemplify, interpret, translate, represent, infer, conclude, categorize, construct models
Examples:
Can explain the reason why test analysis and design should occur as early as possible:
 To find defects when they are cheaper to remove

To find the most important defects first Can explain the similarities and differences between integration and system testing:

Similarities: the test objects for both integration testing and system testing include more than one component, and both integration testing and system testing can include non-functional test types

Differences: integration testing concentrates on interfaces and interactions, and system testing concentrates on whole-system aspects, such as end-to-end processing
Level 3: Apply (K3)
The candidate can select the correct application of a concept or technique and apply it to a given context.
Keywords : Implement, execute, use, follow a procedure, apply a procedure
Examples:
 Can identify boundary values for valid and invalid partitions
 Can select test cases from a given state transition diagram in order to cover all transitions
Reference
(For the cognitive levels of learning objectives) Anderson, L. W. and Krathwohl, D. R. (eds) (2001)
A Taxonomy for Learning, Teaching, and Assessing: A Revision of Bloom's Taxonomy of Educational Objectives , Allyn & Bacon: Boston MA

## Page 91

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 91 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
10 Appendix C – Release Notes
ISTQB Foundation Syllabus 2018 is a major update and rewrite of release 2011. For this reason, there
are no detailed release notes per chapter and section. However, a summary of principal changes is
provided here. Additionally, in a separate Release Notes document, ISTQB provides traceability between
the learning objectives in the 2011 version of the Foundation Level Syllabus and the learning objectives in
the 2018 version of the Foundation Level Syllabus, showing which have been added, updated, or
removed.
At the start of 2017 more than 550,000 people in more than 100 countries have taken the foundation
exam, and more than 500,000 are certified testers worldwide. With the expectation that all of them have
read the Foundation Syllabus to be able to pass the exam, this makes the Foundation Syllabus likely to
be the most read software testing document ever!
This major update is made in respect of this heritage and to improve the value the ISTQB delivers to the
next 500,000 people in the global testing community.
In this version, all learning objectives have been edited to make them atomic, and to create clear
traceability from each learning objective to the content section(s) (and exam questions) that are related to
that learning objective, and to have clear traceability from the content section(s) (and exam questions)
back to the associated learning objective. In addition, the chapter time allocations have been made more
realistic than those in the 2011 version of the syllabus, by using proven heuristics and formulas used with
other ISTQB syllabi, which are based on an analysis of the learning objectives to be covered in each
chapter.
While this is a Foundation syllabus, expressing best practices and techniques that have withstood the test
of time, we have made changes to modernize the presentation of the material, especially in terms of
software development methods (e.g., Scrum and continuous deployment) and technologies (e.g., the
Internet of Things). We have updated the referenced standards to make them more recent as follows: 1.
ISO/IEC/IEEE 29119 replaces IEEE Standard 829. 2.
ISO/IEC 25010 replaces ISO 9126. 3.
ISO/IEC 20246 replaces IEEE 1028.
In addition, since the ISTQB portfolio has grown dramatically over the last decade, we have added
extensive cross-references to related material in other ISTQB syllabi, where relevant, as well as carefully
reviewing for alignment with all syllabi and with the ISTQB Glossary. The goal is to make this version
easier to read, understand, learn, and translate, focusing on increasing practical usefulness and the
balance between knowledge and skills.
For a detailed analysis of the changes made in this release, see the ISTQB Certified Tester Foundation Level Overview 2018.

## Page 92

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 92 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
11 Index
acceptance testing 14, 27, 30, 36–39, 41–42,
64, 67 action words see
keyword-driven testing
ad hoc review 45, 52
Agile development 14, 18, 29–30, 32, 46, 50,
64–65, 68, 70, 72
alpha and beta testing 27, 36–37, 39
audience, for test reports 72
automated component regression tests 31–32
automation 41, 66, 68, 78, 81–84
banking application example, test types and test
levels 41–42 beta testing see
alpha and beta testing
black-box test techniques 20, 39–40, 55,
57–60, 62
boundary value analysis (BVA) 40, 55,
58–59
decision table testing 35, 55, 59
equivalence partitioning 55, 58
state transition testing 55, 60
use case testing 55, 60
boundary value analysis 55, 58–59 buddy check see
informal review
change-related testing 41, 42
checklist-based review 52
checklist-based testing 62
code coverage 14, 40, 79–80
code coverage tools 40, 79–80
commercial off-the-shelf (COTS) software 27,
29, 37, 39, 43, 68
component integration testing 27, 63, 32–34, 40–42, 66
see also
integration testing
component testing 14, 27, 30–32, 39–42, 56, 79
configuration management 63, 73–74, 80,
82–83
confirmation bias 25–26
confirmation testing 14, 21, 27 39, 41, 46, 69,
71, 76–77
context 12–13, 17–18, 27, 29, 56, 65, 67–68,
72, 76, 74
contractual acceptance testing 27, 36–37, 39
coverage 12, 14, 18–20, 23–24, 39–42, 47, 52,
55, 57–62, 69, 71–72, 79–80
black-box testing 57–60
checklist-based 52
code 14, 40, 79–80
decision 55, 61
decision table 59
equivalence partitioning 58
experience-based 61–62
functional 39
non-functional 40
state transition 60
statement 55, 61
use case 60
white-box testing 40, 57, 61
data-driven testing 78, 82
debugging 12, 14
decision table 35, 55, 59
decision coverage 42, 55, 61
decision testing 31, 61
defect management 32, 63, 65, 74, 76–77
defect reports 22, 24–25, 49, 63, 76–77
defects 12, 15–17
acceptance testing, typical 38
clusters 16
component testing, typical 31–32
integration testing, typical 33–34
necessity of testing 14
pesticide paradox 17
psychology 25
root causes of 16
static testing benefits 46–47
system testing, typical 35
test analysis 19–20
testing principles and 16–17 development lifecycle model see
software
development lifecycle model
developer
component testing 32, 34
debugging 14
independent testing 64
mindset compared to tester's 25–26
tools for 79–80 dry runs see
scenario-based review
dynamic analysis, tool support for 80
early testing 16
entry and exit criteria 19, 22, 63, 65, 68–69,
71–72, 74
for reviews 48–49, 52–53
equivalence partitioning 55, 58 error guessing 55, 62

## Page 93

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 93 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
errors 15–16
absence is, fallacy 17
estimation
techniques 70
test 63, 67, 69 tool selection 83
see also
test planning
exhaustive testing 16 exit criteria see
entry and exit criteria
experience-based test techniques 20–21, 55,
57, 61–62
checklist-based testing 62
error guessing 61–62
exploratory testing 55, 62 expert-based
estimation technique 70
exploratory testing 21, 23, 62, 68
failures 12–16, 21, 27
acceptance testing, typical 38
change-related 41
component testing, typical 31–32
defect management, in 76
equivalence partitioning 58
error guessing 62
errors, defects and 15–16
independent testers 64
integration testing, typical 33–34
non-functional testing 38
static and dynamic testing 41
system testing, typical 35
test execution, in 20
psychology 25
false negatives 16, 36
false positives 16, 21, 36, 76
functional testing 27, 30–31, 35, 39–40, 41,
57, 62
impact analysis 27, 43–44 incident reports see
defect reports incremental development models 28–32, 41
see also
iterative development models
independent testers and testing 26, 36–37,
63–64, 66
informal review 45, 48, 50, 52
inspection 45, 48, 51–52, 54
integration strategy 34
integration testing 27, 29–30, 32–34, 40–43, 58, 66, 79
see also
component integration testing,
system integration testing
Internet of Things (IoT) systems 30, 41, 43
interpersonal skills 25
intrusive (tool) 79
ISO Standards
25010 40
20246 48, 50
29119-1 14
29119-2 18
29119-3 22, 67, 72, 77
29119-4 57
iterative development models 28–29, 31–32, 39, 41, 67
see also
incremental development models
Kanban 29
keyword-driven testing 78, 82
logging
defect management 76
tool support for 80
maintenance testing 27, 42–44 management see
configuration management,
defect management, project
management, quality management, test
management
management, tool support for 22, 24, 78–79,
82–83
metrics-based estimation technique 70
metrics used in reviews 49, 52
metrics used in testing 19, 63, 65, 67, 71–72, 84
mindset, tester and developer compared 25–26
mobile application
contextual testing factors 17–18, 68
non-functional coverage 40, 42
model-based testing (MBT)
strategy 67–68
testing 46
tools 80, 82
monitoring tools 79–80
non-functional coverage 40
non-functional testing 27, 30–31, 35, 40, 41,
57, 62
objectives
defect reports 76
reviews 45, 47–48, 50, 53–54
test levels 27–28, 30–32, 34, 36–36
test objectives 12–15, 17–20, 25, 56, 62, 65,
67–69, 71
test types 39
pilot project 84
open source tools 79, 83
operational acceptance testing (OAT) 36–37
performance testing 37, 40–41, 43, 53, 64, 67
tools 78, 80–81
perspective-based reading 45, 53 pesticide paradox 17

## Page 94

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 94 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
pilot project, introducing tool into organization 84
planning
integration 34, 65
migration 74
planning poker 70
review 48–49, 53 test see
test planning work products see test plan
see also
estimation
probe effect 79
product quality 24–25, 40, 47, 52, 65, 69,
71–72, 74–76
product risk 17, 19, 29, 63, 68, 71, 73, 75
product risk analysis 63, 68, 75
project risk 17, 29, 36, 63, 73–74
proof-of-concept (tool) 83–84
prototyping 29, 30
psychology 25
purpose
configuration management 73
confirmation and maintenance testing 27, 41
monitoring and control 71
reviews 48, 50–52
test plan 63, 67
test report 63, 72
testing 14–16, 56
tools 78–79
quality 12–15, 19, 31–32, 34, 36, 64, 68, 79
cost of 47
data quality 35, 81 product see
product quality
quality characteristics 39–40, 42, 48, 68, 70, 73
quality assurance 12, 15, 65
quality control 15, 53 quality risk see
product risk
quality management 15
Rational Unified Process 29
reactive test strategies 62, 68
regression
averse 68
defects (aka regressions) 17, 41, 43
testing 17, 21, 27, 29, 34, 39, 41, 43, 46, 79
tests 31–32, 35, 42, 68–69
tools 80–81
regulatory acceptance testing 37
regulatory requirements 13, 17, 35–38, 48,
56, 70
requirements elicitation error 15
retirement, maintenance testing and 43
review
decision 48
findings 25, 48, 74
meeting 50–52, 54, 77
objectives 48, 53
peers 51–52
planning 48
process 20, 45, 48–50
requirements, review of 14, 25, 46, 66
review types 45, 48–52, 54
roles 36, 45, 47–50, 53
reports 51–52, 76
success factors 45, 53–54
tools to support 80
work products 13, 28, 45–46, 48–49, 52–53,
65–66
risk 73–75
definition 73 product see
product risk project see
project risk
risk analysis 16, 19, 34–35, 37, 63, 68, 75
risk-based testing 63, 67–68, 75
test automation risks 81–82
role-based review 53
root cause analysis 13, 15–16, 32, 51
safety-critical systems 17, 26, 29, 37, 46, 61
safety requirements 56, 68
scenario-based review 45, 52–53
scripting language 82
Scrum 29
self-organizing teams 29
sequential development models 17–18, 27–29,
32, 39, 67, 70 shift left see
early testing
software development lifecycle 13, 17, 26, 27–31, 39, 56, 64, 66, 76, 84
see also
incremental development models,
iterative development models,
sequential development models
software testing and development 28–29
specialized testing needs, tool support for 81
Spiral 29
state transition testing 55, 60
statement testing and coverage 61
static analysis 45–46, 76, 80
static testing 13, 36, 45–47, 77, 80
structural coverage, white-box testing 40
success
factors for reviews 45, 49, 53–54
factors for tools 78, 81–82, 84 testing’s contributions to 14–15

## Page 95

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 95 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
system integration testing 27, 32–34, 41–42
defects and failures 33–34
responsibility for 34
system testing 27, 30, 32, 34–36, 39, 41–42,
67
tasks
activities and 12, 18, 21, 65, 81
system 34–35, 79
test manager 63, 65–66
tester 63–66
testing 36–37, 70–71, 81
technical review 45, 51–52
test analysis 12, 18–21, 23, 28, 56, 65–67
work products 23
test basis 12, 18–24, 27, 30, 57, 66, 68–69
acceptance testing, examples 37–38
component testing, examples 31
integration testing, examples 33
system testing, examples 35
traceability 24, 44, 47
test completion 12, 18, 22, 24, 72
work products 24 test control see
test monitoring and control
test design 12, 18, 20–21, 23, 40, 56, 65–66
tool support for 80
work products 23
test driven development (TDD) 32, 80
test effort 16, 56
estimation 69–70
test estimation techniques 63, 70
test execution 12–13, 18–19, 21–25, 47, 62–63,
65, 68–69, 76, 79–81
schedule 12, 21, 23, 66, 69
tool support for 78–82, 84
work products 24
test implementation 12, 18, 21, 23, 56, 65
tool support for 80
work products 23
test levels 13–14, 17, 19, 22, 27–32, 34, 39–41,
43, 45, 58–61, 64–68, 72, 76
acceptance testing 36–39
component testing 31–32
integration testing 32–34
system testing 34–36
test types and 41–42
test management 63, 65
tools 22, 24, 78–79, 82–83
test manager 63, 65–66, 72, 74, 76
test monitoring and control 12, 18–19, 22, 24,
63, 67, 71–72, 75
metrics used in testing 19, 63, 65, 67, 71–72
test reports 22, 63, 72
work products 22
test organization 63–66
independent testing 64, 66
tasks of test manager and tester 65–66 test plan see
test planning, work products
test planning 12–13, 18, 63, 67, 73. 75
work products 22
test process 12–13, 17–24, 28, 30, 65, 68, 70,
73. 76, 79, 81, 83
activities and tasks 18–22
context 17–18
traceability 24
work products 22–24
test reports 22, 63, 72
test strategy 17, 63, 65, 67–68
test techniques 14, 16, 55–62, 68, 75
black-box 55, 57–60
categories 55, 57
choosing 55, 56
experience-based 55, 57, 61–62
white-box 40, 55, 57, 60
test tools 20–24, 40, 44, 46, 50, 56, 65–66, 69,
73–74, 78–84
benefits and risks of test automation 81–82
effective use of 83–84
intrusive 79
pilot projects for introducing 84
tool selection 83
success factors 84
types of tool 79–81
test types 17, 27, 34, 39–43, 62, 64, 66–68
change-related testing 41–42
functional testing 39–40
non-functional testing 40
test levels and 41–42
white-box testing 40 test work products see
work products
tester, tasks of 66
testing
contextual factors 17–18
debugging, and 14
definition 13–14
errors/defects/failures 15–16
psychology of 25–26
purpose of 14–16
quality assurance and 15
seven principles 16–17 typical objectives of 13–14

## Page 96

Certified Tester
Foundation Level Syllabus
International
Software Testing
Qualifications Board Version 2018 Page 96 of 96
4 June 2018 © International Software Testing Qualifications Board For public release
tools see
test tools
traceability 12, 18, 20–23, 24, 39–40, 44, 47,
66, 73, 79, 83
triggers for maintenance 27, 43
use case 19, 33, 35, 37, 39, 52, 55, 57, 60
use case testing 55, 60
user acceptance testing (UAT) 36
user stories 13, 19–20, 28, 35–36, 39, 44, 46,
57, 64, 66, 68–69, 71, 76
V-model 28, 30
walkthrough 45, 51
Waterfall model 28
white-box test techniques 20, 40, 55, 57, 60–62
decision testing and coverage 61
statement testing and coverage 61
value of statement and decision testing 61
white-box testing 27, 40, 60
examples 41–42
Wideband Delphi estimation technique 70
work products 22–24
acceptance testing 37–38
component testing 31
integration testing 33
monitoring and control 22
review process 48–54
static testing 46–47
system testing 35
test analysis 23
test completion 24
test design 23
test execution 24
test implementation 23
test planning 22 traceability 24
