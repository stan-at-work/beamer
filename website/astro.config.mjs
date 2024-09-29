import starlight from '@astrojs/starlight';
import { defineConfig } from 'astro/config';

// https://astro.build/config
export default defineConfig({
    integrations: [
        starlight({
            title: 'Beamer',
            social: {
                github: 'https://github.com/slovnicki/beamer',
                discord: 'https://discord.com/invite/8hDJ7tP5Mz',
            },
            lastUpdated: true,
            credits: true,
            description: "A routing package built on top of Router and Navigator's pages API, supporting arbitrary nested navigation, guards and more.",
            favicon: '/favicon.png',
            logo: {
                src: '/src/assets/logo.png',
                replacesTitle: true,
            },
            sidebar: [
                {
                    label: 'Getting Started',
                    items: ['getting-started/install', 'getting-started/about'],
                },
                {
                    label: 'Quick Start',
                    items: ['quick-start/routes-stack-builder', 'quick-start/navigating', 'quick-start/navigating-back', 'quick-start/accessing-nearest-beamer'],
                },
                {
                    label: 'Key Concepts',
                    items: ['concepts/stack', 'concepts/stack-builder', 'concepts/state', 'concepts/guard', 'concepts/interceptor', 'concepts/nested-navigation'],
                },
                {
                    label: 'Trips And Issues',
                    items: ['tips-and-issues/tips', 'tips-and-issues/losing-state'],
                },
                {
                    label: 'Resources',
                    items: ['resources'],
                },
                {
                    label: 'Contributing',
                    items: ['contributing'],
                },
            ],
        }),
    ],
});
