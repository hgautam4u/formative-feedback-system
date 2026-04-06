---
title: 'A Self-Hosted AI Feedback System for Formative Assessment: Implementation Guide Using n8n and Ollama'
tags:
  - Python
  - n8n
  - Ollama
  - formative assessment
  - self-hosted AI
authors:
  - name: Harish Gautam
    orcid: 0000-0003-3324-2156
    affiliation: 1
affiliations:
  - name: College of New Caledonia, Prince George, BC, Canada
    index: 1
date: 6 April 2026
bibliography: paper.bib
---
# A Self-Hosted AI Feedback System for Formative Assessment: Implementation Guide Using n8n and Ollama

**Author:** Harish Gautam  
**Affiliation:** College of New Caledonia, Prince George, BC, Canada  
**Email:** connect@harishgautam.net  
**ORCID:** 0000-0003-3324-2156

## Summary

This paper presents a complete implementation guide for building a self-hosted AI feedback system designed to support formative assessment in higher education. The system uses n8n (a visual workflow automation platform) combined with Ollama (a local large language model server) to provide students with detailed, rubric-aligned feedback on draft submissions. Students can request feedback on their drafts as many times as needed, typically receiving responses within 15-30 seconds, without any per-use costs or privacy concerns associated with cloud-based AI services. The implementation runs entirely on institutional servers using open-source components, with total costs under $1,500 for hardware that can serve multiple courses and hundreds of students. We demonstrate the system through two real-world applications: providing formative feedback for complex essay exams in a customer relationship management course, and generating technical evaluations of student-built websites in a digital marketing course. All workflow files, configurations, and installation documentation are openly shared to enable community adoption and adaptation.

**Repository:** https://github.com/hgautam4u/formative-feedback-system  
**License:** MIT

## Statement of Need

Frequent, detailed feedback significantly improves student learning outcomes [@BlackWiliam:1998; @HattieTimperley:2007], yet practical constraints often prevent instructors from providing the frequency and depth of feedback that research recommends [@Shute:2008]. Faculty teaching large classes face difficult choices about how much time to invest in feedback versus other teaching responsibilities. Cloud-based AI services like ChatGPT or Claude offer potential solutions but introduce new problems: recurring subscription costs, privacy concerns with processing student data on third-party servers [@ReidenbergSchaub:2018], and ethical questions about using AI for high-stakes grading [@Selwyn:2019].

This system addresses these challenges by focusing specifically on formative assessment rather than summative grading. Students receive AI-generated feedback on draft work to guide revision and improvement, but all final grades remain under complete instructor control. The self-hosted architecture ensures student data never leaves institutional servers, eliminating privacy concerns and compliance complications. After initial hardware investment (typically $500-1,800), the system operates at zero marginal cost, making unlimited feedback requests sustainable even for large courses.

The need for such systems extends beyond individual instructors. Institutions increasingly seek alternatives to commercial cloud services that preserve institutional autonomy, protect student privacy, and avoid vendor lock-in [@ZawackiRichter:2019]. Recent advances in open-source language models have made self-hosting more practical than many educators might expect, yet few comprehensive guides exist for deploying these systems in educational contexts [@HolmesBialikFadel:2019]. This work fills that gap by providing complete documentation suitable for faculty and educational technologists without extensive programming backgrounds.

## Software Description

The system architecture combines three main components. The n8n workflow engine provides visual, code-free workflow design, making the system accessible to educators without programming expertise. Users create workflows by connecting pre-built nodes through a drag-and-drop interface, with each node handling specific tasks like reading files, formatting text, or calling APIs. Ollama serves as the runtime environment for large language models, handling model loading, inference optimization, and resource management across different hardware configurations. Open-weights language models including Qwen2.5 [@Yang:2024], Gemma 2 [@GemmaTeam:2024], and Llama 2 [@Touvron:2023] provide the underlying AI capabilities.

The typical workflow follows a pattern that adapts to different assessment types. Students submit draft work through a web form or learning management system integration. The system extracts text content, constructs a detailed prompt incorporating the course rubric and evaluation criteria, sends the request to the language model, parses the structured response, and generates a formatted feedback document. Processing time averages 15-30 seconds depending on submission length and hardware configuration. Students can repeat this process as many times as they wish as they revise their work, with each iteration providing updated feedback reflecting their changes, aligning with the "assessment for learning" philosophy [@Wiliam:2011]..

