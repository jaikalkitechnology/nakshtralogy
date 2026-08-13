// Profile-photo picker for edit modals: current photo (or letter fallback) +
// Upload/Replace control. Files go through the existing admin image upload
// (POST /admin/uploads/image → hosted URL); the URL is handed back via
// onChange for the caller to include in its PATCH body on save.

import { useState } from 'react'
import { adminApi } from '../api/endpoints'

interface Props {
  url: string | null
  fallbackLetter: string
  onChange: (url: string) => void
}

export function ProfilePhotoField({ url, fallbackLetter, onChange }: Props) {
  const [uploading, setUploading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  async function handleFile(file: File) {
    setUploading(true); setError(null)
    try {
      const res = await adminApi.uploadImage(file)
      onChange(res.url)
    } catch (e) { setError((e as Error).message) } finally { setUploading(false) }
  }

  return (
    <div>
      <div className="flex items-center gap-4 rounded-xl border border-border-soft bg-surface-1 p-3.5">
        {url ? (
          <img src={url} alt="Profile" className="h-14 w-14 rounded-xl object-cover border border-border-soft bg-surface-2" />
        ) : (
          <div className="grid h-14 w-14 place-items-center rounded-xl bg-saffron-soft border border-saffron/15 text-[18px] font-bold text-saffron">{fallbackLetter}</div>
        )}
        <div className="min-w-0 flex-1">
          <div className="text-[12px] font-semibold">Profile photo</div>
          <div className="mt-0.5 text-[11px] text-ivory-faint">{url ? 'Click to replace with a new image.' : 'No photo yet — upload one.'}</div>
        </div>
        <label className={`shrink-0 h-9 inline-flex items-center rounded-full border border-border-soft bg-surface-raised px-4 text-[12px] font-bold cursor-pointer hover:bg-surface-2 transition-colors ${uploading ? 'opacity-50 pointer-events-none' : ''}`}>
          {uploading ? 'Uploading…' : url ? 'Replace' : 'Upload'}
          <input type="file" accept="image/*" className="hidden" disabled={uploading} onChange={e => { const f = e.target.files?.[0]; if (f) void handleFile(f); e.target.value = '' }} />
        </label>
      </div>
      {error && <div className="mt-2 rounded-lg border border-red-500/20 bg-red-500/10 px-3 py-2 text-[12px] text-red-400">{error}</div>}
    </div>
  )
}
