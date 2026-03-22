# CommonGround Phase 1: AI Chat Foundation

## Overview

A Rails 8 application providing AI-powered chat using the ruby-llm gem's built-in UI, with Google OAuth authentication. This is the foundation for a future multi-user, multi-platform AI-moderated chat system.

## Goals

- Working Rails 8 app with ruby-llm's scaffolded chat interface
- Google OAuth sign-in (only authenticated users can access chat)
- Claude as default LLM, configurable for additional providers later
- Local development only

## Stack

- **Framework:** Ruby on Rails 8 (latest)
- **Ruby:** 3.2+
- **Database:** SQLite (Rails 8 default)
- **AI:** ruby-llm gem with `rails generate ruby_llm:install` scaffold
- **Auth:** OmniAuth + omniauth-google-oauth2
- **Environment:** dotenv-rails for local credential management

## Architecture

### Authentication

- OmniAuth with Google OAuth 2.0 strategy
- Session-based authentication (Rails default)
- `before_action` filter gates all chat routes behind login
- Unauthenticated users redirect to Google sign-in
- Google OAuth credentials via environment variables (`GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`)

### Data Model

**User**
- `email` (string, from Google)
- `name` (string, from Google)
- `google_uid` (string, unique identifier from Google)
- `avatar_url` (string, from Google)
- `has_many :chats`

**Chat** (ruby-llm generated, extended)
- ruby-llm's default fields
- `belongs_to :user` (added association)

**Message** (ruby-llm generated)
- ruby-llm's default fields (`role`, `content`, `chat_id`, tool-call fields)

### Authorization

- Users can only see and interact with their own chats
- Simple ownership check — no role-based access control yet

### LLM Configuration

- ruby-llm initializer with Claude as default model
- `ANTHROPIC_API_KEY` via environment variable
- Provider/model configurable for future expansion

### Environment Variables

Documented in `.env.example`:
- `GOOGLE_CLIENT_ID` — Google OAuth client ID
- `GOOGLE_CLIENT_SECRET` — Google OAuth client secret
- `ANTHROPIC_API_KEY` — Anthropic API key for Claude

## Future Phases (Out of Scope)

- Multi-user chat rooms with AI moderation
- Additional OAuth providers (GitHub, Okta)
- Platform integrations (Slack, Discord, WhatsApp, mobile)
- Additional LLM providers
- Production hosting/deployment