Hardware requirements scale based on usage patterns. A repurposed laptop with 8 CPU cores and 32GB RAM can serve a single course with 30-50 students. Our implementation uses a former Dell XPS 15 laptop (Intel i7, 64GB RAM, 4GB GPU) running Ubuntu Linux, currently serving two courses with approximately 60 students total. Larger deployments might use dedicated servers with 16+ cores and 64GB RAM to support multiple courses or concurrent users. Optional GPU acceleration improves speed but is not required, as models run efficiently on CPU with appropriate optimization.

Model selection involves trade-offs between speed, quality, and resource requirements. We tested four models extensively:

- qwen2.5:7b (4.7GB): Best overall balance, excellent quality, 15-20 second responses
- qwen2.5:14b (9GB): Highest quality, slower but thorough, 25-35 second responses  
- gemma2:9b (5.5GB): Good alternative, slightly less detailed feedback, 18-25 seconds
- llama3.1:8b (4.9GB): Solid baseline, adequate for most uses, 20-25 seconds

Based on extensive testing across different assignment types, we recommend qwen2.5:7b for most educational applications. It provides detailed, rubric-aligned feedback while running efficiently on modest hardware. Institutions with more powerful servers might prefer qwen2.5:14b for slightly higher quality, while resource-constrained deployments can use smaller models with acceptable results.

## Key Features

**Privacy preservation.** All processing occurs on institutional servers. Student submissions never transmit to external services, simplifying FERPA compliance and eliminating third-party data processing concerns. Institutions maintain complete control over data retention, access, and deletion policies.

**Cost sustainability.** After initial hardware investment, operational costs consist only of electricity (approximately $10-15 monthly for a small server). Students can request unlimited feedback without per-use charges, subscription fees, or API costs. This economic model supports pedagogical best practices around frequent formative feedback without ongoing budget implications.

**Pedagogical appropriateness.** The system explicitly supports formative assessment (feedback for learning) rather than summative grading (final evaluation). Students understand they receive AI-generated feedback to guide improvement, with final grades remaining entirely under instructor control. This framing addresses ethical concerns about algorithmic bias and preserves instructor expertise in high-stakes assessment.

**Accessibility for non-programmers.** The visual workflow interface requires no coding knowledge. Educators familiar with basic computer use can create and modify workflows through form-based configuration and drag-and-drop connections. Documentation includes detailed screenshots and step-by-step instructions written for faculty without technical backgrounds.

**Flexibility across disciplines.** The same infrastructure adapts to different assessment types, disciplines, and rubric structures. Instructors customize workflows for their specific needs by modifying prompt templates and evaluation criteria rather than rewriting code. Our implementations demonstrate this versatility through two quite different use cases: essay-based exams and technical website evaluation.

**Integration capabilities.** The system exposes API endpoints enabling integration with learning management systems, custom web interfaces, or command-line tools. Basic implementations use file upload and download, while more sophisticated deployments might integrate directly with Canvas, Moodle, or institutional portals.

## Implementation

Installation requires approximately 2-4 hours for someone comfortable following technical documentation. The process involves five main steps: preparing a Linux server (Ubuntu 24.04 recommended), installing Docker and Docker Compose, deploying Ollama with selected language models, deploying n8n, and importing pre-configured workflows. Our repository includes a single-command installation script automating most setup tasks.

For users unfamiliar with Linux server administration, we provide detailed documentation with screenshots for each step. Common troubleshooting scenarios are documented based on testing across different hardware configurations. The installation guide assumes basic familiarity with command-line interfaces but explains each command's purpose and expected output.

Model configuration requires some optimization for educational use. Language models typically default to creative, varied outputs appropriate for general conversation. Educational feedback requires consistent, rubric-aligned responses. Our configuration files reduce randomness (temperature 0.1), limit vocabulary to more precise terms (top_k 10, top_p 0.3), and slightly penalize repetition. These parameters produce reliable, structured feedback suitable for student learning rather than creative or unpredictable responses.

Workflow customization follows documented patterns. The repository includes two complete workflow examples serving as templates. Educators can adapt these by modifying rubric criteria, adjusting feedback length or tone, changing output formats, or adding institution-specific integration points. The visual interface makes these modifications accessible without programming expertise.

