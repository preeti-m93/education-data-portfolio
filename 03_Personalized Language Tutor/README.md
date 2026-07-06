# Personalized Language Tutor

An AI-powered language learning assistant built with OpenAI's API. This project
combines speech recognition and language models to provide learners with transcription,
translation, grammar correction, and pronunciation feedback in one workflow.

## Features

- **Speech-to-text transcription** — Converts spoken audio into text using
  OpenAI's speech-to-text model.
- **Translation** — Translates the transcribed text into a target language
  using `gpt-4o-mini`.
- **Grammar check** — Detects grammatical errors in user-generated text and
  suggests corrections, giving learners concrete feedback on their writing.
- **Pronunciation feedback** — Evaluates spoken language against the reference
  text and returns personalized suggestions for improvement.

## Data

The project uses a sample audio file (`data/sample.wav`) containing Harvard
sentences — phonetically balanced sentences designed to cover the full range
of English sounds at their natural frequencies. Example: *"The stale smell of
old beer lingers."* This makes them a good benchmark for testing transcription
and pronunciation feedback.

## Tech

- Python
- OpenAI API (speech-to-text + `gpt-4o-mini`)

## Acknowledgements

Built as part of DataCamp's [Personalized Language Tutor](https://www.datacamp.com/projects/2599) project.
