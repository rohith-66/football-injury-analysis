Overview

This project analyzes 15,600+ football injury records across Europe’s top leagues to understand player availability, club-level injury impact, and high-risk player profiles.

The goal was to move beyond simple injury counts and focus on severity, availability loss, and risk concentration, using SQL for data preparation and Power BI for analysis and visualization.

Business Questions Addressed

How does injury burden vary across leagues and clubs?

Which clubs lose the most player availability, not just suffer more injuries?

Is injury risk driven by frequency, severity, or both?

Which players represent the highest long-term injury risk?

How do age and position relate to injury recovery duration?

Dataset

Records: 15,602 injury events

Leagues: Premier League, La Liga, Serie A, Bundesliga, Ligue 1

Seasons: 2020/21 – 2024/25

Granularity: One row per injury event

Key fields include:

Player, club, league, position, age

Injury type

Days missed, games missed

Injury start and end dates

Tools & Skills Used

SQL (MySQL)

Data cleaning and validation

Aggregations and derived metrics

Window-style ranking and Top-N analysis

Power BI (Web)

KPI design and dashboard layout

Club-level and player-level analysis

Slicers, filters, and conditional formatting

Analytics Skills

Exploratory Data Analysis (EDA)

KPI definition (availability, severity, risk)

Business-focused storytelling

Dashboard Structure
1 Overview

Total injuries, days missed, and average recovery duration

League-level comparison of injury burden

2 Club Impact

Total days missed by club (availability impact)

Injury frequency vs severity comparison

Player-level risk concentration within clubs (interactive slicer)

3 Player Risk

Global Top 20 high-risk players (aggregated across clubs)

Age vs injury severity analysis

Position × age injury severity heatmap

The dashboard intentionally avoids filler visuals and focuses only on insights that affect decisions.

Key Insights

Injury impact is not driven by frequency alone; severity varies widely by club and player profile.

Some clubs experience fewer injuries but suffer greater availability loss per injury.

A small subset of players accounts for a disproportionate share of injury burden.

Injury severity tends to increase with age for certain positions.

Dashboard Access

Dashboard PDF:
https://drive.google.com/file/d/1QCYEcaFSZfuhqFkp60mK9rHAnSlGrQS2/view?usp=drive_link

Note: Due to Power BI workspace restrictions, the dashboard is shared as a PDF snapshot. All metrics were validated directly against SQL queries.

How This Project Is Useful

This analysis demonstrates how injury data can be translated into availability and risk insights relevant to:

Club operations and squad planning

Player recruitment and risk assessment

Performance and medical decision-making
