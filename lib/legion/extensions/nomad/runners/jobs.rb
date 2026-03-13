# frozen_string_literal: true

require 'legion/extensions/nomad/helpers/client'

module Legion
  module Extensions
    module Nomad
      module Runners
        module Jobs
          include Legion::Extensions::Nomad::Helpers::Client

          def list_jobs(prefix: nil, **opts)
            params = {}
            params[:prefix] = prefix if prefix
            response = connection(**opts).get('/v1/jobs', params)
            { result: response.body }
          end

          def get_job(job_id:, **opts)
            response = connection(**opts).get("/v1/job/#{job_id}")
            { result: response.body }
          end

          def create_job(job:, **opts)
            response = connection(**opts).post('/v1/jobs', { Job: job })
            { result: response.body }
          end

          def update_job(job_id:, job:, **opts)
            response = connection(**opts).post("/v1/job/#{job_id}", { Job: job })
            { result: response.body }
          end

          def delete_job(job_id:, purge: false, **opts)
            params = {}
            params[:purge] = true if purge
            response = connection(**opts).delete("/v1/job/#{job_id}", params)
            { result: response.body }
          end

          def plan_job(job_id:, job:, diff: true, **opts)
            response = connection(**opts).post("/v1/job/#{job_id}/plan", { Job: job, Diff: diff })
            { result: response.body }
          end

          def dispatch_job(job_id:, payload: nil, meta: nil, **opts)
            body = {}
            body[:Payload] = payload if payload
            body[:Meta] = meta if meta
            response = connection(**opts).post("/v1/job/#{job_id}/dispatch", body)
            { result: response.body }
          end

          def revert_job(job_id:, version:, enforce_prior_version: nil, **opts)
            body = { JobID: job_id, JobVersion: version }
            body[:EnforcePriorVersion] = enforce_prior_version unless enforce_prior_version.nil?
            response = connection(**opts).post("/v1/job/#{job_id}/revert", body)
            { result: response.body }
          end

          def job_versions(job_id:, **opts)
            response = connection(**opts).get("/v1/job/#{job_id}/versions")
            { result: response.body }
          end

          def job_summary(job_id:, **opts)
            response = connection(**opts).get("/v1/job/#{job_id}/summary")
            { result: response.body }
          end

          def job_allocations(job_id:, **opts)
            response = connection(**opts).get("/v1/job/#{job_id}/allocations")
            { result: response.body }
          end

          def job_evaluations(job_id:, **opts)
            response = connection(**opts).get("/v1/job/#{job_id}/evaluations")
            { result: response.body }
          end

          def job_deployments(job_id:, **opts)
            response = connection(**opts).get("/v1/job/#{job_id}/deployments")
            { result: response.body }
          end

          def job_latest_deployment(job_id:, **opts)
            response = connection(**opts).get("/v1/job/#{job_id}/deployment")
            { result: response.body }
          end

          def evaluate_job(job_id:, **opts)
            response = connection(**opts).post("/v1/job/#{job_id}/evaluate")
            { result: response.body }
          end

          def force_periodic_job(job_id:, **opts)
            response = connection(**opts).post("/v1/job/#{job_id}/periodic/force")
            { result: response.body }
          end

          def scale_job(job_id:, group:, count: nil, message: nil, **opts)
            body = { Target: { Group: group } }
            body[:Count] = count unless count.nil?
            body[:Message] = message if message
            response = connection(**opts).post("/v1/job/#{job_id}/scale", body)
            { result: response.body }
          end

          def job_scale_status(job_id:, **opts)
            response = connection(**opts).get("/v1/job/#{job_id}/scale")
            { result: response.body }
          end

          def job_services(job_id:, **opts)
            response = connection(**opts).get("/v1/job/#{job_id}/services")
            { result: response.body }
          end

          def parse_job(hcl:, canonicalize: false, **opts)
            response = connection(**opts).post('/v1/jobs/parse', { JobHCL: hcl, Canonicalize: canonicalize })
            { result: response.body }
          end

          include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers) &&
                                                      Legion::Extensions::Helpers.const_defined?(:Lex)
        end
      end
    end
  end
end