## Use Cases

**Essay exam formative feedback.** In an upper-level customer relationship management course, students complete a complex three-part midterm exam requiring analysis of personal customer experiences, development of service recovery strategies, and proposal of resource-constrained business improvements. The exam design deliberately requires authentic personal examples to discourage AI-generated submissions. However, students often struggle to assess whether draft answers meet rubric criteria.

We created a workflow accepting student draft submissions and evaluating them against detailed criteria. Part 1 (35 points) assesses customer experience documentation, relationship opportunity identification, communication behavior analysis, and technology evaluation. Part 2 (35 points) covers service recovery scripting and video justification. Part 3 (30 points) evaluates strategic proposals under specified budget and time constraints.

The system generates personalized feedback quoting specific phrases from student submissions and identifying strengths and improvement opportunities relative to rubric criteria. For example, feedback might note "You described 'felt embarrassed when called back loudly' which effectively captures emotional impact" while suggesting "consider explicitly referencing 'service encounter quality' from Week 3 when discussing the return interaction."

Students averaged 2.1 feedback requests before final submission. Student comments suggested the system helped them "understand what the rubric really meant" and reduced anxiety about meeting requirements. Office hours shifted from rubric clarification toward deeper conceptual discussions. While we have not conducted formal learning outcome studies, instructor observation suggests final submissions showed better rubric alignment compared to previous semesters without formative feedback access.

Processing averaged 22 seconds per submission using qwen2.5:7b on CPU-only mode (our laptop lacks sufficient GPU memory for the full model). The system handled concurrent requests from multiple students without performance issues. No technical failures occurred during the semester.

**Website technical evaluation.** A digital marketing course requires students to build WordPress websites demonstrating SEO optimization, keyword research, and landing page design principles. Students struggle to self-assess technical elements like heading hierarchy, meta description quality, or keyword placement. Traditional feedback required instructor review of 35 websites, consuming 8-10 hours.

We developed a workflow analyzing websites against a technical checklist covering 15 criteria: proper H1 tag usage, meta description presence and length, image alt text, keyword density, mobile responsiveness, page load speed, and other SEO fundamentals. The workflow extracts website content, evaluates each criterion, assigns scores, and generates improvement recommendations.

The system evaluated all 35 websites in approximately 12 minutes. Students received specific, actionable feedback like "meta description current: 89 characters, should be 150-160 characters" or "keyword density too high at 4.2%, reduce to 1-2%." I spot-checked 10 automated evaluations against my own manual review and found 90% agreement on major technical issues, with discrepancies primarily in subjective quality judgments.

This workflow freed instructor time from technical checklist evaluation, enabling focus on higher-level feedback about marketing strategy and content quality. Students appreciated the immediate, specific technical guidance supporting their learning process.

## Community and Sustainability

The repository provides complete implementation artifacts: Docker Compose configurations, workflow templates, model configuration files, installation scripts, and troubleshooting documentation. Community members can adopt these directly or adapt them for different educational contexts. We welcome contributions including additional workflow templates for different disciplines, learning management system integration modules, accessibility improvements, and model fine-tuning guides.

Beyond the code repository, we maintain supplementary resources including video walkthroughs of installation and configuration, frequently asked questions addressing common technical issues, and a discussion forum for community support. The open-source nature enables continuous improvement as community members share adaptations and enhancements.

## Limitations and Future Directions

Current limitations include the technical knowledge required for initial setup, although detailed documentation reduces this barrier substantially. Hardware investment ($500-1,800) may challenge some individuals or small institutions, though costs remain modest compared to multi-year cloud subscriptions. Model quality, while excellent for rubric-based feedback, remains somewhat below GPT-4 for nuanced writing evaluation, though improvements occur regularly as the open-source community releases better models.

Planned enhancements include streamlined installation scripts for Windows and macOS, pre-built plugins for Canvas and Moodle, mobile-friendly student interfaces, and instructor analytics dashboards. We invite the research community to conduct formal studies on student perceptions, learning outcomes, and equity implications of AI formative feedback systems.

## Author Contribution

HG designed the system architecture, developed the workflows, conducted the implementations in two courses, and wrote the manuscript.

## Acknowledgments

This work builds on contributions from the n8n, Ollama, and language model research communities. We thank students who provided feedback on system usability and effectiveness.
