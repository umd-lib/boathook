# frozen_string_literal: true

require 'mattock'

module Boathook
  class DockerImage
    attr :tag, :dockerfile, :context

    def initialize(tag:, dockerfile:, context:)
      @tag = tag
      @dockerfile = dockerfile
      @context = context
    end

    def description
      "#{tag} dockerfile=#{dockerfile} context=#{context}"
    end

    def build(label_pairs)
      label_args = label_pairs.map { |label| ['--label', label] }.flatten
      system 'docker', 'build', '-t', tag, *label_args, '-f', dockerfile, context
    end

    def push
      system 'docker', 'push', tag
    end
  end

  class DockerTasks < Mattock::TaskLib
    settings image_specs: [], version: 'dev'

    default_namespace :docker

    def define
      task :tags do
        images.each { |image| describe_image(image) }
      end

      task :build do
        images.each { |image| build_image(image) }
      end

      task :push do
        images.each { |image| push_image(image) }
      end
    end

    def describe_image(image)
      puts image.description + ' ' + label_pairs.join(' ')
    end

    def build_image(image)
      puts "Building #{image.description}"
      puts "With labels #{label_pairs}" if labels
      image.build(label_pairs)
    end

    def push_image(image)
      puts "Pushing #{image.tag}"
      image.push
    end

    def label_pairs
      labels.map { |k, v| "#{k}=#{v}" }
    end

    # Labels to add to each image. Include the application version, and the Git revision (for
    # distinguishing between "-dev" releases)
    def labels
      {
        'org.opencontainer.images.version': version_number,
        'org.opencontainer.images.revision': git_revision
      }
    end

    # Use "latest" for any development version (identified by the presence
    # of "dev" in the version number). Otherwise, just use the application
    # version.
    def version_number
      @version_number ||= version.include?('dev') ? 'latest' : version
    end

    def git_revision
      @git_revision ||= `git rev-parse HEAD`.chomp
    end

    def images
      @images ||= image_specs.map do |spec|
        Boathook::DockerImage.new(
          tag: "#{spec[:name]}:#{version_number}",
          dockerfile: spec[:dockerfile] || 'Dockerfile',
          context: spec[:context] || '.'
        )
      end
    end
  end
end
