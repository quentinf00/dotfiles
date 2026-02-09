local M = {}

function M:peek(job)
    -- define the command
    local child = Command(os.getenv("HOME") .. ".pixi/envs/yazi/bin/python")
        :args({
            -- Make sure this path is absolute and correct
            os.getenv("HOME") .. "/.config/yazi/scripts/nc_preview.py",
            tostring(job.file.url),
        })
        :stdout(Command.PIPED)
        :stderr(Command.PIPED)
        :spawn()

    if not child then
        return
    end

    -- wait for the output
    local output, err = child:wait_with_output()

    -- Check if there was a spawn error
    if not output then
        ya.preview_widgets(job, {
            ui.Text("Spawn error: " .. tostring(err)):area(job.area),
        })
        return
    end

    -- Decide what to show: Stdout if it exists, otherwise Stderr
    local content = output.stdout
    if content == "" then
        content = "Error (stderr):\n" .. output.stderr
        -- If both are empty, say so
        if output.stderr == "" then
            content = "Empty output from python script."
        end
    end

    ya.preview_widgets(job, {
        ui.Text(content):area(job.area),
    })
end

function M:seek(job)
    -- empty
end

return M
